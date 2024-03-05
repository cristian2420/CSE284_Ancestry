
library(data.table)
library(here)
suppressPackageStartupMessages(require(optparse))

option_list = list(
  make_option(c("-i", "--inputpath"), action="store", default=NA, type='character',
              help="path where the msp files are located. One folder per chromosome."),
  make_option(c("-f", "--ifile"), action="store", default="query_results.msp", type='character',
              help="Name of the msp file to be processed. [default %default]"),
  make_option(c("-o", "--ofile"), action="store", default="karyotype.bp", type='character',
              help="Name of the output file. [default %default]"),
  make_option(c("-d", "--donor"), action="store", default=NULL,
              help="Name of the donor, multiple donors should be separate by a comma (donor1,donor2). If specified, the output will only contain a single donor. [default %default]")
)
opt = parse_args(OptionParser(option_list=option_list))
## DEBUG
if(FALSE){
  opt <- list(
    inputpath = "results_gnomix/AMR_all/",
    ifile = "query_results.msp",
    ofile = "karyotype.bp",
    donor = "HG01173,NA19777"
  )
}

if(!is.null(opt$donor)){
  donors <- unlist(strsplit(opt$donor, ","))
}

alldata <- data.table::rbindlist(lapply(1:22, function(chr){
  ifile <- here::here(opt$inputpath, chr, opt$ifile)
  header <- readLines(ifile)[1]
  header <- strsplit(gsub("^[^:]+: ", "", header), '\t')[[1]]
  header <- strsplit(header, '=')
  populations <- lapply(header, function(vec) vec[1])
  popcode <- sapply(header, function(vec) vec[2])
  names(populations) <- paste0("pop_", popcode)

  cFile <- fread(ifile)
  if(!is.null(opt$donor)){
    idx <- which(gsub("\\..+", "", names(cFile)) %in% donors)
    if(length(idx) == 0){
      stop("Donor not found in the file")
    }
    cFile <- cFile[, c(1,2,4,idx), with =F]
  }
  cFile <- melt(cFile, id.vars = c("#chm", "spos", "sgpos"))
  cFile <- cFile[, c(4,5,1:3)]
  cFile[, value := paste0("pop_", value)]
  cFile$value <- unlist(populations[cFile$value])
  return(cFile)
}))

alldata[, variable := gsub("\\.0$", "_1", variable)]
alldata[, variable := gsub("\\.1$", "_2", variable)]

all_lines <- unlist(lapply(unique(alldata$variable), function(donor){
  tpmdf <- alldata[variable == donor]
  tpmdf$variable <- NULL
  return(c(donor, gsub(" ", "", apply(tpmdf, 1, function(x) paste(x, collapse = "\t")))))
}))

writeLines(all_lines, opt$ofile)


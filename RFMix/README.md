## Local Ancestry Inference using RFMix 
### About
RFMIX is a program to identify the ancestry of genomic segments using random forest discriminative machine learning methods combined with a conditional random field model of the linear chromosome. 
Run the program with no command line options to see a list of options accepted and a terse description of what they do. This help message is intended primarily as a reminder for how to run the program.

### QUICKSTART
The following command was used to run RFMix:

~~~~~~~~~~~~
rfmix -f <query VCF/BCF file>
	-r <reference VCF/BCF file>
	-m <sample map file>
	-g <genetic map file>
	-o <output basename>
	--chromosome=<chromosome to analyze>
~~~~~~~~~~~~

The genetic map file is tab delimited text containing at least 3 columns: chromosome, physical position in bp, genetic position in cM. 

The sample map file specifies which subpopulation each reference sample represents. It is tab delimited text with at least two columns: sample name, subpopulation name.

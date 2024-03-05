#!/bin/bash -ex

WORKDIR=/mnt/BioAdHoc/Groups/vd-ay/dsfigueroa/PhD/CSE284_PersonalGenomics/project
BINDIR=/home/dsfigueroa/software

for CHR in $(seq 21 22); do
	for SAMPLE_SIZE in all 150 250 350; do

cat << EOF > rfmix_chr${CHR}_${SAMPLE_SIZE}_samples.sh
#!/bin/bash -ex

#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=5
#SBATCH --mem=550g
#SBATCH --time=150:00:00
#SBATCH --output=%x-%j.out
#SBATCH --mail-type=FAIL

OUTDIR=${WORKDIR}/results/${SAMPLE_SIZE}_samples

mkdir -p \${OUTDIR}

#==========================
# Run rFMix
#==========================

cd \${OUTDIR}

#The following options are required:
# -f <query VCF/BCF file>
# -r <reference VCF/BCF file>
# -m <sample map file>
# -g <genetic map file>
# -o <output basename>
# --chromosome=<chromosome to analyze>
		
${BINDIR}/rfmix/rfmix -f ${WORKDIR}/datasets/vcf_subset/AMR_${SAMPLE_SIZE}_samples_chr${CHR}.vcf.gz \
		-r ${WORKDIR}/datasets/vcf_subset/ref_chr${CHR}.vcf.gz \
		-m ${WORKDIR}/datasets/ref_sample_map.txt \
		-g ${WORKDIR}/datasets/chr${CHR}_genetic_map.txt \
		-o rfmix_chr${CHR} \
		--chromosome=${CHR} > rfmix_chr${CHR}.log

EOF

sbatch rfmix_chr${CHR}_${SAMPLE_SIZE}_samples.sh

	done
done 




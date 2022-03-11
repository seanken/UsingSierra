#! /bin/bash

#$ -cwd
#$ -e ErrFiles/err.$TASK_ID.err
#$ -o ErrFiles/out.$TASK_ID.log
#$ -q broad
#$ -P regevlab
#$ -l h_vmem=60g
#$ -l h_rt=120:00:00
#$ -l os="RedHat7"

#$ -t 1-14

source /broad/software/scripts/useuse

source ~/ForPyth.sh

SEEDFILE=samps.txt



use BEDTools
use .samtools-1.8
use .java-jdk-1.8.0_181-x86-64

export PATH=$PATH:/stanley/sheng-lab/ssimmons/Grin2/SingleNuc/IsoformUsage/Sierra/New/regtools/regtools/build
conda activate Milo

nextflow=/stanley/levin_asap/ssimmons/eQTL/Code/AlleleExpressionPipeline/version2.0/ASE_pipeline/nextflow
pipeline=/stanley/sheng-lab/ssimmons/Grin2/SingleNuc/IsoformUsage/Sierra/New/Code/GetPeaks.nf

SEEDFILE=samps.txt

samp=$(awk "NR==$SGE_TASK_ID" $SEEDFILE | awk '{print $1}')
bam=$(awk "NR==$SGE_TASK_ID" $SEEDFILE | awk '{print $2}')
DS=$(awk "NR==$SGE_TASK_ID" $SEEDFILE | awk '{print $3}')
cells=$(awk "NR==$SGE_TASK_ID" $SEEDFILE | awk '{print $4}')
gtf=/stanley/levin_dr/ssimmons/Schema/Analysis/DownstreamAnalysis/Bulk/GetQC/Code/ref/genes.gtf

dir=samp_$samp
mkdir $dir
cd $dir

outdir=output

$nextflow $pipeline --bam $bam --DS $DS --gtf $gtf --cells $cells --outdir $outdir


params.DS=1.0 //The probability to DS to
params.bam //The input bam
params.outdir //The ouput directory
params.gtf //The gtf to use
params.cells //pointer to cell barcodes
params.PICARD="$projectDir/jar/picard.jar" //The picard jar file
params.callPeaks="$projectDir/scripts/GetPeaks.R" //The Rscript to call peaks using Sierra

process DS_Bam
{
publishDir "${params.outdir}/Bam", mode: 'rellink'

input:
path bam, stageAs:"input.bam" from params.bam
path pic, stageAs:"picard.jar" from params.PICARD
env Prob from params.DS

output:
path "DS.bam" into DS_bam
path "DS.bam.bai" into DS_bam_bai

'''
samtools index input.bam
java -jar picard.jar DownsampleSam I=input.bam O=DS.bam P=$Prob
samtools index DS.bam
'''

}

process SaveCells
{
publishDir "${params.outdir}/Cells", mode: 'rellink'

input:
path cells, stageAs:"cells.txt" from params.cells

output:
path 'cells.txt' into cell_names

'''
echo Save Cells
'''

}

process MakeJunction
{
publishDir "${params.outdir}/Juncs", mode: 'rellink'

input:
path bam, stageAs:"DS.bam" from DS_bam
path bai, stageAs:"DS.bam.bai" from DS_bam_bai

output:
path "juncs.bed" into juncs

'''
regtools junctions extract -s 1 DS.bam -o juncs.bed
'''

}



process CallPeaks
{
publishDir "${params.outdir}/Peaks", mode: 'rellink'

input:
path bam, stageAs:"DS.bam" from DS_bam
path bai, stageAs:"DS.bam.bai" from DS_bam_bai
path juncs, stageAs:"juncs.bed" from juncs
path callPeaks, stageAs:"GetPeaks.R" from params.callPeaks
path gtf, stageAs:"genes.gtf" from params.gtf

output:
path "juncs.bed.peaks.txt" into peaks

'''
Rscript GetPeaks.R DS.bam juncs.bed
'''

}




library(Sierra)
library(tictoc)
getPeaks<-function(bamfile,bedfile,outfile,gtf="genes.gtf",ncores=1)#,gtf="/stanley/sheng-lab/ssimmons/Grin2/SingleNuc/IsoformUsage/Sierra/Code/genes.with.chr.gtf") #/stanley/levin_dr_storage/refs/CellRanger/refdata-cellranger-mm10-2.1.0/genes/genes.gtf")
{
print("Find Peaks!")
FindPeaks(output.file =outfile,gtf.file=gtf,bamfile=bamfile,junctions.file=bedfile,ncores=ncores)
}



if(!interactive())
{
print("Load data!")
args = commandArgs(trailingOnly=TRUE)
bamfile=args[1]
bedfile=args[2]
ncores=1
if(length(args)>2)
{
ncores=args[3]
}
outfile=paste(bedfile,".peaks.txt",sep="")
tic()
getPeaks(bamfile,bedfile,outfile,ncores=ncores)
toc()
}

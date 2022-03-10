library(Sierra)

if(!interactive())
{
args = commandArgs(trailingOnly=TRUE)
sampfile=args[1] ##File with table with 2 columns, one named Samples with sample names and one named Pipeline with pipeline output locations
gtf=args[2]
outdir=args[3]

outfile=paste(outdir,"/merged.peaks.txt",sep="")
dat=read.table(sampfile,sep="\t",header=T,stringsAsFactors=F)
print("Merge!")
if("Pipeline" in colnames(dat))
{
dat["Peaks"]=sub("$","/Peaks/juncs.bed.peaks.txt",dat[,"Pipeline"])
dat["Bams"]=sub("$","/Bam/input.bam",dat[,"Pipeline"])
dat["Cells"]=sub("$","/Cells/cells.txt",dat[,"Pipeline"])
}

tab=dat.frame(Peak_file = dat[,"Peaks"],Identifier=dat[,"Sample"])
MergePeakCoordinates(tab,outfile,ncores=1)
print("Count Peaks")
for(i in 1:dim(dat)[1])
{
bam=dat[i,"Bams"]
cell=dat[i,"Cells"]
samp=dat[i,"Sample"]
print("Counting for:")
print(samp)
countFile=paste(outdir,"/counts_",samp,"_out",sep="")
CountPeaks(peak.sites.file=outfile,gtf.file=gtf,bamfile=bam,whitelist.file=cell,output.dir=countFile,countUMI=T,ncores=1)
}

}

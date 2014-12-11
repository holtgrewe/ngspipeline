#!/usr/bin/env Rscript

## FUNC

plotCoverage<- function(inFile, outFile=NULL){
	if(is.null(outFile)){
		outFile<- paste(substr(file,1,nchar(file)-3),"pdf",sep="")
	}
	print(paste("outfile: ",outFile,sep=""))
	pdf(outFile)
	dat<- read.table(inFile,header=F,sep="\t")
	xend = nrow(dat)
	while(dat[xend,5] < 0.0001){
		xend = xend -1
	}
	plot(dat[,c(2,5)],type="l",xlab="coverage",ylab="fraction",xlim=c(0,xend))
	dev.off()
}

## MAIN

args<- commandArgs(trailingOnly = TRUE)
inFile<- args[1]
outFile<- args[2]
print(paste("[INFO] Plot: ",inFile,sep=""))
plotCoverage(inFile,outFile)



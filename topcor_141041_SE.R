##############################################################
setwd("/home/fas/seto/bc643/project//scratch60_temp/141041Imagestack")
library(rgdal)
library(raster)
library(RStoolbox)

files <- list.files()

###############################################################
if (file.exists('/home/fas/seto/bc643/scratch60/grace1/141041_topCor_SE')==FALSE) {
	dir.create('/home/fas/seto/bc643/scratch60/grace1/141041_topCor_SE', showWarnings = TRUE)
}

for(i in 1:length(files)){
	library(rgdal)
	library(raster)
	###############################################################
	#e.g., /home/fas/seto/bc643/scratch60/grace1/141041clipped/LC081410412013042401T1_clipped
	wkdir <- paste0("/home/fas/seto/bc643/project//scratch60_temp/141041Imagestack/",files[i],sep='')
	setwd(wkdir)
	files1 <- list.files()
	tifNameFirstPart <- strsplit(files1[1],'[.]')[[1]][1] #e.g., LC081410412013042401T1
	outfile = paste(tifNameFirstPart,"topCor_SE",sep='_')
	files2 <- files1[1]
	#Stack bands 1,2,3,4,5,6&thermal

	###############################################################
	fullpath <- paste0("/home/fas/seto/bc643/scratch60/grace1/141041_topCor_SE/",outfile,sep='')
	fullpathTif_se <- paste0(fullpath,"/",outfile,sep='')
	if (file.exists(fullpath)==FALSE) {
		dir.create(fullpath, showWarnings = TRUE)
		print(fullpathTif_se)
		tif <- stack(files2, bands = as.integer(c(1,2,3,4,5,6,7)))

		###############################################################
		wholesrtm <- raster("/home/fas/seto/bc643/scratch60/grace1/141041_SRTM_mosaic_tif.tif")


		#crop, reproject and resample the SRTM
		wholesrtm_30_utm <- projectRaster(wholesrtm, tif, res, crs, method="bilinear", alignOnly=FALSE, over=FALSE)
		mysrtm <- wholesrtm_30_utm

		m = raster(files2,band=8)
		m[m==66|m==130|m==322|m==386|m==400|m==834|m==898|m==1346] <- 2   #mark the values of water&cloud-free clear pixels as 2
	
		if(sum(m[]!=2)==ncell(tif)){
			file.remove(fullpath)
			next
		}
		else{
			m[m!=2]<-NA    #change the values of water and cloud pixels into NA

			tif_masked <- mask(tif,m)    #mask out water and cloud

			#tif_se <- topCor(tif, dem = mysrtm, metaData = files1[2], method = "stat")
			tif_se <- topCor(tif_masked, dem = mysrtm, metaData = files1[2], method = "stat")

			writeRaster(tif_se,fullpathTif_se,format="GTiff",datatype='INT2S')
			print(fullpathTif_se)
		}
	}
	else{next}
}
#Careli Caballero and Jan Droesen
#Team  CarJan
#01-11-2016

#
library(sp)
library(raster)
library(rgeos)

#download the files
railwayShp <- shapefile('data/Railways/railways.shp')
placesShp <- shapefile('data/Places/places.shp')

#visual check of shapefiles
plot(railwayShp)
plot(placesShp)

#select industrial railways type == "industrial"
industrialrail <- railwayShp[railwayShp$type == "industrial",]

#project industrialrail and places in RDnew
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
(placesRD <- spTransform(placesShp, prj_string_RD))
(railRD <- spTransform(industrialrail, prj_string_RD))

#create buffer around industrial rails with 1000 m
bufferRail <- gBuffer(railRD, byid=TRUE, width=1000)

#intersect the buffer with cities
intersect <- (gIntersection(placesRD, bufferRail, byid=TRUE))
row.names(gIntersection(placesRD, bufferRail, byid=TRUE))
intersectstring <- strsplit(row.names(gIntersection(placesRD, bufferRail, byid=TRUE)), split = ' ')
citycode <- as.numeric(intersect[[1]][1])
#Create a plot that shows the buffer, the points, and the name of the city
plot(bufferRail)
plot(intersect, add=TRUE) 
#add labels to plot and maybe visualize
text(placesRD[citycode,], labels=as.character(placesRD[citycode,]$name), cex=0.6, font=2)


#write down the name of the city and the population of that city as one comment at the end of the script.
paste("Cityname =", placesRD[citycode,]$name)
paste("Population =", placesRD[citycode,]$population)







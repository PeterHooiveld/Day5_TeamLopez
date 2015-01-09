### Team Lopez members: Peter Hooiveld & Bart Driessen.
### Date: 9 january 2015

### step 1: Setting global settings.
library(rgdal)
library(sp)
library(downloader)
library(rgeos)

### step 2: Download all the data and unzip it.
download(url= "http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip", destfile="data/netherlands-railways-shape.zip", mode="wb")
download(url= "http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip",destfile= "data/netherlands-places-shape.zip", mode="wb")
unzip("data/netherlands-places-shape.zip",exdir="data/places")
unzip("data/netherlands-railways-shape.zip",exdir="data/rail" )

### step 3: Read in the data.
#List the filenames
railfile = list.files("data/rail/", pattern=glob2rx("*.shp*"), full.names=T) 
placesfile = list.files("data/places/", pattern=glob2rx("*.shp*"), full.names=T) 

#read-in the files
rails <- readOGR(railfile, layer=ogrListLayers(railfile))
places <- readOGR(placesfile, layer=ogrListLayers(placesfile))

### step 4: subset by rails type == "industrial".
railssub <- rails[rails$type == "industrial",]
spplot(railssub)

### step 5: create buffer of 1000M.

# Reproject railssub for buffering
# Defining projections
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
railssub <- spTransform(railssub,prj_string_RD)
# Create buffer of 1000M
buffer <- gBuffer(railssub, width=1000, byid = T)
plot (buffer)

### step 6: Buffer intersections with cities.
# Reproject places in RD
places <- spTransform(places,prj_string_RD)

# Implement intersection
intersects <- gIntersection(places, buffer,byid=T)
plot (intersects)

### step 7: Plot buffer, city points and city names.(special for you Bart)
plot(buffer)

### step 8: Cityname and population (Utrecht and 100000)
placeID <- 5973
places@data$name[placeID]
places@data$population[placeID]

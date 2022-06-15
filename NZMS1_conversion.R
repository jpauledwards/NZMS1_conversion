# This script converts NZMS1 map references, found in DIGAD, to more useful latitude longitude data

library(tidyverse)
library(sf)
library(here)
library(utils)

sf_extSoftVersion()[1:3]

# Projections
NIYG <- "+proj=tmerc +lat_0=-39 +lon_0=175.5 +k=1.0000017338 +x_0=274320  +y_0=365760   +ellps=intl +datum=nzgd49 +units=yd +no_defs"
SIYG <- "+proj=tmerc +lat_0=-44 +lon_0=171.5 +k=1.0000017338 +x_0=457200  +y_0=457200   +ellps=intl +datum=nzgd49 +units=yd +no_defs"
NZTM <- "+proj=tmerc +lat_0=0   +lon_0=173   +k=0.9996       +x_0=1600000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
# NZMG <- "+proj=nzmg  +lat_0=-41 +lon_0=173 +x_0=2510000                 +y_0=6023150  +ellps=intl +datum=nzgd49 +units=m +towgs84=59.47,-5.04,187.44,0.47,-0.1,1.024,-4.5993 +nadgrids=nzgd2kgrid0005.gsb +no_defs"
# NZMG

# n.b. it looks like NZMG needs this file - nzgd2kgrid0005.gsb
# Available at LINZ link below (and now copied into this repo, see file list), but where does it need to go on your computer?
# https://www.linz.govt.nz/data/geodetic-system/download-geodetic-software/gd2000it-download
# The answer is, copy the file nzgd2kgrid0005.gsb from this project folder, to the "proj" folder, in your "rgdal" folder, wherever your R packages are saved. Then it should work.

# option 2, use short path name to point to location in this project
NZMG <- paste0("+proj=nzmg  +lat_0=-41 +lon_0=173 +x_0=2510000 +y_0=6023150  +ellps=intl +datum=nzgd49 +units=m +towgs84=59.47,-5.04,187.44,0.47,-0.1,1.024,-4.5993 +nadgrids=", shortPathName(here()), "/nzgd2kgrid0005.gsb +no_defs")
NZMG

# Load data
MapRefCoords <- read.csv("InputCoordsExample.csv")

# Map sheet references
MapSheets <- tribble(
  ~Sheet, ~SheetNorth, ~SheetEast,
  "N1", 940000, -15000,
  "N2", 940000, 30000,
  "N3", 910000, -15000,
  "N4", 910000, 30000,
  "N5", 910000, 75000,
  "N6", 880000, 30000,
  "N7", 880000, 75000,
  "N8", 880000, 120000,
  "N9", 850000, 30000,
  "N10", 850000, 75000,
  "N11", 850000, 120000,
  "N12", 850000, 165000,
  "N13", 820000, 30000,
  "N14", 820000, 75000,
  "N15", 820000, 120000,
  "N16", 820000, 165000,
  "N17", 820000, 210000,
  "N18", 790000, 75000,
  "N19", 790000, 120000,
  "N20", 790000, 165000,
  "N21", 790000, 210000,
  "N22", 760000, 75000,
  "N23", 760000, 120000,
  "N24", 760000, 165000,
  "N25", 760000, 210000,
  "N26", 760000, 255000,
  "N27", 730000, 120000,
  "N28", 730000, 165000,
  "N29", 730000, 210000,
  "N30", 730000, 255000,
  "N31", 730000, 300000,
  "N32", 700000, 120000,
  "N33", 700000, 165000,
  "N34", 700000, 210000,
  "N35", 700000, 255000,
  "N36", 700000, 300000,
  "N37", 670000, 165000,
  "N38", 670000, 210000,
  "N39", 670000, 255000,
  "N40", 670000, 300000,
  "N41", 640000, 165000,
  "N42", 640000, 210000,
  "N43", 640000, 255000,
  "N44", 640000, 300000,
  "N45", 640000, 345000,
  "N46", 610000, 165000,
  "N47", 610000, 210000,
  "N48", 610000, 255000,
  "N49", 610000, 300000,
  "N50", 610000, 345000,
  "N51", 580000, 210000,
  "N52", 580000, 255000,
  "N53", 580000, 300000,
  "N54", 580000, 345000,
  "N55", 550000, 210000,
  "N56", 550000, 255000,
  "N57", 550000, 300000,
  "N58", 550000, 345000,
  "N59", 550000, 390000,
  "N60", 550000, 435000,
  "N61", 550000, 480000,
  "N62", 550000, 525000,
  "N63", 550000, 570000,
  "N64", 520000, 210000,
  "N65", 520000, 255000,
  "N66", 520000, 300000,
  "N67", 520000, 345000,
  "N68", 520000, 390000,
  "N69", 520000, 435000,
  "N70", 520000, 480000,
  "N71", 520000, 525000,
  "N72", 520000, 570000,
  "N73", 490000, 210000,
  "N74", 490000, 255000,
  "N75", 490000, 300000,
  "N76", 490000, 345000,
  "N77", 490000, 390000,
  "N78", 490000, 435000,
  "N79", 490000, 480000,
  "N80", 490000, 525000,
  "N81", 490000, 570000,
  "N82", 460000, 210000,
  "N83", 460000, 255000,
  "N84", 460000, 300000,
  "N85", 460000, 345000,
  "N86", 460000, 390000,
  "N87", 460000, 435000,
  "N88", 460000, 480000,
  "N89", 460000, 525000,
  "N90", 460000, 570000,
  "N91", 430000, 210000,
  "N92", 430000, 255000,
  "N93", 430000, 300000,
  "N94", 430000, 345000,
  "N95", 430000, 390000,
  "N96", 430000, 435000,
  "N97", 430000, 480000,
  "N98", 430000, 525000,
  "N99", 400000, 165000,
  "N100", 400000, 210000,
  "N101", 400000, 255000,
  "N102", 400000, 300000,
  "N103", 400000, 345000,
  "N104", 400000, 390000,
  "N105", 400000, 435000,
  "N106", 400000, 480000,
  "N107", 400000, 525000,
  "N108", 370000, 120000,
  "N109", 370000, 165000,
  "N110", 370000, 210000,
  "N111", 370000, 255000,
  "N112", 370000, 300000,
  "N113", 370000, 345000,
  "N114", 370000, 390000,
  "N115", 370000, 435000,
  "N116", 370000, 480000,
  "N117", 370000, 525000,
  "N118", 340000, 120000,
  "N119", 340000, 165000,
  "N120", 340000, 210000,
  "N121", 340000, 255000,
  "N122", 340000, 300000,
  "N123", 340000, 345000,
  "N124", 340000, 390000,
  "N125", 340000, 435000,
  "N126", 340000, 480000,
  "N127", 340000, 525000,
  "N128", 310000, 120000,
  "N129", 310000, 165000,
  "N130", 310000, 210000,
  "N131", 310000, 255000,
  "N132", 310000, 300000,
  "N133", 310000, 345000,
  "N134", 310000, 390000,
  "N135", 310000, 435000,
  "N136", 280000, 165000,
  "N137", 280000, 210000,
  "N138", 280000, 255000,
  "N139", 280000, 300000,
  "N140", 280000, 345000,
  "N141", 280000, 390000,
  "N142", 280000, 435000,
  "N143", 250000, 255000,
  "N144", 250000, 300000,
  "N145", 250000, 345000,
  "N146", 250000, 390000,
  "N147", 250000, 435000,
  "N148", 220000, 255000,
  "N149", 220000, 300000,
  "N150", 220000, 345000,
  "N151", 220000, 390000,
  "N152", 190000, 255000,
  "N153", 190000, 300000,
  "N154", 190000, 345000,
  "N155", 190000, 390000,
  "N156", 160000, 210000,
  "N157", 160000, 255000,
  "N158", 160000, 300000,
  "N159", 160000, 345000,
  "N160", 130000, 210000,
  "N161", 130000, 255000,
  "N162", 130000, 300000,
  "N163", 130000, 345000,
  "N164", 100000, 210000,
  "N165", 100000, 255000,
  "N166", 100000, 300000,
  "N167", 100000, 345000,
  "N168", 70000, 255000,
  "N169", 70000, 30000,
  "S1", 920000, 590000,
  "S2", 890000, 545000,
  "S3", 890000, 590000,
  "S4", 890000, 635000,
  "S5", 890000, 680000,
  "S6", 890000, 725000,
  "S7", 860000, 545000,
  "S8", 860000, 590000,
  "S9", 860000, 635000,
  "S10", 860000, 680000,
  "S11", 860000, 725000,
  "S12", 830000, 545000,
  "S13", 830000, 590000,
  "S14", 830000, 635000,
  "S15", 830000, 680000,
  "S16", 830000, 725000,
  "S17", 800000, 500000,
  "S18", 800000, 545000,
  "S19", 800000, 590000,
  "S20", 800000, 635000,
  "S21", 800000, 680000,
  "S22", 800000, 725000,
  "S23", 770000, 455000,
  "S24", 770000, 500000,
  "S25", 770000, 545000,
  "S26", 770000, 590000,
  "S27", 770000, 635000,
  "S28", 770000, 680000,
  "S29", 770000, 725000,
  "S30", 740000, 455000,
  "S31", 740000, 500000,
  "S32", 740000, 545000,
  "S33", 740000, 590000,
  "S34", 740000, 635000,
  "S35", 740000, 680000,
  "S36", 740000, 725000,
  "S37", 710000, 455000,
  "S38", 710000, 500000,
  "S39", 710000, 545000,
  "S40", 710000, 590000,
  "S41", 710000, 635000,
  "S42", 710000, 680000,
  "S43", 710000, 725000,
  "S44", 680000, 455000,
  "S45", 680000, 500000,
  "S46", 680000, 545000,
  "S47", 680000, 590000,
  "S48", 680000, 635000,
  "S49", 680000, 680000,
  "S50", 650000, 410000,
  "S51", 650000, 455000,
  "S52", 650000, 500000,
  "S53", 650000, 545000,
  "S54", 650000, 590000,
  "S55", 650000, 635000,
  "S56", 650000, 680000,
  "S57", 620000, 410000,
  "S58", 620000, 455000,
  "S59", 620000, 500000,
  "S60", 620000, 545000,
  "S61", 620000, 590000,
  "S62", 620000, 635000,
  "S63", 590000, 365000,
  "S64", 590000, 410000,
  "S65", 590000, 455000,
  "S66", 590000, 500000,
  "S67", 590000, 545000,
  "S68", 590000, 590000,
  "S69", 590000, 635000,
  "S70", 560000, 320000,
  "S71", 560000, 365000,
  "S72", 560000, 410000,
  "S73", 560000, 455000,
  "S74", 560000, 500000,
  "S75", 560000, 545000,
  "S76", 560000, 590000,
  "S77", 530000, 275000,
  "S78", 530000, 320000,
  "S79", 530000, 365000,
  "S80", 530000, 410000,
  "S81", 530000, 455000,
  "S82", 530000, 500000,
  "S83", 530000, 545000,
  "S84", 530000, 590000,
  "S85", 530000, 635000,
  "S86", 500000, 230000,
  "S87", 500000, 275000,
  "S88", 500000, 320000,
  "S89", 500000, 365000,
  "S90", 500000, 410000,
  "S91", 500000, 455000,
  "S92", 500000, 500000,
  "S93", 500000, 545000,
  "S94", 500000, 590000,
  "S95", 500000, 635000,
  "S96", 470000, 185000,
  "S97", 470000, 230000,
  "S98", 470000, 275000,
  "S99", 470000, 320000,
  "S100", 470000, 365000,
  "S101", 470000, 410000,
  "S102", 470000, 455000,
  "S103", 470000, 500000,
  "S104", 440000, 140000,
  "S105", 440000, 185000,
  "S106", 440000, 230000,
  "S107", 440000, 275000,
  "S108", 440000, 320000,
  "S109", 440000, 365000,
  "S110", 440000, 410000,
  "S111", 440000, 455000,
  "S112", 410000, 140000,
  "S113", 410000, 185000,
  "S114", 410000, 230000,
  "S115", 410000, 275000,
  "S116", 410000, 320000,
  "S117", 410000, 365000,
  "S118", 410000, 410000,
  "S119", 410000, 455000,
  "S120", 380000, 95000,
  "S121", 380000, 140000,
  "S122", 380000, 185000,
  "S123", 380000, 230000,
  "S124", 380000, 275000,
  "S125", 380000, 320000,
  "S126", 380000, 365000,
  "S127", 380000, 410000,
  "S128", 380000, 455000,
  "S129", 350000, 95000,
  "S130", 350000, 140000,
  "S131", 350000, 185000,
  "S132", 350000, 230000,
  "S133", 350000, 275000,
  "S134", 350000, 320000,
  "S135", 350000, 365000,
  "S136", 350000, 410000,
  "S137", 350000, 455000,
  "S138", 320000, 50000,
  "S139", 320000, 95000,
  "S140", 320000, 140000,
  "S141", 320000, 185000,
  "S142", 320000, 230000,
  "S143", 320000, 275000,
  "S144", 320000, 320000,
  "S145", 320000, 365000,
  "S146", 320000, 410000,
  "S147", 290000, 50000,
  "S148", 290000, 95000,
  "S149", 290000, 140000,
  "S150", 290000, 185000,
  "S151", 290000, 230000,
  "S152", 290000, 275000,
  "S153", 290000, 320000,
  "S154", 290000, 365000,
  "S155", 290000, 410000,
  "S156", 260000, 50000,
  "S157", 260000, 95000,
  "S158", 260000, 140000,
  "S159", 260000, 185000,
  "S160", 260000, 230000,
  "S161", 260000, 275000,
  "S162", 260000, 320000,
  "S163", 260000, 365000,
  "S164", 260000, 410000,
  "S165", 230000, 50000,
  "S166", 230000, 95000,
  "S167", 230000, 140000,
  "S168", 230000, 185000,
  "S169", 230000, 230000,
  "S170", 230000, 275000,
  "S171", 230000, 320000,
  "S172", 230000, 365000,
  "S173", 200000, 50000,
  "S174", 200000, 95000,
  "S175", 200000, 140000,
  "S176", 200000, 185000,
  "S177", 200000, 230000,
  "S178", 200000, 275000,
  "S179", 200000, 320000,
  "S180", 200000, 365000,
  "S181", 170000, 185000,
  "S182", 170000, 230000,
  "S183", 170000, 275000,
  "S184", 170000, 320000,
  "S185", 140000, 140000,
  "S186", 140000, 185000,
  "S187", 140000, 230000,
  "S188", 110000, 140000,
  "S189", 110000, 185000,
  "S190", 80000, 140000,
  "S191", 80000, 18500
)

# Convert map references to yard grid
MapRefCoords2 <- MapRefCoords %>%
  separate("MapRef", c("Island", "SheetNo", "MapRefEast", "MapRefNorth"), sep = c(1, 4, 7), remove = FALSE, convert = FALSE, extra = "merge") %>%
  mutate(LINZ = paste0(Island, as.integer(SheetNo), " ", MapRefEast, " ", MapRefNorth)) %>%
  mutate(Sheet = paste0(Island, as.integer(SheetNo))) %>%
  left_join(MapSheets, by = c("Sheet")) %>%
  mutate(EastYard = ifelse(round(floor(SheetEast * 10^-5) / 10^-5, digits = 0) + as.integer(MapRefEast) * 100 < SheetEast, round(floor(SheetEast * 10^-5) / 10^-5, digits = 0) + as.integer(MapRefEast) * 100 + 100000, round(floor(SheetEast * 10^-5) / 10^-5, digits = 0) + as.integer(MapRefEast) * 100)) %>%
  mutate(NorthYard = ifelse(round(floor(SheetNorth * 10^-5) / 10^-5, digits = 0) + as.integer(MapRefNorth) * 100 < SheetNorth, round(floor(SheetNorth * 10^-5) / 10^-5, digits = 0) + as.integer(MapRefNorth) * 100 + 100000, round(floor(SheetNorth * 10^-5) / 10^-5, digits = 0) + as.integer(MapRefNorth) * 100))

# Select North Island coordinates and convert to NZMG
NIMapRefCoords <- MapRefCoords2 %>%
  filter(Island == "N") %>%
  st_as_sf(coords = c("EastYard", "NorthYard"), crs = NIYG, remove = FALSE) %>%
  st_transform(crs = NZMG) %>%  ## Now working! creates empty points unless .gsb file is available in folder with no spaces
  #st_transform(crs = "EPSG:9811") # CRS for NZMG from Proj website, not working. https://proj.org/development/reference/cpp/operation.html?highlight=datum+nzmg
  #st_transform(crs = NZTM) # manual proj string for NZTM
  st_transform(crs = "EPSG:2193") # CRS for NZTM
  #st_transform(crs = 4326) #works, CRS fro WGS84 google



# Select South Island coordinates and convert to NZMG
SIMapRefCoords <- MapRefCoords2 %>%
  filter(Island == "S") %>%
  st_as_sf(coords = c("EastYard", "NorthYard"), crs = SIYG, remove = FALSE) %>%
  st_transform(crs = NZMG) %>% ## Now working! creates empty points unless .gsb file is available in folder with no spaces
  st_transform(crs = NZTM) # manual proj string for NZTM
  #st_transform(crs = "EPSG:2193") # CRS for NZTM
  #st_transform(crs = 4326) #works

# Merge back to single data set and convert to NZTM
ConvertedCoords <- NIMapRefCoords %>%
  bind_rows(SIMapRefCoords) %>%
  st_transform(crs = NZTM)

# Load location boundaries
TLA1995 <- read_sf("territorial-authority-1995-generalised.shp")
TLA1995 <- st_transform(TLA1995, crs = NZTM)
TLA2020 <- read_sf("territorial-authority-2020-generalised.shp")
TLA2020 <- st_transform(TLA2020, crs = NZTM)
RC2020 <- read_sf("regional-council-2020-generalised.shp")
RC2020 <- st_transform(RC2020, crs = NZTM)

# Plot points for visual check
ggplot() +
  geom_sf(data = TLA2020, aes()) +
  geom_sf(data = ConvertedCoords, aes(), colour = "red")

## Determine location  - could intersect polygons to make this 1 step?
# i <- as.integer(st_within(ConvertedCoords, TLA1995))
# ConvertedCoords$TLA1995 <- TLA1995$TA1995_V_1[i]
# i <- as.integer(st_within(ConvertedCoords, TLA2020))
# ConvertedCoords$TLA2020 <- TLA2020$TA2020_V_2[i]
# i <- as.integer(st_within(ConvertedCoords, RC2020))
# ConvertedCoords$REGC2020 <- RC2020$REGC2020_2[i]

## testing Single step
ConvertedCoords <- st_join(ConvertedCoords, TLA1995, join = st_within)
ConvertedCoords <- st_join(ConvertedCoords, TLA2020, join = st_within)
ConvertedCoords <- st_join(ConvertedCoords, RC2020, join = st_within)


# Clean up data for export - NZTM Eastings and Northings
ConvertedCoords2 <- ConvertedCoords %>%
  as.data.frame() %>%
  select(MapRef, LINZ, geometry, TA1995_V_1, TA2020_V_1, REGC2020_1) %>%
  mutate(geometry = map(geometry, setNames, c("NZTM_Easting", "NZTM_Northing"))) %>%
  unnest_wider(geometry)

# Clean up data for export - Google WGS84 Longitude and Latitude
ConvertedCoords3 <- ConvertedCoords %>%
  st_transform(crs = 4326) %>% 
  as.data.frame() %>%
  select(MapRef, LINZ, geometry, TA1995_V_1, TA2020_V_1, REGC2020_1) %>%
  mutate(geometry = map(geometry, setNames, c("Longitude", "Latitude"))) %>%
  unnest_wider(geometry)

ConvertedCoordsFinal <- left_join(ConvertedCoords2, ConvertedCoords3)
ConvertedCoordsFinal
# Export csv
write_csv(ConvertedCoordsFinal, file = "ConvertedCoords.csv")


## Appendix: Trying to refer to nzgd2kgrid0005.gsb file in an arbitrary or logical places

# can we point to current folder location to find the file? Doesn't work at the moment
# NZMG <- paste0("+proj=nzmg  +lat_0=-41 +lon_0=173 +x_0=2510000 +y_0=6023150  +ellps=intl +datum=nzgd49 +units=m +towgs84=59.47,-5.04,187.44,0.47,-0.1,1.024,-4.5993 +nadgrids=", here(), "/nzgd2kgrid0005.gsb +no_defs")
# NZMG #note spaces in path
# 
# # i can use  dir /x in cmd command prompt to find short version of onedrive folder name without spaces, which is ONEDRI~1, This works
# NZMG <- "+proj=nzmg  +lat_0=-41 +lon_0=173 +x_0=2510000 +y_0=6023150  +ellps=intl +datum=nzgd49 +units=m +towgs84=59.47,-5.04,187.44,0.47,-0.1,1.024,-4.5993 +nadgrids=C:/Users/nealm/ONEDRI~1/Desktop/dairynz/NZMS1_conversion/nzgd2kgrid0005.gsb +no_defs"
# 
# # copying to c:\ works, but need admin access
# NZMG <- paste0("+proj=nzmg  +lat_0=-41 +lon_0=173 +x_0=2510000 +y_0=6023150  +ellps=intl +datum=nzgd49 +units=m +towgs84=59.47,-5.04,187.44,0.47,-0.1,1.024,-4.5993 +nadgrids=C:/nzgd2kgrid0005.gsb +no_defs")
# NZMG

# Until this projection works consistently, in the code I will skip the NZMG step. Some loss of accuracy may result. 
# I have a stackoverflow question on resolving this
# https://stackoverflow.com/q/72610074/4927395

## functional approach to short path name to avoid spaces in directory path
## https://github.com/r-lib/here/issues/82#issuecomment-1154644055
# here_short <- function(...) {
#   shortPathName(here(...))
# }
# 
# here_short()

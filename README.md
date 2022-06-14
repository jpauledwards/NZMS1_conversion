# NZMS1_conversion

This file has a script that takes the map reference found in DIGAD, and converts it to a useful latitude and longitude in the format that you would use with google maps (WGS84 projection, EPSG:4326).
DIGAD is the Dairy Industry Good Animal Database, used for animal evaluation purposes, held by NZAEL, within DairyNZ. For more information, see: https://www.dairynz.co.nz/animal/animal-evaluation/animal-database/

Input is provided as the map reference, NZMS1 format (which is very old!), as per the "InputCoords.csv" file. A map reference looks like this: N007857978. This can be understood as a location within the N orth Island and South Island Yard grid (also an old format! Helpful tip, a yard is three feet, a foot is ~30 cm, so a yard is about the same magnitude as a metre.)
N or S refers to the island (North or South). The next three digits refer to the numbered map within the North or South Island. There are then 3 digits each for eastings and northings. Note, the coordinates are rounded to the nearest 100, so additional zeroes need to be added. Also, this means locations will provide a precise looking latitude and longitude, but actually will refer to roughly a 1 hectare area (due to 100 yeards by 100 yards being close to 100m by 100m which is a hectare). 
The yard grids can then be converted to NZMG (NZ Map Grid), a slightly less old format, and projection to a "google-friendly" format is then straightforward. 

Many thanks to Chris Cook and Yu-Ching Lee from LINZ who were extremely helpful in understanding this process.

# References

New Zealand Coordinate Conversions 
Use this form to convert coordinates between datums, projections and height coordinate systems used in New Zealand. 
https://www.geodesy.linz.govt.nz/concord/

NZGD1949 - NZGD2000
This page outlines multiple ways to transform geodetic coordinates. The choice of which method is the most appropriate will depend on the accuracy of the coordinates being converted and their intended use. 
https://www.linz.govt.nz/data/geodetic-system/coordinate-conversion/geodetic-datum-conversions/nzgd1949-nzgd2000

Converting NZMG (or NZTM) to latitude / longitude for use with R map library 
https://gis.stackexchange.com/questions/20389/converting-nzmg-or-nztm-to-latitude-longitude-for-use-with-r-map-library

Perl code that converts between NZMS1 map references and NZGD49 latitude and longitude 
https://github.com/linz/liblinz-geodetic-perl/blob/master/lib/LINZ/Geodetic/NZMS1MapRef.pm

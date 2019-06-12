# UTMtoLatLong
Convert Standard UTM Meters to Latitude Longitude and returns JSON Format.

In the UTM coordinate system a grid is used to specify locations on the surface of the Earth. The UTM system is not a single map projection but instead a series of sixty zones. Each zone is based on a specifically defined secant Transverse Mercator projection. The units for both east and north coordinates are meters.

The UTM north coordinate is the projected distance from equator for all zones. The east coordinate is the distance from the central median.

If you want to use Google Maps or Google Earth definitly you need to convert UTM to Lat Long coordinated.

To Convert you need to know the below:

Easting

Northing

Zone (1-60)

North OR South of Equator


There are two files:

convertToLatLon.cfc is the api that you need to call

convertToLatLon.cfm is the test fine to show you how to use the API


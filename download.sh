mkdir -p data
cd data
url="http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"
wget $url
unzip ne_50m_admin_0_countries.zip
ogr2ogr -f GeoJSON countries.json ne_50m_admin_0_countries.shp
topojson  -o countries.topo.json -- countries.json
topojson -s 0.000001 -o countries.topo.small.json -- countries.json

osm_url="http://download.geofabrik.de/europe/great-britain/england"
osm_file="greater-london-latest.osm.pbf"
wget $osm_url/$osm_file
../osmconvert $osm_file --all-to-nodes --csv="@id @lon @lat amenity name" | grep pub | grep -v public_building > pubs.tsv
wget https://londondatastore-upload.s3.amazonaws.com/dataset/statistical-gis-boundary-files-london/London-wards-2014.zip
unzip London-wards-2014.zip
ogr2ogr -f GeoJSON -t_srs epsg:4326 wards.json London-wards-2014_ESRI/London_Ward_CityMerged.shp
topojson  -o wards.topo.json -- wards.json

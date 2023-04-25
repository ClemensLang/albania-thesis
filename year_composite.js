// Define the time period for the composite.
var start = ee.Date('2022-05-01');
var end = ee.Date('2022-10-01');

var aoi = ee.FeatureCollection('users/clang/albania/albania_buffer');

// Load the Landsat 5 image collection, filtering to the desired time period.
//var collection = ee.ImageCollection('LANDSAT/LE07/C02/T1_L2')
//var collection = ee.ImageCollection('LANDSAT/LT05/C02/T1_L2')

var collection = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
  .filterDate(start, end)
  .filter(ee.Filter.lt('CLOUD_COVER', 5))
  .filterBounds(aoi);
  

// Create the composite by selecting the best pixel value from the images.
var composite = collection.mosaic();
print(composite);


// Display the composite.
Map.addLayer(composite);

// Define an area of interest as a rectangle around a point.
// var aoi = ee.Geometry.Rectangle([-122.44, 37.75, -122.43, 37.76]);


print(composite);

var bands = ['SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B6', 'SR_B7','QA_PIXEL'];
var selected = composite.select(bands);


print(selected);

// Export the composite to Cloud Storage.
Export.image.toDrive({
  image: selected,
  region: aoi, 
  scale: 30, 
  crs: 'EPSG:4326', 
  maxPixels: 1e13
});

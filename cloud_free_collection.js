

var geometry = ee.FeatureCollection('users/clang/albania/albania_buffer');



// Load the Landsat 5 image collection for 1990
var landsat5_1990 = ee.ImageCollection('LANDSAT/LT05/C01/T1')
  .filterDate('1990-04-01', '1990-10-01')
  .filterBounds(geometry);

// Define a function to calculate NDVI
function addNDVI(image) {
  var ndvi = image.normalizedDifference(['B4', 'B3']).rename('NDVI');
  return image.addBands(ndvi);
}

// Map the function over the Landsat 5 image collection
var ndvi_collection = landsat5_1990.map(addNDVI);

print(ndvi_collection);


// Calculate the mean NDVI value for the collection
var ndvi_mean = ndvi_collection.select('NDVI').mean();
var ndvi_min = ndvi_collection.select('NDVI').min();
var ndvi_max = ndvi_collection.select('NDVI').max();

var b1_mean = ndvi_collection.select('B1').mean();
var b2_mean = ndvi_collection.select('B2').mean();
var b3_mean = ndvi_collection.select('B3').mean();
var b4_mean = ndvi_collection.select('B4').mean();
var b5_mean = ndvi_collection.select('B5').mean();
var b7_mean = ndvi_collection.select('B7').mean();
var bqa_mean = ndvi_collection.select('BQA').mean();

var img_ex1 = ndvi_mean;
img_ex1 = img_ex1.addBands(ndvi_min);
img_ex1 = img_ex1.addBands(ndvi_max);

var img_ex2 = b1_mean;
img_ex2 = img_ex2.addBands(b2_mean);
img_ex2 = img_ex2.addBands(b3_mean);
img_ex2 = img_ex2.addBands(b4_mean);
img_ex2 = img_ex2.addBands(b5_mean);
img_ex2 = img_ex2.addBands(b7_mean);
img_ex2 = img_ex2.addBands(bqa_mean);


print(img_ex1);
print(img_ex2);


// Display the result on the map
Map.addLayer(img_ex2);



// Export the composite to Cloud Storage.
Export.image.toDrive({
  image: img_ex1,
  region: geometry, 
  scale: 30, 
  crs: 'EPSG:4326', 
  maxPixels: 1e13
});

// Export the composite to Cloud Storage.
Export.image.toDrive({
  image: img_ex2,
  region: geometry, 
  scale: 30, 
  crs: 'EPSG:4326', 
  maxPixels: 1e13
});



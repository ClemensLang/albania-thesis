// load albania buffered shapefile
var albania_roi = ee.FeatureCollection('users/clang/albania/albania_buffer');
Map.addLayer(albania_roi);
Map.centerObject(albania_roi);


// define collection parameters
var startYear = 1988;
var endYear = 2022;
var startDay = '06-01';
var endDay = '08-31';
var aoi = albania_roi;
var index = 'NDVI';
var maskThese = ['cloud', 'shadow', 'snow', 'water'];



// define landtrendr parameters
var runParams = { 
  maxSegments:            6,
  spikeThreshold:         0.9,
  vertexCountOvershoot:   3,
  preventOneYearRecovery: true,
  recoveryThreshold:      0.25,
  pvalThreshold:          0.05,
  bestModelProportion:    0.75,
  minObservationsNeeded:  6
};

// define change parameters

/*
NBR (loss):
var changeParams = {
  delta:  'loss',
  sort:   'greatest',
  year:   {checked:true, start:2008, end:2022},
  mag:    {checked:true, value:200,  operator:'>'},
  dur:    {checked:true, value:4,    operator:'<'},
  preval: {checked:true, value:400,  operator:'>'},
  mmu:    {checked:true, value:11},
};

// NBR (gain):

*/
/*
var changeParams = {
  delta:  'gain',
  sort:   'greatest',
  year:   {checked:true, start:1988, end:2022},
  mag:    {checked:true, value:200,  operator:'>'},
  dur:    {checked:true, value:10,    operator:'<'},
  preval: {checked:true, value:200,  operator:'<'},
  mmu:    {checked:true, value:11},
};

/*
//TCW (loss):
*/

/*
var changeParams = {
  delta:  'loss',
  sort:   'greatest',
  year:   {checked:true, start:1998, end:2012},
  mag:    {checked:true, value:400,  operator:'>'},
  dur:    {checked:true, value:4,    operator:'<'},
  preval: {checked:true, value:-1200,  operator:'>'},
  mmu:    {checked:true, value:11},
};
/*
*/
//TCW (gain):
/*
var changeParams = {
  delta:  'gain',
  sort:   'greatest',
  year:   {checked:true, start:1988, end:2022},
  mag:    {checked:true, value:400,  operator:'>'},
  dur:    {checked:true, value:4,    operator:'<'},
  preval: {checked:true, value:-1200,  operator:'<'},
  mmu:    {checked:true, value:11},
};
/*

NDVI (loss):
*/

/*

var changeParams = {
  delta:  'loss',
  sort:   'greatest',
  year:   {checked:true, start:2008, end:2022},
  mag:    {checked:true, value:200,  operator:'>'},
  dur:    {checked:true, value:4,    operator:'<'},
  preval: {checked:true, value:500,  operator:'>'},
  mmu:    {checked:true, value:11},
};


/*
*/


/*

NDVI (gain):
*/



var changeParams = {
  delta:  'gain',
  sort:   'greatest',
  year:   {checked:true, start:1988, end:2022},
  mag:    {checked:true, value:200,  operator:'>'},
  dur:    {checked:true, value:10,    operator:'<'},
  preval: {checked:true, value:300,  operator:'<'},
  mmu:    {checked:true, value:11},
};


/*
*/







// load the LandTrendr.js module
var ltgee = require('users/emaprlab/public:Modules/LandTrendr.js'); 

// add index to changeParams object
changeParams.index = index;

// run landtrendr
var lt = ltgee.runLT(startYear, endYear, startDay, endDay, aoi, index, [], runParams, maskThese);

// get the change map layers
var changeImg = ltgee.getChangeMap(lt, changeParams);

print('change Image done..');

var region = aoi;
var exportImg = changeImg.clip(region).unmask(0).short();
print('clip Image done.. ready to export');


Export.image.toDrive({
  image: exportImg,
  region: region, 
  scale: 30, 
  crs: 'EPSG:4326', 
  maxPixels: 1e13
});

// Creating server
require('coffee-script/register');
var express = require('express'),
    http = require('http'),
    app = express(),
    mongoose = require('mongoose'),
    bootstrap = require('./lib/bootstrap');
    appFog = require('./lib/app_fog');


process.env.NODE_ENV = process.env.NODE_ENV || 'development';

var config = require('./config/application');
global.config = config;

var db = mongoose.connect(config.db).connection;
db.on('error', function(err) { console.log(err.message); });
db.once('open', function() { console.log('Successfully connected to database', db.name); });

require('./config/express')(app, db);



bootstrap.filesInDirectory('/app/models');
bootstrap.filesInDirectory('/app/routes', {app: app});

http.createServer(app).listen(app.get('port'), function() {
  console.log('Express listening on port %d', app.get('port'));
});

if ('test' === app.get('env')) {
  module.exports = app;
}

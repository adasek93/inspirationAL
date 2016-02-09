process.env['NODE_ENV'] = 'test'
require('chai').should()

global.expect = require('chai').expect
global.testDir = __dirname
global.rootDir = testDir + '/..'

bootstrap = require "#{rootDir}/lib/bootstrap"
bootstrap.filesInDirectory '/tests/factories'

global.Factory = require('rosie').Factory
 

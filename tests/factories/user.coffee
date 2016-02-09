require "#{rootDir}/app/models/user"
require './quote_provider'
Factory = require('rosie').Factory
crypto = require 'crypto'

Factory.define 'user', User
  .attr 'device_id', crypto.randomBytes(10).toString('hex')
  .attr 'ua_token', crypto.randomBytes(10).toString('hex')
  .attr 'categories', []


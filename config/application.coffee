_ = require 'lodash'

mongoURL = ->
  mongo = JSON.parse process.env.VCAP_SERVICES
  mongo = mongo['mongodb-1.8'][0]['credentials']
  if mongo.username? and mongo.password?
    "mongodb://#{mongo.username}:#{mongo.password}@#{mongo.hostname}:#{mongo.port}/#{mongo.db}"
  else
    "mongodb://#{mongo.hostname}:#{mongo.port}/#{mongo.db}"

module.exports = _.merge(
  require("#{__dirname}/env/all"),
  require("#{__dirname}/env/#{process.env.NODE_ENV}")
)

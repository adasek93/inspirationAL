exports.mongoURL = ->
  return 'VCAP_SERVICE' unless process.env.VCAP_SERVICES?
  mongo = JSON.parse process.env.VCAP_SERVICES
  mongo = mongo['mongodb2-2.4.8'][0]['credentials']
  if mongo.username? and mongo.password?
    "mongodb://#{mongo.username}:#{mongo.password}@#{mongo.hostname}:#{mongo.port}/#{mongo.db}"
  else
    "mongodb://#{mongo.hostname}:#{mongo.port}/#{mongo.db}"


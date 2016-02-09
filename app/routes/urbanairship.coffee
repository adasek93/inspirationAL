urbanAirShipController = require '../controllers/urbanairship'
auth = require('./middlewares/auth.coffee')


module.exports = (app) ->
  app.post '/v1/ua/broadcast', auth.requiresLogin, urbanAirShipController.broadcast
  app.get '/v1/ua/broadcast', auth.requiresLogin, urbanAirShipController.broadcastForm

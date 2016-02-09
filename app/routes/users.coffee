usersController = require '../controllers/users_controller'
free = require './middlewares/free'

module.exports = (app) ->
  app.get '/v1/users/:id/quotes', free.period, usersController.fetchQuotes

  app.post '/v1/users/:id/categories', usersController.addCategories
  app.post '/v1/users/:id/tokens', usersController.registerUAToken
  app.post '/v1/users', usersController.registerDevice

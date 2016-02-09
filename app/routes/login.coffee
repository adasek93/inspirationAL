htmlController = require '../controllers/html'
loginController = require('../controllers/login.js')

module.exports = (app) ->
  app.get '/v1/loggedIn', htmlController.loggedInPage
  app.get '/v1/signIn', loginController.signInPage
  app.post '/v1/logMeIn', loginController.logIn

quoteProvider = require '../controllers/quote_providers'
auth = require('./middlewares/auth.coffee')


module.exports = (app) ->
  app.post '/v1/addNewQuoteProvider', auth.requiresLogin, quoteProvider.addQuoteProvider
  app.get '/v1/inputNewQuoteProvider', auth.requiresLogin, quoteProvider.inputQuoteProvider
  app.get '/v1/addNewQuoteForQuoteProvider', auth.requiresLogin, quoteProvider.showSelecatableTableOfProviders
  app.get '/v1/getAllQuoteProviders', auth.requiresLogin, quoteProvider.getAllQuoteProviders
  app.post '/v1/switchEnableOnProvider', auth.requiresLogin, quoteProvider.switchEnabledOnProvider
  app.post '/v1/editQuoteProvider', auth.requiresLogin, quoteProvider.editQuoteProvider

  app.get '/v1/getQuoteProviderSchemas2/:key', quoteProvider.getQuoteProviderSchemas2
  app.get '/v1/getQuoteProviders2', quoteProvider.getQuoteProvider2
  app.get '/v1/getUsers2', quoteProvider.getUsers2

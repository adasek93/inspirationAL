quoteController = require('../controllers/quote.js')
auth = require('./middlewares/auth.coffee')

module.exports = (app) ->
  app.post '/v1/inputNewQuoteForProvider', auth.requiresLogin, quoteController.addNewQuotesForProvider
  app.post '/v1/saveNewQuoteForProvider', auth.requiresLogin, quoteController.saveNewQuoteForProvider
  app.post '/v1/showQuotesForProvider', auth.requiresLogin, quoteController.getAllQuotesForProvider
  app.post '/v1/editQuoteForProvider', auth.requiresLogin, quoteController.editQuoteWithIdentifier

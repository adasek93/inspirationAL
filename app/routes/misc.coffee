auth = require('./middlewares/auth.coffee')
htmlController = require('../controllers/html')


module.exports = (app) ->
  app.get "/v1", (req, res) ->
    res.send key: "Hello World"

  app.get "/v1/getAllQuotesForProvider", auth.requiresLogin, htmlController.createSelectableTableForQuotes

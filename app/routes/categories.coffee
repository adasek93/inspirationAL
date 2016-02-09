categoriesController = require '../controllers/categories_controller'
module.exports = (app) ->
  app.get '/v1/categories', categoriesController.index

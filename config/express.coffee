express = require 'express'
config = require './application'
path = require 'path'


module.exports = (app, db) ->
  app.configure ->
    app.set 'port', config.port
    if 'development' is app.get('env')
      app.use express.logger 'dev'
      app.use(express.errorHandler())

    app.use express.json()
    app.use express.urlencoded()
    app.use express.methodOverride()

    app.use express.bodyParser()
    app.use express.cookieParser()
    sessionStore = new express.session.MemoryStore
    app.use express.session secret: config.sessionSecret, store: sessionStore
    app.use app.router

    app.locals.pretty = true

    app.set 'views', path.join(global.rootDir, '/app/views')
    app.set 'view engine', 'jade'

 

    app.all '/v1*', (req, res, next) ->
      res.contentType 'application/json'
      next()



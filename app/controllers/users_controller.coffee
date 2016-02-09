_ = require 'lodash'

exports.fetchQuotes = (req, res) ->
  if 0 < req.currentUser.categories.length
    categories = _.pluck req.currentUser.categories, 'category'
    QuoteProvider.find category: { $in: categories }, (err, quoteProviders) ->
      res.status(200).send quoteProviders
  else if req.currentUser.free
    QuoteProvider.find (err, quoteProviders) ->
      res.status(200).send quoteProviders
  else
    res.status(200).send []


exports.addCategories = (req, res) ->
  User.findOne _id: req.param('id'), (err, user) ->
    unless err
      categories = []
      _.map req.body, (object) -> categories.push(object.name)
      QuoteProvider.find category: { $in: categories }, (err, quoteProviders) ->
        res.status(500).send error: err.message if err # don't know how to test it, but just in case
        if 0 < quoteProviders.length
          user.categories = quoteProviders
          user.save (err, user) ->
            res.send 200, ''
        else
          res.status(400).send error: 'no quotes found'
    else
      res.status(400).send error: "user doesn't exist"


exports.registerUAToken = (req, res) ->
  res.setHeader('Content-Type', 'application/json')

  unless req.param('ua_token')
    res.send 400, error: "Request must contain ua_token."

  User.findOne _id: req.param('id'), (err, user) ->

    if user
      user.ua_token = req.param('ua_token')
      user.save (err, user) -> res.send(200)
    else
      res.send 404, error: "Cannot find user with id #{req.param('id')}"


exports.registerDevice = (req, res) ->
  res.setHeader('Content-Type', 'application/json')

  unless req.param('device_id')
    res.send 400, error: "Request must contain device_id."

  User.findOne device_id: req.param('device_id'), (err, user) ->

    if user
      res.send 200, _id: user._id
    else
      new_user = new User categories: [], device_id: req.param('device_id')
      new_user.save (err, user) -> res.send 200, _id: user._id

request = require 'request'

UAConfig = global.config.urbanairship

exports.broadcast = (req, res) ->
  res.setHeader('Content-Type', 'text/html')
  unless req.body.message
    res.render("ua/broadcast", message: "Message is required")
    return

  UAAuth = new Buffer(UAConfig.appKey + ':' + UAConfig.appMasterSecret).toString('base64')

  data =
    "audience" : "all"
    "notification" :
      "alert" : req.body.message
    
    "device_types" : "all"

  options =
    headers:
      'Authorization' : 'Basic ' + UAAuth
      'Accept': 'application/vnd.urbanairship+json; version=3;'
    url: "#{UAConfig.baseUrl}/api/push"
    json: data

  request.post options, (err, response, body) ->
    unless err
      res.render("ua/broadcast", message: "Success. Notification has been sent to UrbanAirShip service.")
    else
      res.render("ua/broadcast", message: "There was a problem with UrbanAirShip api. Error code: #{err.code}")

exports.broadcastForm = (req, res) ->
  res.setHeader('Content-Type', 'text/html')
  res.render("ua/broadcast", message: req.body.message)

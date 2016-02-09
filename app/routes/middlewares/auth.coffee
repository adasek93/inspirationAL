exports.requiresLogin = (req, res, next) ->
  if req.session and req.session.user_id
    next()
  else
    res.redirect '/v1/signIn'

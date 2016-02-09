exports.period = (req, res, next) ->
  User.findOne(_id: req.param('id')).populate('categories').exec (err, user) ->
    if user?
      min = 1000 * 60
      hour = 60 * min
      day = 24 * hour
      user.free = 14 > ((Date.now() - user.created_at)/day)
      req.currentUser = user
      next()
    else
      res.status(400).send error: "user doesn't exist"

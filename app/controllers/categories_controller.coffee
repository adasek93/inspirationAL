_ = require 'lodash'

exports.index = (req, res) ->
  QuoteProvider.aggregate().project(_id: 0, category: 1).exec (err, data) ->
    data = _.map data, (d) -> _.values(d)
    data = _.uniq _.flatten data
    res.status(200).send data

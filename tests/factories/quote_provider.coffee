require "#{rootDir}/app/models/quote_provider"
require './quote'
Factory = require('rosie').Factory

Factory.define('quoteProvider', QuoteProvider)
  .sequence('identifier')
  .sequence('name', (idx) -> "quoteProvider #{idx}")
  .sequence('category')
  .sequence('url')
  .attr('quotes', ->
    [ Factory.attributes('quote'), Factory.attributes('quote'), Factory.attributes('quote')]
  )

module.exports = Factory

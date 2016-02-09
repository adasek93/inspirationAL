require "#{rootDir}/app/models/quote"
Factory = require('rosie').Factory

Factory.define('quote', Quote)
  .sequence('identifier')
  .sequence('name', (idx) -> "Quote #{idx}")
  .sequence('quote')

module.exports = Factory

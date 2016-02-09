mongoose = require 'mongoose'
quoteProviderSchema = require '../schemas/quote_provider'

QuoteProvider = mongoose.model('QuoteProviderSchema', quoteProviderSchema)

global.QuoteProvider = QuoteProvider

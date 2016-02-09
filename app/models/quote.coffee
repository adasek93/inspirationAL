mongoose = require 'mongoose'
quoteSchema = require '../schemas/quote'

Quote = mongoose.model('QuoteSchema', quoteSchema)

global.Quote = Quote


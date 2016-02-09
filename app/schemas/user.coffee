Schema = require('mongoose').Schema

userSchema = new Schema
  device_id:
    type: String
  ua_token:
    type: String
  categories: [
    type: Schema.ObjectId
    ref: 'QuoteProviderSchema'
  ]
  created_at:
    type: Date
    default: Date.now

module.exports = userSchema

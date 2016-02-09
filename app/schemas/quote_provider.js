var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    quoteSchema = require('./quote');

var quoteProviderSchema = new Schema({        
  identifier : { type: String, required: true },  
  name : { type: String, required: true },
  url : { type: String, required: true },
  category : { type: String, required: true },
  dateAdded : { type: Date, required: true, default: Date.now },
  isEnabled : { type: Boolean, required: true, default: true },
  quotes : [quoteSchema]
});

module.exports = quoteProviderSchema;

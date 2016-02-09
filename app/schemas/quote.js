var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var quoteSchema = new Schema({
  identifier : { type: String, required: true },
  name : { type: String, required: true },
  quote : { type: String, required: true },
  isEnabled : { type: Boolean, required: true, default: true }
});

module.exports = quoteSchema;

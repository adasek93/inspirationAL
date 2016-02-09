userSchema = require "#{rootDir}/app/schemas/user"

describe 'userSchema', ->
  describe 'paths', ->
    describe 'device_id', ->
      device_id = userSchema.paths.device_id
      it 'is a String', -> device_id.options.type.should.be.String

    describe 'ua_token', ->
      ua_token = userSchema.paths.ua_token
      it 'is a String', -> ua_token.options.type.should.be.String

    describe 'categories', ->
      categories = userSchema.paths.categories

      it 'is a Array', -> categories.options.type.should.be.Array

      describe 'reference', ->
        reference = categories.caster
        it 'set on QuoteProvider', -> reference.options.ref.should.be.QuoteProvider
        it 'by ObjectId', -> reference.instance.should.be.ObjectId
        it 'on path categories', -> reference.path.should.be.categories

  
    describe 'created_at', ->
      created_at = userSchema.paths.created_at

      it 'is a Date', -> created_at.options.type.should.be.Date
      describe 'default', ->
       it 'is a function', -> created_at.options.default.should.be.a.function
       it 'returns current date in miliseconds', -> expect(created_at.options.default()).to.equal Date.now()

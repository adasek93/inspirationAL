app = require "#{rootDir}/server"

describe 'User', ->
  it 'is defined', -> expect(User).to.be.defined

  it 'is a mongoose model', -> expect(User.modelName).to.be.User

  it 'can be instantiated', -> expect(new User).to.be.an.instanceof User

  describe 'categories', ->
    describe 'updates', ->
      user = null
      quoteProvider = Factory.build 'quoteProvider'

      before (done) -> quoteProvider.save done

      before (done) ->
        user = Factory.build 'user', categories: []
        user.save done

      after (done) -> User.remove done
      after (done) -> QuoteProvider.remove done

      it 'adds new', (done) ->
          User.findOne _id: user.id, (err, user) ->
            user.categories = [quoteProvider]
            user.save (err, user) ->
              expect(user.categories.toString()).to.equal quoteProvider.id
              done()

      


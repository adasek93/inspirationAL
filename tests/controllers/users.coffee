app = require "#{rootDir}/server"
request = require 'supertest'
agent = request.agent app
config = require "#{rootDir}/config/application"
crypto = require 'crypto'

describe 'UsersController', ->
  describe 'POST', ->


    describe '#addCategories', ->
      response = null
      user = Factory.build 'user', categories: []
      before (done) -> user.save done
      after (done) -> User.remove done
      quoteProvider = Factory.build 'quoteProvider'
      before (done) -> quoteProvider.save done
      after (done) -> QuoteProvider.remove done

      before (done) ->
        agent.post "/v1/users/#{user.id}/categories"
          .send [name: quoteProvider.category]
          .end (err, res) ->
            response = res
            done()

      it 'responds with 200', ->
        expect(response).to.have.property('statusCode').equal 200

      it 'saves quotes to user', (done) ->
        User.findOne _id: user.id, (err, user) ->
          expect(user.categories.toString()).to.equal quoteProvider.id
          done()


    describe '#registerUAToken', ->
      user = Factory.build 'user', categories: [], ua_token: ""
      ua_token = crypto.randomBytes(10).toString('hex')

      before (done) -> user.save done
      after (done) -> User.remove done
      
      describe 'for existing user', ->
        response = null

        before (done) ->
          agent.post "/v1/users/#{user.id}/tokens"
            .send ua_token: ua_token
            .end (err, res) ->
              response = res
              done()

        it 'responds with 200', ->
          expect(response).to.have.property('statusCode').equal 200

        it 'saves ua_token', (done) ->
          User.findOne _id: user.id, (err, user) ->
            expect(user.ua_token).to.equal ua_token
            done()

      describe 'for not existing user', ->
        response = null
        fake_id = crypto.randomBytes(10).toString('hex')

        before (done) ->
          agent.post "/v1/users/#{fake_id}/tokens"
            .send ua_token: ua_token
            .end (err, res) ->
              response = res
              done()

        it 'responds with 404', ->
          expect(response).to.have.property('statusCode').equal 404

        it 'response contains error message', ->
          expect(response.body).to.have.property('error')

      describe 'sent with incorrect parameters', ->
        response = null

        before (done) ->
          agent.post "/v1/users/#{user.id}/tokens"
            .end (err, res) ->
              response = res
              done()

        it 'responds with 400', ->
          expect(response).to.have.property('statusCode').equal 400

        it 'response contains error message', ->
          expect(response.body).to.have.property('error')
          



    describe '#registerDevice', ->

     
      after (done) -> User.remove done

      describe 'for empty request', ->
        response = null

        before (done) -> 
          agent.post "/v1/users"
            .end (err, res) ->
              response = res
              done()

        after (done) -> User.remove done

        it 'responds with 400', ->
          expect(response).to.have.property('statusCode').equal 400

        it 'reponse contains "error" property', ->
          expect(response.body).to.have.property('error')


      describe 'for non-existing device_id', ->
        response = null
        users_count = null

        before (done) ->
          User.find (err, data) ->
            users_count = data.length
            done()

        before (done) -> 
          agent.post "/v1/users"
            .send "device_id" : crypto.randomBytes(10).toString('hex')
            .end (err, res) ->
              response = res
              done()

        after (done) -> User.remove done


        it 'responds with 200', ->
          expect(response).to.have.property('statusCode').equal 200

        it 'returns _id', ->
          expect(response.body).to.have.property('_id')

        it 'creates new user for non-existing device id', (done) ->
          User.find (err, data) ->
            expect(data.length).to.be.above users_count
            done()

      describe 'for existing device_id', ->


        response = null
        users_count = null

        user = Factory.build 'user', categories: []

        before (done) -> user.save done
        after (done) -> User.remove done

        before (done) ->
          User.find (err, data) ->
            users_count = data.length
            done()

        before (done) -> 
          agent.post "/v1/users"
            .send "device_id" : user.device_id
            .end (err, res) ->
              response = res
              done()

        it 'responds with 200', ->
          expect(response).to.have.property('statusCode').equal 200

        it 'returns _id equal to user._id', ->
          expect(response.body).to.have.property('_id').equal user._id.toString()

        it 'doesnt create a new user', (done) ->
          User.find (err, data) ->
            expect(data.length).to.be.equal users_count
            done()



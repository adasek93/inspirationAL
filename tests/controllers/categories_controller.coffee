app = require "#{rootDir}/server"
request = require 'supertest'
agent = request.agent app

describe 'CategoriesController', ->
  describe 'GET', ->
    response = null

    describe '#index', ->
      describe 'quoteProvider present', ->
        quoteProvider = Factory.build 'quoteProvider'
        before (done) -> quoteProvider.save done
        quoteProvider2 = Factory.build 'quoteProvider'
        before (done) -> quoteProvider2.save done
        quoteProvider3 = Factory.build 'quoteProvider', category: quoteProvider2.category
        before (done) -> quoteProvider3.save done
        before (done) ->
          agent.get '/v1/categories'
            .end (err, res) ->
              response = res
              done()

        it 'responds with 200', ->
          expect(response).to.have.property('statusCode').equal 200

        it 'sends all availabale categories', ->
          expect(response).to.have.property('body').deep.equal [quoteProvider.category, quoteProvider2.category]

        it 'response body is an Array', ->
          expect(response.body).to.be.an.Array
  
        after (done) -> QuoteProvider.remove done
      
      describe 'no quote providers', ->
        before (done) ->
          agent.get '/v1/categories'
            .end (err, res) ->
              response = res
              done()

        it 'responds with 200', ->
          expect(response).to.have.property('statusCode').equal 200

        it 'sends all availabale categories', ->
          expect(response).to.have.property('body').deep.equal []

        it 'response body is an Array', ->
          expect(response.body).to.be.an.Array

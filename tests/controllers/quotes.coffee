request = require 'supertest'
express = require 'express'
app = require "#{rootDir}/server"
agent = request.agent(app)
config = require(rootDir + '/config/application')

logout = (done) ->
  agent
    .get('/v1')
    .send(session: null)
    .end (err, res) -> done()

login = (done) ->
  agent
    .post('/v1/logMeIn')
    .send(username: config.admin.name, password: config.admin.password)
    .end (err, res) ->
      error = err
      response = res
      done()

describe 'Quotes Controller', ->

  # login before proceeding
  before login
  after logout

  describe 'addNewQuotesForProvider', ->
    error = null
    response = null

    before (done) ->
      agent
        .post('/v1/inputNewQuoteForProvider')
        .end (err, res) ->
          error = err
          response = res
          done()

    it 'responds to POST /v1/inputNewQuoteForProvider', ->
      expect(response).to.exist

    it 'responds with 200', ->
      expect(response.statusCode).to.equal 200

    it 'responds with content-type of text/html', ->
      expect(response.headers).to.have.property('content-type').equal 'text/html'

    it 'response in not empty', ->
      expect(response).to.have.property('text').length.to.be.above 0

  describe 'saveNewQuoteForProvider', ->

    describe 'invalid request: no params', ->

      error = null
      response = null

      before (done) ->
        agent
          .post('/v1/saveNewQuoteForProvider')
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/saveNewQuoteForProvider', ->
        expect(response).to.exist

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'responds with content-type of application/json', ->
        expect(response.headers).to.have.property('content-type').equal 'application/json'

      it 'response in not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0


    describe 'invalid request: only provider name', ->

      fakeQuoteProvider = null

      before (done) ->
        fakeQuoteProvider = Factory.build('quoteProvider')
        fakeQuoteProvider.save done

      # cleanup db
      after (done) ->
        global.QuoteProvider.remove done

      after (done) ->
        global.Quote.remove done

      error = null
      response = null

        

      before (done) ->
        agent
          .post('/v1/saveNewQuoteForProvider')
          .send(providerName: fakeQuoteProvider.name)
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/saveNewQuoteForProvider', ->
        expect(response).to.exist

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'responds with content-type of text/html', ->
        expect(response.headers).to.have.property('content-type').equal 'text/html'

      it 'response in not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0

      it 'responds with error', ->
        expect(response.text).to.contain('Failed to add new Quote')

    describe 'valid request', ->

      fakeQuoteProvider = null

      before (done) ->
        fakeQuoteProvider = Factory.build('quoteProvider')
        fakeQuoteProvider.save done

      # cleanup db
      after (done) ->
        global.QuoteProvider.remove done

      after (done) ->
        global.Quote.remove done

      error = null
      response = null

        

      before (done) ->
        agent
          .post('/v1/saveNewQuoteForProvider')
          .send(providerName: fakeQuoteProvider.name, name: 'SomeName', quote: 'SomeQuote')
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/saveNewQuoteForProvider', ->
        expect(response).to.exist

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'responds with content-type of text/html', ->
        expect(response.headers).to.have.property('content-type').equal 'text/html'

      it 'response in not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0

      it 'responds with success message', ->
        expect(response.text).to.contain('Added new Quote')

  describe 'getAllQuotesForProvider', ->

    describe 'invalid request: no params', ->

      error = null
      response = null

      before (done) ->
        agent
          .post('/v1/showQuotesForProvider')
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/showQuotesForProvider', ->
        expect(response).to.exist

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'responds with content-type of application/json', ->
        expect(response.headers).to.have.property('content-type').equal 'application/json'

      it 'response in not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0


    describe 'valid request', ->

      fakeQuoteProvider = null

      before (done) ->
        fakeQuoteProvider = Factory.build('quoteProvider')
        fakeQuoteProvider.save done

      # cleanup db
      after (done) ->
        global.QuoteProvider.remove done

      after (done) ->
        global.Quote.remove done

      error = null
      response = null

        

      before (done) ->
        agent
          .post('/v1/showQuotesForProvider')
          .send(providerName: fakeQuoteProvider.name)
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/showQuotesForProvider', ->
        expect(response).to.exist

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'responds with content-type of text/html', ->
        expect(response.headers).to.have.property('content-type').equal 'text/html'

      it 'response in not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0



  describe 'editQuoteWithIdentifier', ->

    describe 'invalid request: no params', ->

      error = null
      response = null

      before (done) ->
        agent
          .post('/v1/editQuoteForProvider')
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/editQuoteForProvider', ->
        expect(response).to.exist

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'responds with content-type of application/json', ->
        expect(response.headers).to.have.property('content-type').equal 'application/json'

      it 'response in not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0


    describe 'valid request', ->

      fakeQuoteProvider = null
      fakeQuote = null

      before (done) ->
        fakeQuoteProvider = Factory.build('quoteProvider')
        fakeQuoteProvider.save done

      before ->
        fakeQuote = fakeQuoteProvider.quotes[0]

      # cleanup db
      after (done) ->
        global.QuoteProvider.remove done

      after (done) ->
        global.Quote.remove done

      error = null
      response = null

        

      before (done) ->
        agent
          .post('/v1/editQuoteForProvider')
          .send(identifier: fakeQuote.identifier, quoteProvider: fakeQuoteProvider.name)
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/editQuoteForProvider', ->
        expect(response).to.exist

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'responds with content-type of text/html', ->
        expect(response.headers).to.have.property('content-type').equal 'text/html'

      it 'response in not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0

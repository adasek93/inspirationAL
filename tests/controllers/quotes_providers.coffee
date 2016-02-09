app = require "#{rootDir}/server"
request = require 'supertest'
agent = request.agent app
config = require "#{rootDir}/config/application"

describe 'QuoteProviderController', ->
  response = null
  after (done) -> QuoteProvider.remove done
  before (done) ->
    agent
      .post('/v1/logMeIn')
      .set('Accept', 'application/json')
      .send(username: config.admin.name, password: config.admin.password)
      .end done

  describe 'getAllQuoteProviders', ->
    response = null
    before (done) ->
      agent.get '/v1/getAllQuoteProviders'
        .set 'Accept', 'application/json'
        .end (err, res) ->
          response = res
          done()

    it 'responds with 200', ->
      expect(response.statusCode).to.equal 200

    it 'sets content-type to text/html', ->
      expect(response.headers).to.have.property('content-type').equal 'text/html'

    it 'response is not empty', ->
      expect(response).to.have.property('text').length.to.be.above 0

  describe 'inputQuoteProvider', ->
    response = null
    before (done) ->
      agent.get '/v1/inputNewQuoteProvider'
        .set 'Accept', 'application/json'
        .end (err, res) ->
          response = res
          done()

    it 'responds with 200', ->
      expect(response.statusCode).to.equal 200

    it 'sets content-type to text/html', ->
      expect(response.headers).to.have.property('content-type').equal 'text/html'
  
    it 'response is not empty', ->
      expect(response).to.have.property('text').length.to.be.above 0

  describe 'showSelecatableTableOfProviders', ->
    response = null
    before (done) ->
      agent.get '/v1/addNewQuoteForQuoteProvider'
        .set 'Accept', 'application/json'
        .end (err, res) ->
          response = res
          done()

    it 'responds with 200', ->
      expect(response.statusCode).to.equal 200

    it 'sets content-type to text/html', ->
      expect(response.headers).to.have.property('content-type').equal 'text/html'
  
    it 'response is not empty', ->
      expect(response).to.have.property('text').length.to.be.above 0

  describe 'switchEnabledOnProvider', ->
    response = null
    quoteProvider = null

    before (done) ->
      quoteProvider = Factory.build('quoteProvider')
      quoteProvider.save (err, doc) ->
        done()

    before (done) ->
      agent.post '/v1/switchEnableOnProvider'
        .set 'Accept', 'application/json'
        .send identifier: quoteProvider.identifier
        .end (err, res) ->
          response = res
          done()

    it 'responds with 200', ->
      expect(response.statusCode).to.equal 200

    it 'sets content-type to application/json', ->
      expect(response.headers).to.have.property('content-type').equal 'application/json'
  
    it 'response is not empty', ->
      expect(response.headers).to.have.property('content-length').length.to.be.above 0

  describe 'addQuoteProvider', ->
    response = null

    describe 'valid parameters', ->
      quoteProvider = Factory.attributes 'quoteProvider'

      before (done) ->
        agent.post '/v1/addNewQuoteProvider'
          .set 'Accept', 'application/json'
          .send name: quoteProvider.name, category: quoteProvider.category, urllink: quoteProvider.url
          .end (err, res) ->
            response = res
            done()

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'sets content-type to application/json', ->
        expect(response.headers).to.have.property('content-type').equal 'text/html'
    
      it 'response is not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0

      it 'sends confirm message', ->
        expect(response.text).to.contain 'Added new Quote Provider'

    describe 'invalid parameters', ->
      before (done) ->
        agent.post '/v1/addNewQuoteProvider'
          .set 'Accept', 'application/json'
          .send name: ''
          .end (err, res) ->
            response = res
            done()

      it 'responds with 200', ->
        expect(response.statusCode).to.equal 200

      it 'renders error page', ->
        expect(response.text).to.contain '<h1>Requires all Parameters</h1>'
  xdescribe 'editQuoteProvider', ->
    response = null
    quoteProvider = null

    before (done) ->
      quoteProvider = Factory.build('quoteProvider')
      quoteProvider.save (err, doc) ->
        done()

    before (done) ->
      agent.post '/v1/editQuoteProvider'
        .set 'Accept', 'application/json'
        .send quoteProvider: quoteProvider.name
        .end (err, res) ->
          response = res
          done()

    it 'responds with 302', ->
      expect(response.statusCode).to.equal 302

    it 'sets content-type to application/json', ->
      expect(response.headers).to.have.property('content-type').equal 'application/json'
  
    it 'response is not empty', ->
      expect(response).to.have.deep.property('headers.content-length').equal 0

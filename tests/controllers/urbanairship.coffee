app = require "#{rootDir}/server"
request = require 'supertest'
agent = request.agent app
config = require "#{rootDir}/config/application"
crypto = require 'crypto'
context = describe


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

context "UrbanAirShip Controller", ->

  before login
  after logout

  describe "#broadcastForm", ->
    response = null

    before (done) ->
      agent
        .get('/v1/ua/broadcast')
        .end (err, res) ->
          response = res
          done()

    it 'responds with 200', ->
      expect(response).to.have.property('statusCode').equal 200

    it 'sets content-type to text/html', ->
      expect(response.headers).to.have.property('content-type').equal 'text/html'

    it 'response is not empty', ->
      expect(response).to.have.property('text').length.to.be.above 0



  describe "#broadcast", ->

    describe "no message sent", ->
      response = null
      before (done) ->
        agent
          .post('/v1/ua/broadcast')
          .end (err, res) ->
            response = res
            done()


      it 'responds with 200', ->
        expect(response).to.have.property('statusCode').equal 200

      it 'sets content-type to text/html', ->
        expect(response.headers).to.have.property('content-type').equal 'text/html'

      it 'response is not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0

      it 'renders correct error message', ->
        expect(response.text).to.contain 'Message is required'


    describe "correct api call", ->
      response = null
      before (done) ->
        agent
          .post('/v1/ua/broadcast')
          .send('message' : 'some message')
          .end (err, res) ->
            response = res
            done()


      it 'responds with 200', ->
        expect(response).to.have.property('statusCode').equal 200

      it 'sets content-type to text/html', ->
        expect(response.headers).to.have.property('content-type').equal 'text/html'

      it 'response is not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0

      it 'renders correct error message', ->
        expect(response.text).to.contain 'Success. Notification has been sent to UrbanAirShip service.'

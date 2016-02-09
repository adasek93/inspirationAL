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

describe 'Login Controller', ->
  #log out before testing login, duh
  before logout
  after logout



  describe 'loggedInPage', ->
    error = null
    response = null

    before (done) ->
      agent
        .get('/v1/loggedIn')
        .end (err, res) ->
          error = err
          response = res
          done()


    it 'responds to GET /v1/loggedIn', ->
      expect(response).to.exist

    it 'responds with 200', ->
      expect(response.statusCode).to.equal 200

    it 'responds with content-type of text/html', ->
      expect(response.headers).to.have.property('content-type').equal 'text/html'

    it 'response in not empty', ->
      expect(response).to.have.property('text').length.to.be.above 0


  describe 'signInPage', ->
    error = null
    response = null

    before (done) ->
      agent
        .get('/v1/signIn')
        .end (err, res) ->
          error = err
          response = res
          done()


    it 'responds to GET /v1/signIn', ->
      expect(response).to.exist

    it 'responds with 200', ->
      expect(response.statusCode).to.equal 200

    it 'responds with content-type of text/html', ->
      expect(response.headers).to.have.property('content-type').equal 'text/html'

    it 'response in not empty', ->
      expect(response).to.have.property('text').length.to.be.above 0


  describe 'logIn', ->

    before logout
    after logout

    describe 'invalid credentials', ->
      before logout
      after logout

      error = null
      response = null

      before (done) ->
        agent
          .post('/v1/logMeIn')
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/logMeIn', ->
        expect(response).to.exist

      it 'responds with 403', ->
        expect(response.statusCode).to.equal 403

      it 'responds with content-type of text/html', ->
        expect(response.headers).to.have.property('content-type').equal 'text/html'

      it 'response in not empty', ->
        expect(response).to.have.property('text').length.to.be.above 0

    describe 'valid credentials', ->
      
      before logout
      after logout

      error = null
      response = null

      before (done) ->
        agent
          .post('/v1/logMeIn')
          .send(username: config.admin.name, password: config.admin.password)
          .end (err, res) ->
            error = err
            response = res
            done()

      it 'responds to POST /v1/logMeIn', ->
        expect(response).to.exist
    
      it 'responds with 302', ->
        expect(response.statusCode).to.equal 302

      it 'redirects to /v1/loggedIn', ->
        expect(response.header['location']).to.include('/v1/loggedIn')

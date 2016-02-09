request = require 'supertest'
express = require 'express'
app = require "#{rootDir}/server"
agent = request.agent(app)
config = require(rootDir + '/config/application')

checkAuthFailure = (url, method) ->
  it "requires authentication for #{method.toUpperCase()} #{url}", (done) ->
    agent[method](url)
      .set('Accept', 'application/json')
      .expect(302)
      .end (err, res) ->
        expect(res.header['location']).to.include('/v1/signIn')
        done()

checkAuthSuccess = (url, method) ->
  it "passes authentication for #{method.toUpperCase()} #{url}", (done) ->
    agent[method](url)
      .set('Accept', 'application/json')
      .expect( (res) -> res.status is 302 )
      .end (err, res) ->
        expect(res.header['location']).not.to.include('/v1/signIn')
        done()


describe 'authentication redirect', ->
  before (done) ->
    agent
      .get('/v1')
      .send(session: null)
      .end (err, res) -> done()

  
  checkAuthFailure "/v1/addNewQuoteProvider", "post"
  checkAuthFailure "/v1/inputNewQuoteProvider", "get"
  checkAuthFailure "/v1/addNewQuoteForQuoteProvider", "get"
  checkAuthFailure "/v1/inputNewQuoteForProvider", "post"
  checkAuthFailure "/v1/saveNewQuoteForProvider", "post"
  checkAuthFailure "/v1/getAllQuoteProviders", "get"
  checkAuthFailure "/v1/getAllQuotesForProvider", "get"
  checkAuthFailure "/v1/showQuotesForProvider", "post"
  checkAuthFailure "/v1/switchEnableOnProvider", "post"
  checkAuthFailure "/v1/editQuoteForProvider", "post"
  checkAuthFailure "/v1/editQuoteProvider", "post"
  
describe 'no auth redirect', ->
  before (done) ->
    agent
      .post('/v1/logMeIn')
      .send(username: config.admin.name, password: config.admin.password)
      .end (err, res) ->
        done()
        
        

  checkAuthSuccess "/v1/addNewQuoteProvider", "post"
  checkAuthSuccess "/v1/inputNewQuoteProvider", "get"
  checkAuthSuccess "/v1/addNewQuoteForQuoteProvider", "get"
  checkAuthSuccess "/v1/inputNewQuoteForProvider", "post"
  checkAuthSuccess "/v1/saveNewQuoteForProvider", "post"
  checkAuthSuccess "/v1/getAllQuoteProviders", "get"
  checkAuthSuccess "/v1/getAllQuotesForProvider", "get"
  checkAuthSuccess "/v1/showQuotesForProvider", "post"
  checkAuthSuccess "/v1/switchEnableOnProvider", "post"
  checkAuthSuccess "/v1/editQuoteForProvider", "post"
  checkAuthSuccess "/v1/editQuoteProvider", "post"

app = require "#{rootDir}/server"
request = require 'supertest'
agent = request.agent app
config = require "#{rootDir}/config/application"

describe 'HtmlController', ->
  describe 'loggedInPage', ->
    response = null

    before (done) ->
      agent.get '/v1/loggedIn'
        .set 'Accept', 'application/json'
        .end (err, res) ->
          response = res
          done()

    it 'responds with 200', ->
      expect(response).to.have.property('statusCode').equal 200

    it 'sets content-type to text/html', ->
      expect(response).to.have.deep.property('headers.content-type').equal 'text/html'

  describe 'loggedInPage', ->
    response = null

    before (done) ->
      agent.post '/v1/logMeIn'
        .set 'Accept', 'application/json'
        .send username: config.admin.name, password: config.admin.password
        .end done

    before (done) ->
      agent.get '/v1/getAllQuotesForProvider'
        .set 'Accept', 'application/json'
        .end (err, res) ->
          response = res
          done()

    it 'responds with 200', ->
      expect(response).to.have.property('statusCode').equal 200

    it 'sets content-type to text/html', ->
      expect(response).to.have.deep.property('headers.content-type').equal 'text/html'



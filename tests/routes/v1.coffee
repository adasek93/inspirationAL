request = require 'supertest'
express = require 'express'
app = require "#{rootDir}/server"

describe '/v1', ->
  response = null
  before (done) ->
    request(app).get('/v1').set('Accept', 'application/json').end (err, res) ->
      response = res
      done()
  
  it 'responds with 200', ->
    expect(response.statusCode).to.equal 200
  
  it 'content application/json', ->
    expect(response.headers).to.have.property('content-type').equal 'application/json'

  it 'response is not empty', ->
    expect(response.headers).to.have.property('content-length').above 0


app = require "#{rootDir}/server"

describe 'Quote Model Class', ->
  it 'is defined', ->
    expect(Quote).to.be.defined

  it 'is mongoose model', ->
    expect(Quote.modelName).to.equal('QuoteSchema')

  it 'can be instantiated', ->
    quote = new Quote

    expect(quote).to.be.instanceof(Quote)


describe 'Qoute Model Instance', ->

  fakeQuote = 
    name: 'A quote name'
    quote: 'Quote content'

  #clean db before each test
  beforeEach (done) ->
    Quote.remove(done)


  describe '#save', ->

    currentQuote = null

    beforeEach (done) ->
      currentQuote = new Quote fakeQuote
      currentQuote.identifier = currentQuote._id
      done()

    it 'has an id', ->
      expect(currentQuote._id).to.be.an 'object'

    it 'is enabled by default', ->
      expect(currentQuote.isEnabled).to.be.true

    it 'has a name', (done) ->
      currentQuote.save (err, q) ->
        expect(err).to.not.exist
        expect(q.name).to.equal 'A quote name'
        done()

    it 'has a quote content', (done) ->
      currentQuote.save (err, q) ->
        expect(err).to.not.exist
        expect(q.quote).to.equal 'Quote content'
        done()

    it 'requires a name', (done) ->
      currentQuote.name = undefined

      currentQuote.save (err, q) ->
        expect(err).to.exist
        expect(q).to.not.exist
        done()

    it 'requires quote content', (done) ->
      currentQuote.quote = undefined

      currentQuote.save (err, q) ->
        expect(err).to.exist
        expect(q).to.not.exist
        done()


app = require "#{rootDir}/server"

describe 'QuoteProvider Model Class', ->
  it 'is defined', ->
    expect(Quote).to.be.defined

  it 'is mongoose model', ->
    expect(Quote.modelName).to.equal('QuoteSchema')

  it 'can be instatinated', ->
    quote = new QuoteProvider

    expect(quote).to.be.instanceof(QuoteProvider)


describe 'QouteProvider Model Instance', ->

  fakeQuoteProvider = 
    name: 'A quote name'
    url: 'http://some.url/'
    category: 'Category'


  #clean db before each test
  beforeEach (done) ->
    QuoteProvider.remove(done)

  after (done) -> QuoteProvider.remove done

  describe '#save', ->

    currentQuoteProvider = null

    beforeEach (done) ->
      currentQuoteProvider = new QuoteProvider fakeQuoteProvider
      currentQuoteProvider.identifier = currentQuoteProvider._id
      done()

    it 'has an id', ->

      expect(currentQuoteProvider._id).to.be.an 'object'

    it 'is enabled by default', ->

      expect(currentQuoteProvider.isEnabled).to.be.true

    it 'has a name', (done) ->
      currentQuoteProvider.save (err, q) ->
        expect(err).to.not.exist
        expect(q.name).to.equal 'A quote name'
        done()

    it 'has an url', (done) ->
      currentQuoteProvider.save (err, q) ->
        expect(err).to.not.exist
        expect(q.url).to.be.a 'string'
        expect(q.url).to.equal 'http://some.url/'
        done()

    it 'has a category', (done) ->
      currentQuoteProvider.save (err, q) ->
        expect(err).to.not.exist
        expect(q.category).to.be.a 'string'
        expect(q.category).to.equal 'Category'
        done()

    it 'requires a name', (done) ->
      currentQuoteProvider.name = undefined

      currentQuoteProvider.save (err, q) ->
        expect(err).to.exist
        expect(q).to.not.exist
        done()

    it 'requires an url', (done) ->
      currentQuoteProvider.url = undefined

      currentQuoteProvider.save (err, q) ->
        expect(err).to.exist
        expect(q).to.not.exist
        done()

    it 'requires a category', (done) ->
      currentQuoteProvider.category = undefined

      currentQuoteProvider.save (err, q) ->
        expect(err).to.exist
        expect(q).to.not.exist
        done()


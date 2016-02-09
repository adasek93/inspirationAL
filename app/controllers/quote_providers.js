exports.addQuoteProvider = function(req, res){
	var name = req.param('name');
	var category = req.param('category');
	var URLLink = req.param('urllink');

	if(name.length == 0 || category.length == 0 || URLLink.length == 0){
		var errorHTML = require('./html');
		errorHTML.errorPageParameters(req, res);

		return;
	}
	var newProvider = {
		name: name,
		url: URLLink,
		category: category,
		identifier: require('mongoose').Types.ObjectId()
	};

	var quoteProvider = quoteProviderTable();

	var provider = new quoteProvider(newProvider);
	provider.save( function(error, data){
		if(error){
			res.writeHead(200, "OK", {'Content-Type': 'text/html'});
			res.write('<html><head><title>inspAlarm CMS</title></head><body>');
			res.write('<h1>Failed to add new Quote Provider</h1>');
			res.write('<br><br />');
			res.write('<button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Back</button>');
			res.write('</body></html');
			res.end();
		}
		else {
			res.writeHead(200, "OK", {'Content-Type': 'text/html'});
			res.write('<html><head><title>inspAlarm CMS</title></head><body>');
			res.write('<h1>Added new Quote Provider</h1>');
			res.write('<br><br />');
			res.write('<button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Ok</button>');
			res.write('</body></html');
			res.end();
		}
	});
}

exports.inputQuoteProvider = function(req, res){
	res.writeHead(200, "OK", {'Content-Type': 'text/html'});
	res.write('<html><head><title>inspAlarm CMS</title></head><body>');
	res.write('<h1>Enter in the fields to add a new provider</h1>');
	res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/addNewQuoteProvider" method="post">');
	res.write('Name: <input type="text" name="name" value="" /><br />');
	res.write('Category:  <input type="text" name="category" value="" /><br />');
	res.write('URL Link:  <input type="text" name="urllink" value="" /><br />');
	res.write('<br><br />');
	res.write('<input type="submit"/>');
	res.write('</form><button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Back</button></body></html');
	res.end();
}

exports.getAllQuoteProviders = function(req, res) {
	searchForQuoteProvider(null, res);
}

exports.showSelecatableTableOfProviders = function(req, res){
	var quoteProvider = quoteProviderTable();

	var htmlController = require('./html');

	quoteProvider.find({}, function(error, data){
		if(error) {
			res.json({ 'error' : error });
		}
		else if(data == null) {
			res.json({ 'error' : 'Database not found' });
		}
		else {
			htmlController.createSelectableTable(data, res);
		}
	});
}

exports.switchEnabledOnProvider = function(req, res){
	var identifier = req.body.identifier;

	if(identifier.length == 0){
		res.send('No Identifier');
	}

	var quoteProvider = quoteProviderTable();

	quoteProvider.findOne({ identifier: identifier }, function(error, provider){
		if(error) {
			res.json({ 'error' : error });
		}
		else if(provider == null) {
			res.json({ 'error' : 'Database not found' });
		}
		else {
			if(provider.isEnabled == true){
				provider.isEnabled = false;
			}
			else {
				provider.isEnabled = true;
			}

			provider.save( function(error, data){
				res.json({ message: 'ok' });
			});
		}
	});
}

exports.editQuoteProvider = function(req, res){
	var quoteProvider = req.param('quoteProvider');

	var quoteProviderNew = quoteProviderTable();
	quoteProviderNew.findOne({ name: quoteProvider }, function(error, data){
		if(error) {
			res.json({ 'error' : error });
		}
		else if(data == null) {
			res.json({ 'error' : 'Database not found' });
		}
		else {
			data.remove({ name: quoteProvider }, function(error){
				res.redirect('/v1/getAllQuoteProviders');
			});
		}
	});
}





exports.getQuoteProviderSchemas2 = function(req, res){
	getCollection('quoteproviderschemas2', req, res);
}

exports.getQuoteProvider2 = function(req, res){
	getCollection('quoteproviders2', req, res);
}

exports.getUsers2 = function(req, res) {
	getCollection('users2', req, res);
}

function getCollection(collection, req, res) {
	var db = require('orchestrate')('ff739c0d-61e2-4120-bf30-b1626aa183df');
	var myJson;

	db.list(collection, {limit:10}).then(function (doc) {
		myJson = doc.body.results;
		getNextPage(doc, myJson, res);
	})
	.fail(function (err) {
		console.log(err);
	})
}

function getNextPage(doc, myJson, res) {
	if(doc.links && doc.links.next){
		doc.links.next.get().then(function(doc2){
			myJson = myJson.concat(doc2.body.results);
			if(doc2.links && doc2.links.next){
				getNextPage(doc2, myJson, res);
			} else{
				res.json(myJson);
			}
		})
	} else{
		res.json(myJson);
	}
}




function searchForQuoteProvider(quoteProviderNumber, res) {
	var quoteProvider = quoteProviderTable();

	var htmlController = require('./html');
	if(quoteProviderNumber == null) {
		quoteProvider.find({}, function(error, data){
			if(error) {
				res.json({ 'error' : error });
			}
			else if(data == null) {
				res.json({ 'error' : 'Database not found' });
			}
			else {
				htmlController.createTable(data, res);
			}
		});
	}
	else {
		quoteProvider.findOne({ identifier: quoteProviderNumber }, function(error, data){
			if(error) {
				res.json({ 'error' : error });
			}
			else if(data == null) {
				res.json({ 'error' : 'Database not found' });
			}
			else {
				res.json({ 'Data' : data });
			}
		});
	}
}

function quoteProviderTable() {
	var mongoose = require('mongoose');
	var quoteProviderTable = mongoose.model('QuoteProviderSchema');
	return quoteProviderTable;
}

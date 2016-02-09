exports.loggedInPage = function(req, res){
	res.writeHead(200, "OK", {'Content-Type': 'text/html'});
	res.write('<html><head><title>inspAlarm CMS</title></head><body>');
	res.write('<h1>Welcome to inspAlarm CMS</h1>');
	res.write('<h2>Please Choose an Action</h2>');
	res.write('<br><br />');
	res.write('<button onClick="javascript:window.location.href=\'/v1/getAllQuoteProviders\'">View Quote Providers</button>');
	res.write('<button onClick="javascript:window.location.href=\'/v1/inputNewQuoteProvider\'">Add a Quote Provider</button>');
	res.write('<br><br />');
	res.write('<button onClick="javascript:window.location.href=\'/v1/getAllQuotesForProvider\'">View All Quotes for Provider</button>');
	res.write('<button onClick="javascript:window.location.href=\'/v1/addNewQuoteForQuoteProvider\'">Add new Quote for Provider</button>');
	res.write('<button onClick="javascript:window.location.href=\'/v1/ua/broadcast\'">Create a new push notification</button>');
	res.write('</body></html');
	res.end();
}

exports.errorPageParameters = function(req, res){
	res.writeHead(200, "OK", {'Content-Type': 'text/html'});
	res.write('<html><head><title>inspAlarm CMS</title></head><body>');
	res.write('<h1>Requires all Parameters</h1>');
	res.write('<br><br />');
	res.write('<button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Ok</button>');
	res.write('</body></html');
	res.end();
}

exports.createTable = function(data, res) {
	res.writeHead(200, "OK", {'Content-Type': 'text/html'});
	res.write('<table border="1" width="100%"><tr><th scope="col">Name</th><th scope="col">Category</th><th scope="col">URL</th><th scope="col">DateAdded</th><th scope="col">No. of Quotes</th><th scope="col">Delete Provider</th></tr>');

	for(var j = 0; j < data.length; j++){
		res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/editQuoteProvider" method="post">');
		res.write('<tr>');
		res.write('<td>'+ data[j]['name'] + '</td>');
		res.write('<td>'+ data[j]['category'] + '</td>');
		res.write('<td>'+ data[j]['url'] + '</td>');
		res.write('<td>'+ data[j]['dateAdded'] + '</td>');
		res.write('<td>'+ data[j]['quotes'].length + '</td>');

		res.write('<input type="hidden" name="quoteProvider" value="' + data[j]['name'] + '"/>');
		res.write('<td><input type="submit" value="Delete Quote Provider"/></td>');
		res.write('</form></tr>');
	}

	res.write('</table>');

	res.write('<br><br />');
	res.write('<button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Back</button>');
	res.write('<button onClick="javascript:window.location.href=\'/v1/inputNewQuoteProvider\'">Add a Quote Provider</button>');

	res.end();
}

exports.createSelectableTable = function(data, res) {
	res.writeHead(200, "OK", {'Content-Type': 'text/html'});
	res.write('<table id=oTable border="1" width="100%"><tr><th scope="col">Quote Provider</th></tr>');
	res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/inputNewQuoteForProvider" method="post">');
	res.write('<tr><td><select style="width: 100%" name="selectpicker">');

	for(var j = 0; j < data.length; j++){
		var optionText = data[j]['name'];
		res.write('<option name=' + j + '>' + optionText + '</option>');
	}

	res.write('</select></td></tr></table>');

	res.write('<br><br />');
	res.write('<input type="submit" value="Add Quote" /></form>');
	res.write('<button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Back</button>');

	res.end();
}

exports.createSelectableTableForQuotes = function(data, res) {
	var quoteProvider = quoteProviderTable();

	quoteProvider.find({}, function(error, data){
		if(error) {
			res.json({ 'error' : error });
		}
		else if(data == null) {
			res.json({ 'error' : 'Database not found' });
		}
		else {
			res.writeHead(200, "OK", {'Content-Type': 'text/html'});
			res.write('<table id=oTable border="1" width="100%"><tr><th scope="col">Quote Provider</th></tr>');
			res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/showQuotesForProvider" method="post">');
			res.write('<tr><td><select style="width: 100%" name="selectpicker">');

			for(var j = 0; j < data.length; j++){
				var optionText = data[j]['name'];
				res.write('<option name=' + j + '>' + optionText + '</option>');
			}

			res.write('</select></td></tr></table>');

			res.write('<br><br />');
			res.write('<input type="submit" value="View Quotes" /></form>');
			res.write('<button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Back</button>');

			res.end();
		}
	});
}

function quoteProviderTable() {
	return QuoteProvider;
}

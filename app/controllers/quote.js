exports.addNewQuotesForProvider = function(req, res) {
  var selectedName = req.body.selectpicker;
  
  if(selectedName == null){
    selectedName = req.param('providerName');
  }
  
  res.writeHead(200, "OK", {'Content-Type': 'text/html'});
  res.write('<html><head><title>inspAlarm CMS</title></head><body>');
  res.write('<h1>Enter in the fields to add a new quote for provider ' + selectedName + '</h1>');
  res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/saveNewQuoteForProvider" method="post">');
  res.write('Name: <input type="text" name="name" value="" /><br />');
  res.write('Quote:  <input type="text" name="quote" value="" /><br />');
  res.write('<input type="hidden" name="providerName" value="' + selectedName + '" /><br />');
  res.write('<input type="submit"/>');
  res.write('</form><button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Back</button></body></html');
  res.end();
}

exports.saveNewQuoteForProvider = function(req, res) {
  var quoteName = req.param('name');
  var quoteDescription = req.param('quote');
  var quoteProviderName = req.param('providerName');
  
  var quoteProvider = quoteProviderTable();

  quoteProvider.findOne({ name: quoteProviderName }, function(error, data){
    
    if(error) {
      res.json({ 'error' : error });

    }
    else if(data == null) {
      res.json({ 'error' : 'Database not found' });
    }
    else {
      var quoteTable = quoteTableNew();
      
      var newQuote = {
        name: quoteName,
        quote: quoteDescription,
        identifier: require('mongoose').Types.ObjectId()
      };
      
      data.quotes.push(newQuote);
      data.save( function(error, data){
        if(error){
          res.writeHead(200, "OK", {'Content-Type': 'text/html'});
          res.write('<html><head><title>inspAlarm CMS</title></head><body>');
          res.write('<h1>Failed to add new Quote to Provider ' + quoteProviderName + '</h1>');
          res.write('<br><br />');
          res.write('<button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Back</button>');
          res.write('</body></html');
          res.end();
        }
        else {
          res.writeHead(200, "OK", {'Content-Type': 'text/html'});
          res.write('<html><head><title>inspAlarm CMS</title></head><body>');
          res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/inputNewQuoteForProvider" method="post">');          
          res.write('<h1>Added new Quote to Provider ' + quoteProviderName + '</h1>');
          res.write('<input type="hidden" name="providerName" value="' + quoteProviderName + '" /><br />');
          res.write('<input type="submit" value="Add Another Quote"/>');                  
          res.write('</form><button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Ok</button>');         
          res.write('</body></html');
          res.end();
        }
      });
    }
  });
}

exports.getAllQuotesForProvider = function(req, res) {
  var quoteProviderName = req.body.selectpicker;
  
  if(quoteProviderName == null){
    quoteProviderName = req.param('providerName');
  }
    
  var quoteProvider = quoteProviderTable();
  quoteProvider.findOne({ name: quoteProviderName }, function(error, data){
    if(error) {
      res.json({ 'error' : error });
    }
    else if(data == null) {
      res.json({ 'error' : 'Database not found' });
    }
    else {
      res.writeHead(200, "OK", {'Content-Type': 'text/html'});
      res.write('<table border="1" width="100%"><tr><th scope="col">Name</th><th scope="col">Quote</th><th scope="col">Delete Quotes</th></tr>');
  
      for(var j = 0; j < data.quotes.length; j++){    
        res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/editQuoteForProvider" method="post">');
        res.write('<tr>');
        res.write('<td>'+ data.quotes[j]['name'] + '</td>');
        res.write('<td>'+ data.quotes[j]['quote'] + '</td>'); 
        res.write('<input type="hidden" name="identifier" value="' + data.quotes[j]['identifier'] + '"/>');   
        res.write('<input type="hidden" name="quoteProvider" value="' + quoteProviderName + '"/>');               
        res.write('<td><input type="submit" value="Delete Quote"/></td>');
        res.write('</form></tr>');
      }
    
      res.write('</table>');
  
      res.write('<br><br />');  
      res.write('<button onClick="javascript:window.location.href=\'/v1/loggedIn\'">Back</button>');
      res.end();
    }
  });
}

exports.editQuoteWithIdentifier = function(req, res){
  var quoteIdentifier = req.param('identifier');
  var quoteProvider = req.param('quoteProvider');
  var quoteProviderTableNew = quoteProviderTable();
  
  quoteProviderTableNew.findOne({ name: quoteProvider }, function(error, data){
    if(error) {
      res.json({ 'error' : error });
    }
    else if(data == null) {
      res.json({ 'error' : 'Database not found' });
    }
    else {
      var foundQuote;
    
      for(var j = 0; j < data.quotes.length; j++){  
        if(data.quotes[j]['identifier'] == quoteIdentifier){
          foundQuote = data.quotes[j];
          break;
        }
      }
      
      if(foundQuote){
        data.quotes.pull(foundQuote);
        data.save( function(error, data){
          res.writeHead(200, "OK", {'Content-Type': 'text/html'});
          res.write('<html><head><title>inspAlarm CMS</title></head><body>');
          res.write('<h1>Quote Deleted</h1>');
          res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/showQuotesForProvider" method="post">');
          res.write('<input type="hidden" name="providerName" value="' + quoteProvider  + '" /><br />');
          res.write('<input type="submit" value="Ok"/>');
          res.write('</form></body></html');
          res.end();
        });
      }
    }
  }); 
}

function quoteTableNew() {
  return Quote;
}

function quoteProviderTable() {
  return QuoteProvider;
}
var config = require(rootDir + '/config/application');

exports.signInPage = function(req, res) {
	res.writeHead(200, "OK", {'Content-Type': 'text/html'});
	res.write('<html><head><title>inspAlarm CMS</title></head><body>');
	res.write('<h1>Welcome to inspAlarm CMS</h1>');
	res.write('<h2>Please Log In</h2>');
	res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/logMeIn" method="post">');
	res.write('UserName: <input type="text" name="username" value="" /><br />');
	res.write('Password:  <input type="password" name="password" value="" /><br />');
	res.write('<br><br />');
	res.write('<input type="submit"/>');
	res.write('</form></body></html');
	res.end();
}

exports.logIn = function(req, res) {
	var userName = req.param('username');
	var password = req.param('password');

	if (userName == config.admin.name && password == config.admin.password) {

    		req.session.user_id = require('mongoose').Types.ObjectId();

    		res.redirect('/v1/loggedIn');
  	} 
  	else {
		res.writeHead(403, "Forbidden", {'Content-Type': 'text/html'});
		res.write('<html><head><title>inspAlarm CMS</title></head><body>');
		res.write('<h2>The username or password was incorrect</h2>');
		res.write('<form enctype="application/x-www-form-urlencoded" action="/v1/signIn" method="get">');
		res.write('<input type="submit"/>');			  
		res.write('</form></body></html');
		res.end();
  	}
}

exports.logOut = function(req, res) {
	  delete req.session.user_id;
	  res.redirect('/login');
}

exports.checkAuth = function(req, res) {
	if (!req.session.user_id) {
		return false;
	} 
	else {
		return true;
	}
}

# License Node

license_node - This is a license REST API written in NodeJS, using MongoDB and Mongoose.

The application is currently hosted at [http://nodetranslator.eu01.aws.af.cm](http://nodetranslator.eu01.aws.af.cm).

## Web Services

The webservices are RESTful and currently accept and return JSON. A web service will return one of the standard HTTP status codes - anything in the range 200-299 can be considered success, anything else is a failure.

**KeyValues**
	
	- bundleID This is used for the BundleID field in a POST request.
	- licenseKey This is used for the LicenseKey field in a POST request.
	- nameForLicense This is used for the Name field in a POST request.
	- isValid This is returned when checking a License.
	- numberOfHits This is returned on GetAllLicences and shows the amount of times that License has been requested.
	- lastAccessedUserDate This is returned on GetAllLicences and shows the last timestamp a license was checked.
	- lastAccessedAdminDate This is returned on GetAllLicences and shows the last timestamp a license was modified by an Admin.

### Check License

Checks a license sent to it (if it exists) and returns the 'isValid' boolean saved in the Database. This is so that an application can check to see if the license provided is valid or not.

**Endpoint**

	POST /v1/checkLicense

**Data**

	bundleID=com.fbeasley.com&licenseKey=25890&nameForLicense=Francis

**Response**

	{
	   "isValid": true
	}

**Errors**

	{
	   "error": {AN_ERROR}
	}

### Creating a License

Creates a new license in the database. This has to be unique based on BundleID, Name and License Key.

**Endpoint**

	POST /v1/addLicense

**Data**

	bundleID=com.fbeasley.com&licenseKey=25890&nameForLicense=Francis

**Response**

	{
	    "hasCreated": true
	}

**Errors**

This is returned if a License that is sent already exists in the database	

	{
	   "hasCreated": "Exists"
	}

### Updating a License


### Invalidating a License


### Validating a License


### Deleting a License


### Get all Licences


### Standard Errors

This is a list of the standard errors that are returned from the WebService. Make sure to check to see if "error" exists within the JSON response.

**Response**

	{
	    "error": {AN_ERROR}
	}

**Errors**
	- Database Connection Error
	- Not all parameters sent
	- Adding a license that already exists
	- An underlying error with addition/update/deletion from the Database

## Things to do 

## Thank you for reading this ReadMe, I hope it was useful and explained the service.

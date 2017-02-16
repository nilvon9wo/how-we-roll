@isTest
global class HTTP_TestRestfulCalloutMock implements HttpCalloutMock {
	Integer statusCode;
	String body;
	
	global HTTP_TestRestfulCalloutMock(Integer statusCode, String body) {
		this.statusCode = statusCode;
		this.body = body;
	}

	global HTTP_TestRestfulCalloutMock(Integer statusCode) {
		this(statusCode, '{"status":"success"}');
	}
	
    global HttpResponse respond(HttpRequest request) {
    	HttpResponse response = new HttpResponse();
    	response.setHeader('Content-Type', 'application/json');
    	response.setBody(this.body);
    	response.setStatusCode(this.statusCode);
    	return response;
    }
}
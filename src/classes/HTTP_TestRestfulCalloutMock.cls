@isTest
global class HTTP_TestRestfulCalloutMock implements HttpCalloutMock {
	Integer statusCode;
	
	global HTTP_TestRestfulCalloutMock(Integer statusCode) {
		this.statusCode = statusCode;
	}
	
    global HttpResponse respond(HttpRequest request) {
    	HttpResponse response = new HttpResponse();
    	response.setHeader('Content-Type', 'application/json');
    	response.setBody('{"status":"success"}');
    	response.setStatusCode(this.statusCode);
    	return response;
    }
}
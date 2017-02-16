public abstract class HTTP_RestfulCalloutStrategy implements HTTP_RestfulCalloutStrategyInterface {
	private String endpoint; 
	public Integer targetId {get; set;}
	public String method {get; set;}
	public String contentType {get; set;}
	public String body {get; set;}
	public Set<Integer> successCodeSet = new Set<Integer>{ 200 }; 
	
	public HTTP_RestfulCalloutStrategy(String endpoint){
		this.endpoint = endpoint;
	}
	
	public HttpResponse execute() { 
		Http http = new Http();
		HttpRequest httpRequest = createRequest();
		
		HttpResponse response = http.send(httpRequest);
		return (!(this.successCodeSet.contains(response.getStatusCode()))) 
			? onFailure(response)
			: onSuccess(response);
	}
	
	@testVisible 	 
	private HttpRequest createRequest() {
		HttpRequest request = new HttpRequest();

		String endpoint = this.endpoint;
		if (targetId != null) {
			endpoint += '/' + targetId;
		}
		request.setEndpoint(endpoint);

		String method = (!String.isBlank(this.method)) ? this.method : 'GET'; 
		request.setMethod(method);

		if (!String.isBlank(this.contentType)){
			request.setHeader('Content-Type', this.contentType);
		}

		if (!String.isBlank(this.body)){
			request.setBody(this.body);
		}
		return request;
	} 	
	 	
	 	
	public abstract HttpResponse onSuccess(HttpResponse response);
	 	
	public virtual HttpResponse onFailure(HttpResponse response) {
		System.debug(LoggingLevel.ERROR, 'Unexpected Response: ' + response.toString());
		return response;
	}
}
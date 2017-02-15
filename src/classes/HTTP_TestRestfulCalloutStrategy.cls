@isTest
public class HTTP_TestRestfulCalloutStrategy extends HTTP_RestfulCalloutStrategy {
	public Boolean wasSuccess {get; private set;}
	public Boolean wasFailure {get; private set;}
	
	public HTTP_TestRestfulCalloutStrategy(String endpoint) {
		super(endpoint);
		this.wasSuccess = false;
		this.wasFailure = false;
	}
	 
	public override HttpResponse onSuccess(HttpResponse response) {
		this.wasSuccess = true;
		return response; 
	}    	

	public override HttpResponse onFailure(HttpResponse response) {
		super.onFailure(response);
		this.wasFailure = true;
		return response; 
	}    	
}
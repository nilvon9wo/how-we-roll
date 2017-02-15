@isTest  
private class HTTP_RestfulCalloutStrategyTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	private static final String TEST_ENDPOINT = 'http://test.example.com/';
	
	@isTest static void testExecuteShouldSucceed() {
		Boolean willSucceed = true;
		testExecute(willSucceed);
	}

	@isTest static void testExecuteShouldFail() {
		Boolean willFail = false;
		testExecute(willFail);
	}
	
	private static void testExecute(Boolean shouldSucceed) {
		// Arrange
		HTTP_TestRestfulCalloutStrategy targetClass = new HTTP_TestRestfulCalloutStrategy(TEST_ENDPOINT);
		Integer successCode = shouldSucceed ? 200 : 500;
		Test.setMock(HttpCalloutMock.class, new HTTP_TestRestfulCalloutMock(successCode));

		// Act
		HttpResponse result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.execute();
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals(shouldSucceed, targetClass.wasSuccess);
		System.assertEquals(!shouldSucceed, targetClass.wasFailure);
		System.assertEquals(successCode, result.getStatusCode());
	}
	
	// ----------------------------------------------------------------------------------
	
	@isTest static void testConfigureRequestSetsEndPointWithoutTargetId() {
		Integer targetId = null;
		testConfigureRequestSetsEndpoint(targetId);
	}
	
	@isTest static void testConfigureRequestSetsEndPointWithTargetId() {
		// Arrange
		Integer targetId = 352;
		testConfigureRequestSetsEndpoint(targetId);
	}

	private static void testConfigureRequestSetsEndpoint(Integer targetId) {
		// Arrange
		HTTP_TestRestfulCalloutStrategy targetClass = new HTTP_TestRestfulCalloutStrategy(TEST_ENDPOINT);
		targetClass.targetId = targetId;
		
		// Act
		HttpRequest result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.createRequest();
            }
            Test.stopTest();
        }

		// Assert
		String expectedPath = TEST_ENDPOINT + ((targetId != null) ? ('/' + targetId) : ''); 
		System.assertEquals(expectedPath, result.getEndpoint());
	}
	
	@isTest static void testConfigureRequestWithoutExplicitMethod() {
		String method = null;
		testConfigureRequestSetsMethod(method);
	}
	
	@isTest static void testConfigureRequestWithExplicitMethod() {
		// Arrange
		String method = 'POST';
		testConfigureRequestSetsMethod(method);
	}

	private static void testConfigureRequestSetsMethod(String method) {
		// Arrange
		HTTP_TestRestfulCalloutStrategy targetClass = new HTTP_TestRestfulCalloutStrategy(TEST_ENDPOINT);
		targetClass.method = method;
		
		// Act
		HttpRequest result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.createRequest();
            }
            Test.stopTest();
        }

		// Assert
		String expectedMethod = (String.isBlank(method)) ? 'GET' : method; 
		System.assertEquals(expectedMethod, result.getMethod());
	}
	
	@isTest private static void testConfigureRequestSetsContentTypeHeader() {
		// Arrange
		HTTP_TestRestfulCalloutStrategy targetClass = new HTTP_TestRestfulCalloutStrategy(TEST_ENDPOINT);
		targetClass.contentType = 'Test Content';
		
		// Act
		HttpRequest result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.createRequest();
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals(targetClass.contentType, result.getHeader('Content-Type'));
	}
	
	@isTest private static void testConfigureRequestSetsBody() {
		// Arrange
		HTTP_TestRestfulCalloutStrategy targetClass = new HTTP_TestRestfulCalloutStrategy(TEST_ENDPOINT);
		targetClass.body = 'Test Body';
		
		// Act
		HttpRequest result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.createRequest();
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals(targetClass.body, result.getBody());
	}
	
	
	
}
@isTest
private class WarehouseCalloutServiceTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 

	@isTest static void testRunWarehouseEquipmentSync(){
		// Arrange
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
		
		// Act  
        System.runAs(TestRunner){
            Test.startTest(); 
            { 
		        WarehouseCalloutService.runWarehouseEquipmentSync();
            }
            Test.stopTest();
        } 

		// Assert
        System.assertEquals(1, [SELECT count() FROM Product2]);        
    }
    
}
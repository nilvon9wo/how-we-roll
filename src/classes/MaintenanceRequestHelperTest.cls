@isTest
private class MaintenanceRequestHelperTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void onAfterUpdateShouldUpdateWorkOrders(){
		// Arrange
		List<Case> maintenanceRequestList = new List<Case>(); 
		HWR_MaintenanceRequests maintenanceRequests;
		MaintenanceRequestHelper targetClass = new MaintenanceRequestHelper(maintenanceRequestList, maintenanceRequests);
		Map<Id,SObject> existingMaintenanceRequestMap = null; 
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.onAfterUpdate(existingMaintenanceRequestMap);
            }
            Test.stopTest();
        }

		// Assert
		// TO DO: assert results
		//System.assertEquals(EXPECTATION, ACTUAL);
	}
}
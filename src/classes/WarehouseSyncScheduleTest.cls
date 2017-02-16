@isTest
private class WarehouseSyncScheduleTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 

	@isTest static void testScheduleMorningRun(){
/*
		// Arrange
		Integer successCode = 200;
		String name = 'Test Equipment'; 
		String warehouseSku = 'Some Sku 2342';
		Decimal cost = 432;
		Decimal lifespan = 312;
		Decimal maintenancePeriod = 212;
		Decimal quantity = 153;
		Boolean isReplacement = true;
		String testBody = '[{' 
				+ '"name" : "' + name + '",'
				+ '"sku" : "' + warehouseSku + '",'
				+ '"cost" : ' + cost + ','
				+ '"lifespan" : ' + lifespan + ','
				+ '"maintenanceperiod" : ' + maintenancePeriod + ','
				+ '"quantity" : ' + quantity + ','
				+ '"replacement" : ' + isReplacement 
			+ '}]';
*/		
		Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

		// Act
		Id resultJobId;
        System.runAs(TestRunner){
            Test.startTest();
            {
                resultJobId = WarehouseSyncSchedule.scheduleMorningRun(); 
            }
            Test.stopTest();
        }
/*
		CronTrigger cronTrigger = [
			SELECT cronExpression, timesTriggered, nextFireTime 
			FROM CronTrigger 
			WHERE id = :resultJobId
		];

		System.assertEquals(0, cronTrigger.timesTriggered);
*/		
	}        
}
@isTest
private class WarehouseSyncScheduleTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 

	@isTest static void testScheduleMorningRun(){
		// Arrange
		// Nothing to do here.

		// Act
		Id resultJobId;
        System.runAs(TestRunner){
        	resultJobId = WarehouseSyncSchedule.scheduleMorningRun(); 
        }
        
		CronTrigger cronTrigger = [
			SELECT cronExpression, timesTriggered, nextFireTime 
			FROM CronTrigger 
			WHERE id = :resultJobId
		];

		System.assertEquals(0, cronTrigger.timesTriggered);
		String expectedSchedule = '0 0 9 * * ?'; // TestRunner has Berlin TimeZone.
		System.assertEquals(expectedSchedule, cronTrigger.cronExpression);
	}
}
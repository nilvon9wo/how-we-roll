@isTest
private class WarehouseSyncScheduleIntTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testExecuteSyncsToWarehouse(){
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
		Test.setMock(HttpCalloutMock.class, new HTTP_TestRestfulCalloutMock(successCode, testBody));
		
		// Act
		Id resultJobId;
        System.runAs(TestRunner){
            Test.startTest();
            {
                WarehouseCalloutService.runWarehouseEquipmentSync();
            }
            Test.stopTest();
        }

		// Assert
		List<Product2> updatedEquipmentList = [
			SELECT name, cost__c, lifespan_months__c, maintenance_cycle__c, current_inventory__c, replacement_part__c
			FROM Product2
			WHERE warehouse_sku__c = : warehouseSku
		];
		System.assertEquals(1, updatedEquipmentList.size());
		
		Product2 updatedEquipment = updatedEquipmentList[0];
		System.assertEquals(name, updatedEquipment.name);
		System.assertEquals(cost, updatedEquipment.cost__c);
		System.assertEquals(lifespan, updatedEquipment.lifespan_months__c);
		System.assertEquals(maintenancePeriod, updatedEquipment.maintenance_cycle__c);
		System.assertEquals(quantity, updatedEquipment.current_inventory__c);
		System.assertEquals(isReplacement, updatedEquipment.replacement_part__c);
	}        
}
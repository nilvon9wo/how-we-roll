@isTest
private class HWR_WarehouseCalloutStrategyTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void onSuccessShouldUpsertRecords(){
		// Arrange
		DB_EquipmentDmlMock equipmentDml = new DB_EquipmentDmlMock(); 
		HWR_WarehouseCalloutStrategy targetClass = new HWR_WarehouseCalloutStrategy('http://test.example.com', equipmentDml); 
		
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
		HttpResponse testResponse = new HttpResponse();
		testResponse.setBody(testBody);
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.onSuccess(testResponse);
            }
            Test.stopTest();
        }

		// Assert  
		List<Product2> updatedEquipmentList = equipmentDml.updatedEquipmentList;
		System.assertEquals(1, updatedEquipmentList.size());
		
		Product2 updatedEquipment = updatedEquipmentList[0];
		System.assertEquals(name, updatedEquipment.name);
		System.assertEquals(warehouseSku, updatedEquipment.warehouse_sku__c);
		System.assertEquals(cost, updatedEquipment.cost__c);
		System.assertEquals(lifespan, updatedEquipment.lifespan_months__c);
		System.assertEquals(maintenancePeriod, updatedEquipment.maintenance_cycle__c);
		System.assertEquals(quantity, updatedEquipment.current_inventory__c);
		System.assertEquals(isReplacement, updatedEquipment.replacement_part__c);
	}
}
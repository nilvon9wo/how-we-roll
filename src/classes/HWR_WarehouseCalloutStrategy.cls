public virtual class HWR_WarehouseCalloutStrategy extends HTTP_RestfulCalloutStrategy {
	DB_EquipmentDml equipmentDml;
	
	public HWR_WarehouseCalloutStrategy(String url, DB_EquipmentDml equipmentDml) {
		super(url);
		this.equipmentDml = equipmentDml;
	}

	public HWR_WarehouseCalloutStrategy(String url) {
		this(url, new DB_EquipmentDml());
	}
	
	public virtual override HttpResponse onSuccess(HttpResponse response) {
		List<Object> receivedEquipmentList = (List<Object>) JSON.deserializeUntyped(response.getBody());
		List<Product2> updatedEquipmentList = new List<Product2>();
		for (Object equipment: receivedEquipmentList) {
			Map<String, Object> equipmentPropertyByNameMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(equipment));
			updatedEquipmentList.add(new Product2(
				replacement_part__c = (Boolean) equipmentPropertyByNameMap.get('replacement'),
				current_inventory__c = (Decimal) equipmentPropertyByNameMap.get('quantity'),
				name = (String) equipmentPropertyByNameMap.get('name'),
				maintenance_cycle__c = (Decimal) equipmentPropertyByNameMap.get('maintenanceperiod'),
				lifespan_months__c = (Decimal) equipmentPropertyByNameMap.get('lifespan'),
				cost__c = (Decimal) equipmentPropertyByNameMap.get('cost'),
				warehouse_sku__c = (String) equipmentPropertyByNameMap.get('sku')
			));
		}

		this.equipmentDml.doUpsertUsingSkuAsExternalKey(updatedEquipmentList);
		return response;
	}     
}
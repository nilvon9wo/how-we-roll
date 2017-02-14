public with sharing class WarehouseCalloutService {
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
	HWR_WarehouseCalloutStrategy warehouseCalloutStrategy;
	
	public WarehouseCalloutService(HWR_WarehouseCalloutStrategy warehouseCalloutStrategy) {
		this.warehouseCalloutStrategy = warehouseCalloutStrategy;
	}

	public WarehouseCalloutService() {
		this(new HWR_WarehouseCalloutStrategy(WAREHOUSE_URL));
	}

    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        (new WarehouseCalloutService()).syncEquipment();
    }
    
    private void syncEquipment() {
    	this.warehouseCalloutStrategy.execute();
    }

}
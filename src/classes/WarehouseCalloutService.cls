public with sharing virtual class WarehouseCalloutService {
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
	HWR_WarehouseCalloutStrategy warehouseCalloutStrategy;
	
	public WarehouseCalloutService(HWR_WarehouseCalloutStrategy warehouseCalloutStrategy) {
		this.warehouseCalloutStrategy = warehouseCalloutStrategy;
	}

	public WarehouseCalloutService() {
		this(new HWR_WarehouseCalloutStrategy(WAREHOUSE_URL));
	}

    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        (new WarehouseCalloutService()).syncEquipment();
    }
    
    public virtual void syncEquipment() {
    	this.warehouseCalloutStrategy.execute();
    }

}
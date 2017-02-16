@isTest
public class HWR_WarehouseCalloutStrategyMock extends HWR_WarehouseCalloutStrategy {
	public Boolean wasSunk {get; private set;}

    public HWR_WarehouseCalloutStrategyMock(String endpoint) {
    	super(endpoint, new DB_EquipmentDml());
    	this.wasSunk = false;
    }

	public virtual override HttpResponse onSuccess(HttpResponse response) {
		this.wasSunk = true;
		return response;
	}
}
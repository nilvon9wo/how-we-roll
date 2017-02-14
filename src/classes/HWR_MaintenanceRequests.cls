public class HWR_MaintenanceRequests {
    private List<Case> maintenanceRequestList;
    private DB_GenericDml genericDml;
    private DB_WorkPartSelector workPartSelector;
 
    public HWR_MaintenanceRequests(
    		List<Case> maintenanceRequestList, 
    		DB_GenericDml genericDml, 
    		DB_WorkPartSelector workPartSelector
    	) {
        this.maintenanceRequestList = maintenanceRequestList;
        this.genericDml = genericDml;
        this.workPartSelector = workPartSelector; 
    } 

    public HWR_MaintenanceRequests(List<Case> maintenanceRequestList) {
        this(maintenanceRequestList, new DB_GenericDml(), new DB_WorkPartSelector());
    } 

/* Automate Maintenance Requests
* (X) When an existing maintenance request of type Repair or Routine Maintenance is Closed, 
* (X) you create a new maintenance request for a future routine checkup.
* (X)This new request is tied to the same vehicle 
* (X) and piece of equipment to be serviced as the original closed service request. 
* (X) This new request's Type should be set as Routine Maintenance. 
* (X) The Subject should not be null 
* (X) and the Report Date field reflects the day the request was created. 
* Another aspect about parts is they all have different lifespans. 
* Therefore, you need to calculate and set the next due date using the maintenance cycle defined on the related work part records. 
* If multiple work parts are used in the maintenance request, choose the shortest maintenance cycle to define the service date.
*/
    public void updateWorkOrders(Map<Id,SObject> oldMaintenanceRequestMap) {
    	List<Work_Part__c> workPartList = workPartSelector.selectByMaintenanceRequestIdWithEquipment(oldMaintenanceRequestMap.keySet());
    	
    	List<Case> newMaintenanceRequestList = new List<Case>();
    	for (Case maintenanceRequest : maintenanceRequestList) {
    		if (maintenanceRequest.isClosed && this.isUpdateRequired(oldMaintenanceRequestMap, maintenanceRequest)) {
	    		newMaintenanceRequestList.add(new Case(
	    			vehicle__c = maintenanceRequest.vehicle__c,
	    			equipment__c = maintenanceRequest.equipment__c,
	    			type = 'Routine Maintenance', 
	    			subject = 'Routine Maintenance for Vehicle ' + maintenanceRequest.vehicle__c,
	    			date_reported__c = Date.today(),
	    			date_due__c = this.selectDueDate(maintenanceRequest, workPartList)
	    		));
    		} 
    	}  
    	genericDml.doInsert(newMaintenanceRequestList);
    }
    
    private Boolean isUpdateRequired(Map<Id,SObject> oldMaintenanceRequestMap, Case newCase) {
    	Case oldCase = (Case) oldMaintenanceRequestMap.get(newCase.id);
    	Set<String> typeNeedsUpdateSet = new Set<String>{'Repair', 'Routine Maintenance'};
    	return typeNeedsUpdateSet.contains(oldCase.type);
    }
    
    private Date selectDueDate(Case maintenanceRequest, List<Work_Part__c> workPartList) {
    	Decimal daysTilMaintenance = 2147483647;
    	for (Work_Part__c workPart : workPartList) {
    		if (
    			workPart.maintenance_request__c == maintenanceRequest.id
    			&& workPart.equipment__c != null
    			&& workPart.equipment__r.maintenance_cycle__c != null
    			&& daysTilMaintenance > workPart.equipment__r.maintenance_cycle__c
    		) {
    			daysTilMaintenance = workPart.equipment__r.maintenance_cycle__c; 
    		}
    	}
    	
    	Date returnDate = Date.today().addDays((Integer) daysTilMaintenance);
    	return (returnDate.year() <= 4000)
    		? returnDate
    		: Date.today().addYears(4000 - Date.today().year());
    }
}
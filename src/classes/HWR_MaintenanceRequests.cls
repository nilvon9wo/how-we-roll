public class HWR_MaintenanceRequests {
    private List<Case> maintenanceRequestList;
    private DB_MaintenanceRequestDao maintenanceRequestDao;
 
    public HWR_MaintenanceRequests(List<Case> maintenanceRequestList, DB_MaintenanceRequestDao maintenanceRequestDao) {
        this.maintenanceRequestList = maintenanceRequestList;
        this.maintenanceRequestDao = maintenanceRequestDao;
    } 

    public HWR_MaintenanceRequests(List<Case> maintenanceRequestList) {
        this(maintenanceRequestList, new DB_MaintenanceRequestDao());
    } 

/*
Automate Maintenance Requests

* When an existing maintenance request of type Repair or Routine Maintenance is Closed, you create a new maintenance request for a future routine checkup.
* This new request is tied to the same vehicle and piece of equipment to be serviced as the original closed service request. 
* This new request's Type should be set as Routine Maintenance. 
* The Subject should not be null and the Report Date field reflects the day the request was created. 
* Another aspect about parts is they all have different lifespans. 
* Therefore, you need to calculate and set the next due date using the maintenance cycle defined on the related work part records. 
* If multiple work parts are used in the maintenance request, choose the shortest maintenance cycle to define the service date.
*/
    public void updateWorkOrders(Map<Id,SObject> oldMaintenanceRequestMap) {
    	List<Case> newMaintenanceRequestList = new List<Case>();
    	for (Case maintenanceRequest : maintenanceRequestList) {
    		Boolean isClosed = maintenanceRequest.type == 'Closed';
    		Boolean isNeedingUpdate = this.checkForUpdate(oldMaintenanceRequestMap, maintenanceRequest);
    		
    		if (isClosed && isNeedingUpdate) {
	    		newMaintenanceRequestList.add(new Case(
	    			type = 'Routine Maintenance', 
	    			subject = 'Routine Maintenance for Vehicle ' + maintenanceRequest.vehicle__c,
	    			date_reported__c = Date.today(),
	    			date_due__c = null // TODO
	    		));
    		} 
    	}
    	maintenanceRequestDao.doInsert(newMaintenanceRequestList);
    }
    
    private Boolean checkForUpdate(Map<Id,SObject> oldMaintenanceRequestMap, Case newCase) {
    	Case oldCase = (Case) oldMaintenanceRequestMap.get(newCase.id);
    	Set<String> typeNeedsUpdateSet = new Set<String>{'Repair', 'Routine Maintenance'};
    	return typeNeedsUpdateSet.contains(oldCase.type);
    }
}
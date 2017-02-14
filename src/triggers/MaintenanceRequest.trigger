trigger MaintenanceRequest on Case (before update, after update) {
    // call MaintenanceRequestHelper.updateWorkOrders  
	fflib_SObjectDomain.triggerHandler(MaintenanceRequestHelper.class);
}
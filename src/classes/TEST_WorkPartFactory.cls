@isTest
public class TEST_WorkPartFactory extends TEST_SObjectFactory {
	private static Map<String, Object> defaultByKeyMap = new Map<String, Object>{
	}; 
	
	public static List<Work_Part__c> createList(Work_Part__c template, Integer quantity, TEST_DummyInsertModeEnum insertMode){
		MockStrategyInterface strategy = new SessionInQuantityStrategy(template, quantity); 
		return (List<Work_Part__c>) TEST_SObjectFactory.createList(strategy, insertMode); 
	}
	
	public static Work_Part__c create(Work_Part__c template, TEST_DummyInsertModeEnum insertMode){
		Integer quantity = 1;
		return createList(template, quantity, insertMode)[0];
	}

	class SessionInQuantityStrategy extends SObjectInQuantityStrategy {
		SessionInQuantityStrategy(SObject template, Integer quantity) {
			super(template, quantity, 'Work_Part__c ', defaultByKeyMap);
		}
	}
	
	public static List<Work_Part__c> createList(
			Work_Part__c template, Integer quantity, List<Product2> equipmentList, TEST_DummyInsertModeEnum insertMode
		){
		MockStrategyInterface strategy = new nWorkPartPerEquipmentStrategy(template, quantity, equipmentList); 
		List<Work_Part__c> workPartList = (List<Work_Part__c>) TEST_SObjectFactory.createList(strategy, insertMode);
		Integer i = 0;
		for (Work_Part__c workPart : workPartList) {
			workPart.equipment__r = equipmentList[i++];
		} 
		return workPartList;
	}	  

	public static List<Work_Part__c> createList(Work_Part__c template, List<Product2> equipmentList, TEST_DummyInsertModeEnum insertMode){
		return createList(template, 1, equipmentList, insertMode); 
	}
 
	class nWorkPartPerEquipmentStrategy extends nSObjectPerRelatedSObjectStrategy {
		nWorkPartPerEquipmentStrategy(SObject template, Integer quantity, List<Product2> equipmentList) { 
			super(template, quantity, 'Work_Part__c ', 'equipment__c', equipmentList, defaultByKeyMap);
		} 
	}
	
}
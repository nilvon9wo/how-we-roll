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
}
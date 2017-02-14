@isTest
public class TEST_EquipmentFactory extends TEST_SObjectFactory {
	private static Map<String, Object> defaultByKeyMap = new Map<String, Object>{
	}; 
	
	public static List<Product2> createList(Product2 template, Integer quantity, TEST_DummyInsertModeEnum insertMode){
		MockStrategyInterface strategy = new SessionInQuantityStrategy(template, quantity); 
		return (List<Product2>) TEST_SObjectFactory.createList(strategy, insertMode); 
	}
	
	public static Product2 create(Product2 template, TEST_DummyInsertModeEnum insertMode){
		Integer quantity = 1;
		return createList(template, quantity, insertMode)[0];
	}

	class SessionInQuantityStrategy extends SObjectInQuantityStrategy {
		SessionInQuantityStrategy(SObject template, Integer quantity) {
			super(template, quantity, 'Product2 ', defaultByKeyMap);
		}
	}
}
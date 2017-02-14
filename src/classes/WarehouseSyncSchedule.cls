global class WarehouseSyncSchedule implements Schedulable {
  // implement scheduled code here
	global void execute(SchedulableContext schedulableContext) {
		WarehouseCalloutService.runWarehouseEquipmentSync();
	}
	
	public static void scheduleMorningRun() {
		Integer pstTargetHour = 1; // 24 hour time
		Integer pstOffset = -8;
		Integer userOffset = UserInfo.getTimeZone().getOffset(Date.today());
		Integer userTime = pstTargetHour - pstOffset + userOffSet; 
		
		String schedule = '0 0 ' + userTime + ' * * ?';
		System.schedule('Warehouse Sync', schedule, new WarehouseSyncSchedule());
	}
}
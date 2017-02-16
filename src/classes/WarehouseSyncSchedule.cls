global class WarehouseSyncSchedule implements Schedulable {

	global void execute(SchedulableContext schedulableContext) {
		WarehouseCalloutService.runWarehouseEquipmentSync();
	}
	
	public static Id scheduleMorningRun() {
		Integer pstTargetHour = 1; // 24 hour time
		Integer pstOffset = -8;
		Integer userOffset = UserInfo.getTimeZone().getOffset(Date.today());
		Integer userTime = Math.mod(pstTargetHour - pstOffset + userOffSet, 24);  
		
		String schedule = '0 0 ' + userTime + ' * * ?';
		return System.schedule('Warehouse Sync', schedule, new WarehouseSyncSchedule());
	}
}
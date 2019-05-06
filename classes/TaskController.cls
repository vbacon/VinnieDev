public class TaskController {
	
	public static Task getTaskData(Id taskId) {
		List<Task> theTasks = [SELECT Id, TaskSubType, WhoId, WhatId, IsVisibleInSelfService, Subject, Description, Status 
		    FROM Task WHERE Id = :taskId];
		
		if (theTasks.size() != 0) {
			return theTasks[0];
		} else {
			return null;
		}
	}
    
}
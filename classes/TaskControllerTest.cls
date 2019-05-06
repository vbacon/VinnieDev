@isTest
public class TaskControllerTest {
	
	static testMethod void testTasks() {
		
	    Account testAccount = new Account(Name = 'Test');
	    insert testAccount;
	        
	    Task testTaskWhat = new Task(WhatId = testAccount.Id, Subject = 'Email: This is an email.', Description = 'Description', TaskSubType = 'Email');
        insert testTaskWhat;

	    Test.StartTest();
	        Task finalTask = TaskController.getTaskData(testTaskWhat.Id);
	    Test.StopTest();

		System.AssertEquals('Email', finalTask.TaskSubType, 'The task\'s subtype should be \'Email\'.');
		System.Assert(finalTask.isVisibleInSelfService, 'The task created should be visible in self service.');
        
	}

}
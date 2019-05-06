@isTest
public class TaskTriggerHandlerTest{

	static testmethod void testTaskTriggerHandler(){
		
	    Account testAccount1 = new Account(Name = 'Test1');
	    insert testAccount1;
	    
	    Account testAccount2 = new Account(Name = 'Test2');
	    insert testAccount2;
	        
	    Task testTask_Email = new Task(WhatId = testAccount1.Id, Subject = 'Email: Subject', 
	    		Description = 'An Email', TaskSubType = 'Email');
        
	    Task testTask_NotAnEmail = new Task(WhatId = testAccount2.Id, Subject = 'Not an Email: Subject', 
	    		Description = 'Not an Email', TaskSubType = 'Email');
                   
	    Test.StartTest();
			insert testTask_Email;
			insert testTask_NotAnEmail;
        Test.StopTest();

		List<Task> finalTasks = new List<Task>([SELECT Id, IsVisibleInSelfService FROM Task]);
		List<Task> finalEmailTasks = new List<Task>([SELECT Id, IsVisibleInSelfService FROM Task WHERE WhatId = :testAccount1.Id]);
		List<Task> finalNonEmailTasks = new List<Task>([SELECT Id, IsVisibleInSelfService FROM Task WHERE WhatId = :testAccount2.Id]);
			
		System.AssertEquals(2, finalTasks.size(), 'There should have been two Tasks created.');
        System.Assert(finalEmailTasks[0].isVisibleInSelfService, 'The task created should be visible in self service.');
        System.Assert(!finalNonEmailTasks[0].isVisibleInSelfService, 'The task created should NOT be visible in self service.');
		
	}
  }
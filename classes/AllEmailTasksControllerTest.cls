@isTest
public class AllEmailTasksControllerTest {
    
    static testMethod void testPage() {
	    Account testAccount = new Account(Name = 'Test');
	    insert testAccount;
	    //Id testAccountId = testAccount.Id;
	        
	    Contact testContact = new Contact(LastName = 'Test', AccountId = testAccount.Id);
	    insert testContact;
	    
	    Task testTaskWhat = new Task(WhatId = testAccount.Id, Subject = 'Email: Subject', 
	    		Description = 'Description', TaskSubType = 'Email');
        insert testTaskWhat;

		Task testTaskWho = new Task(WhoId = testContact.Id, Subject = 'Email: Subject', 
				Description = 'Description', TaskSubType = 'Email');
        insert testTaskWho;
           
	    Test.StartTest();
	        ApexPages.currentPage().getParameters().put('id', String.valueOf(testAccount.Id));
            AllEmailTasksController testPage = new AllEmailTasksController();
            
            testPage.cancel();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        	AllEmailTasksController testPage2 = new AllEmailTasksController(sc);
	    Test.StopTest();

		List<Task> finalTasks = new List<Task>([SELECT Id, IsVisibleInSelfService FROM Task]);
			
		System.AssertEquals(2, finalTasks.size(), 'There should have been two Tasks created.');
        System.Assert(finalTasks[0].isVisibleInSelfService, 'The task created should be visible in self service.');
        System.Assert(finalTasks[1].isVisibleInSelfService, 'The task created should be visible in self service.');
	}
	
}
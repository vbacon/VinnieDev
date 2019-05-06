@isTest
public class SingleEmailViewControllerTest {
    
    static testMethod void testPage() {
	    Account testAccount = new Account(Name = 'Test');
	    insert testAccount;
	        
	    Contact testContact = new Contact(LastName = 'Test', Account=testAccount);
	    insert testContact;
	        
	    Task testTaskWhat = new Task(WhatId = testAccount.Id, Subject = 'Email: Subject', Description = 'Description\nTest\n', TaskSubType = 'Email');
        insert testTaskWhat;

		Task testTaskWho = new Task(WhoId = testContact.Id, Subject = 'Email: Subject', Description = 'Description', TaskSubType = 'Email');
        insert testTaskWho;

		Task testTaskNoDesc = new Task(WhoId = testContact.Id, Subject = 'Email: Subject', TaskSubType = 'Email');
        insert testTaskNoDesc;
        
        List<String> strings = new List<String>();
           
	    Test.StartTest();
	        ApexPages.currentPage().getParameters().put('id', String.valueOf(testTaskWho.Id));
            SingleEmailViewController testPage = new SingleEmailViewController();
            testPage.cancel();

	        ApexPages.currentPage().getParameters().put('id', String.valueOf(testTaskWhat.Id));
            SingleEmailViewController testPage2 = new SingleEmailViewController();
            
            ApexPages.currentPage().getParameters().put('id', null);
            SingleEmailViewController testPage3 = new SingleEmailViewController();
                        
			strings = SingleEmailViewController.modifyDescription('');
            
	    Test.StopTest();

		List<Task> finalTasks = new List<Task>([SELECT Id, Subject, isVisibleInSelfService FROM Task]);
			
		System.AssertEquals(3, finalTasks.size(), 'There should have been three Tasks created.');
	    System.Assert(finalTasks[0].isVisibleInSelfService, 'The task created should be visible in self service.');
	}
	
}
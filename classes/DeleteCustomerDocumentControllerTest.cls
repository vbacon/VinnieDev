@isTest
public class DeleteCustomerDocumentControllerTest {
    
    static testMethod void testPage() {
	    Account testAccount = new Account(Name = 'Test');
	    insert testAccount;
	    
	    Customer_Document__c custDoc = new Customer_Document__c(
	    	Account__c=testAccount.Id,
	    	Name='Test Doc',
	    	Document_Type__c='Annual Report'
	    );
	    insert custDoc;
	    
	    // Oddly it appears one needs to create a ContentVersion object to create a ContentDocument object.
	    ContentVersion contVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.txt',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contVersion;
        
        List<ContentDocument> contentDocs = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocument contentDoc = contentDocs[0];
        
        ContentDocumentLink cdl = new ContentDocumentLink(
			ContentDocumentId = contentDoc.id,
			LinkedEntityId = custDoc.id,
			ShareType = 'V'      			
        );
        insert cdl;
            
	    Test.StartTest();
	        ApexPages.currentPage().getParameters().put('id', String.valueOf(custDoc.id));
            
            ApexPages.StandardController sc = new ApexPages.StandardController(custDoc);
        	DeleteCustomerDocumentController testPage = new DeleteCustomerDocumentController(sc);
            
            testPage.doDelete();
            testPage.goToAccount();
            
	    Test.StopTest();
		
		List<Customer_Document__c> updatedCustomerDocs = new List<Customer_Document__c>([SELECT Id FROM Customer_Document__c]);
		System.assertEquals(0, updatedCustomerDocs.size(), 'There should be no Customer Documents');
		
		List<ContentDocument> updatedContentDocs = new List<ContentDocument>([SELECT Id FROM ContentDocument]);
		System.assertEquals(0, updatedContentDocs.size(), 'There should be no Content Documents');
	    		
		List<ContentDocumentLink> updatedContentDocLinks = new List<ContentDocumentLink>([SELECT Id 
				FROM ContentDocumentLink WHERE LinkedEntityId = :custDoc.id]);
		System.assertEquals(0, updatedContentDocLinks.size(), 'There should be no Content Document Links');
	    
	}
	
}
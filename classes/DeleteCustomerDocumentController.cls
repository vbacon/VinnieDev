public class DeleteCustomerDocumentController {
    
    // Customer_Document__c is the custom object that we link to an Account.  It holds files, aka ContentDocuments.
    // ContentDocument is the Salesforce standard object that is created when you link a file.  It represents the file itself.
	// ContentDocumentLink is another Salesforce standard object.  It links the above two items.
    
    public Customer_Document__c theCustomerDocument {set;get;}
    public List<ContentDocument> theContentDocuments {set;get;}
    public List<ContentDocumentLink> theContentDocumentLinks {set;get;}
    public String errorMessage {set;get;}
    public Id accountId {set;get;}
    public String accountName {set;get;}
    public boolean documentDeleteAttempted {set; get;}
    public boolean errorEncountered {set; get;}
    
    public DeleteCustomerDocumentController(ApexPages.StandardController controller) {
         documentDeleteAttempted = false;
         errorEncountered = false;
             
         List<Customer_Document__c> docs = new List<Customer_Document__c>([SELECT Id, Account__c, Account__r.Name, Name
          	FROM Customer_Document__c
         	WHERE Id = :ApexPages.currentPage().getParameters().get('id')]);
         if (docs.size() != 0) {
         	 theCustomerDocument = docs[0];
         	 accountId = docs[0].Account__c;
         	 accountName = docs[0].Account__r.Name;
             theContentDocumentLinks = getContentDocumentLinkList(docs[0].Id);
             theContentDocuments = getContentDocumentList(theContentDocumentLinks);
         }
    }
    
    // Need to find the ContentDocumentLinks associated with the Customer_Document,
    private List<ContentDocumentLink> getContentDocumentLinkList (Id customerDocumentId) {
    	theContentDocumentLinks = new List<ContentDocumentLink>([SELECT Id, ContentDocumentId, LinkedEntityId
    				FROM ContentDocumentLink
    				WHERE LinkedEntityId = :customerDocumentId]);
    	return theContentDocumentLinks;
    }
        
    // Then get the ContentDocuments themselves from those ContentDocumentLinks
    private List<ContentDocument> getContentDocumentList (List<ContentDocumentLink> theLinks) {
    	Set<Id> contentDocumentIds = new Set<Id>();
    	for (ContentDocumentLink cdl : theLinks) {
    		contentDocumentIds.add(cdl.ContentDocumentId);
    	}
    	
    	List<ContentDocument> theContentDocs = new List<ContentDocument>([SELECT Id, Title, FileExtension, 
    				ContentSize, ContentModifiedDate
    			FROM ContentDocument
    			WHERE Id in :contentDocumentIds]);
    	
    	return theContentDocs;
    }
      
    public PageReference doDelete() {      
        documentDeleteAttempted = true;
        try {
          delete theContentDocumentLinks;
          delete theContentDocuments;
          delete theCustomerDocument;
        } catch(System.Exception ex){
           errorMessage = ex.getMessage();
           errorEncountered = true;
           System.debug('Error message from DeleteCustomDocumentController.cls - ' + errorMessage);
        }
        // REFRESH PageReference pageRef
        return null;
    }   

    public PageReference goToAccount() {      
        
        PageReference pageRef = new PageReference('/' + accountId);
		pageRef.setRedirect(true);
		return pageRef;
    }

}
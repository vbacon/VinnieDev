@isTest
public class ContentDocumentLinkTriggerTest {
	
    @isTest
    public static void firstMethod(){
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv; 
    }
}
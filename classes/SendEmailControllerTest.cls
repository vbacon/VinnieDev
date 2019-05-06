/**
*	@Purpose  : Used to test the functionality of "SendEmailController" class.
**/

@isTest
public class SendEmailControllerTest {
    
    public static final Integer TOTAL_RECORDS = 10 ;
	
   /**
    *	@Purpose - Create records that are used while testing SendEmailController class.
    */
    @TestSetup
    static void createTestData() {
        List<Contact> contactList = new  List<Contact>();
        
        Account account = new Account(Name = 'TestAccount');
        
        INSERT account;
        
        // Insert Customer records
        for(Integer index = 1 ; index <= TOTAL_RECORDS ; index ++){
            contactList.add( new Contact(LastName = 'TestLast',FirstName = 'TestFirst', AccountId = account.Id, Birthdate = System.today(),
                                        Contact_Role__c = 'UBO without control', OtherStreet = '1333 S, Woodland Blvd', OtherCity= 'DeLand', 
                                         OtherState = 'Florida', OtherPostalCode ='32720', Email ='docusigntesting18@gmail.com', 
                                        Social_Security_Number__c = '1123', Passport_Number__c = '5421', Country_of_Issuance__c = 'USA',
                                         Ownership_of_Business__c = 11));
            
        }
        
        INSERT contactList ;
        
        system.assertEquals(contactList.size(), TOTAL_RECORDS) ;  
        
        // Create custom setting data
        DocuSign__c docuSign = new DocuSign__c();
        
        docuSign.ControlPersonTemplateId__c = '2452353';
        docuSign.UBO_Template_Id__c = '5464565';
        docuSign.AuthorizedUserTempalteId__c = '356465';
        docuSign.AccountID__c = '356465';
        docuSign.EndPoint__c = 'www.docusign.com';
        docuSign.IntegratorKey__c = '45556';
        docuSign.PassWord__c = 'testPass';
        docuSign.UserName__c = 'testUser';
        docuSign.UBO_Nested_Template_Id__c = '45434';
        
        INSERT docuSign;
    }
    
    /**
    *@Purpose - Test the functionality of "sendEnvelope()" method.
    */
    public static testmethod void testsendEnvelope(){
        
        Contact contact = [SELECT Id,Email,Contact_Role__c, FirstName, LastName, OtherStreet, OtherCity , OtherState,Birthdate ,OtherPostalCode,
                           Social_Security_Number__c, Passport_Number__c, Country_of_Issuance__c, Control_Person__c
                           FROM Contact LIMIT 1 ];
        
        // Set mock class
        Test.setMock(HttpCalloutMock.class, new SendEmailControllerMockResponseGenerator());
        
        Test.startTest();
        
        SendEmailController.sendEnvelope( contact.Id );
        
        //Update Control_Person__c and Ownership_of_Business__c
        contact.Control_Person__c = True ;
        contact.Ownership_of_Business__c = 2;
        
        UPDATE contact;
        
        SendEmailController.sendEnvelope( contact.Id );
        
        //Update Control_Person__c and OAC_access__c
        contact.Control_Person__c = False ;
        contact.OAC_access__c = 'User';
        
        UPDATE contact;
        
        SendEmailController.sendEnvelope( contact.Id );
        
        //Update  OAC_access__c
        contact.OAC_access__c = '';
        
        UPDATE contact;
        
        SendEmailController.sendEnvelope( contact.Id );
        
        String nullString = '';
        
        SendEmailController.sendEnvelope(nullString);
        
        Test.stopTest();   
    }      
}
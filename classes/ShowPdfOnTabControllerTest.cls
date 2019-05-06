/**
*  @Purpose: This class is used to Check the functionality of "ShowPdfOnTabController" class.
*/
@isTest
public class ShowPdfOnTabControllerTest {
    
   public static final Integer TOTALRECORDS = 1;
   
   /**
   *@description - Create test records.
   */
    @testSetup
    public static void createTestData() {
       
        // Insert Account record.
        Account account = new Account(Name = 'FirstName');
        INSERT account;
        
        
        System.assertEquals( TOTALRECORDS, [SELECT count() FROM Account]);
    }   
    
     /**
     *  @description : Test the functionality of 'ShowPdfOnTabController' class and its methods.
     */
    public static testmethod void testAllMethods(){
        
        List<Account> accountList = new List<Account>();  
        
        // Get account records
        accountList = [SELECT Id
                       FROM Account];
        
        // Create ContentVersion record
        Blob blobBody = Blob.valueOf('Unit Test Attachment Body');
        
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.title = 'pdf';      
        contentVersion.PathOnClient = 'test';           
        contentVersion.VersionData = blobBody;  
        
        INSERT contentVersion;         
        
        // Fetch ContentVersion record
        ContentVersion testContentVersion = [SELECT id, ContentDocumentId 
                                             FROM ContentVersion 
                                             WHERE Id =: contentVersion.Id];
        
        // Create ContentDocumentLink record
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = accountList[0].id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId = testContentVersion.ContentDocumentId;
        
        INSERT contentlink;
        
        Test.startTest();
        
        // Set pageReference of 'CIPScreening' vf page
        PageReference pageReference = Page.CIPScreening;
        Test.setCurrentPage(pageReference);
        
        // Put 'Id' parameter
        ApexPages.currentPage().getParameters().put('Id',accountList[0].Id);
        
        // Create Object of 'ShowPdfOnTabController' class and call its method to testing the functionality of it.
        ApexPAges.StandardController standerdControllerObj = new ApexPages.StandardController(accountList[0]);
        ShowPdfOnTabController showPdfOnTab = new ShowPdfOnTabController();
        
        showPdfOnTab.ShowPDF();
                
        // Update ContentVersion record
        testContentVersion.Title = 'CIPScreening';
        
        UPDATE testContentVersion;
        
        showPdfOnTab.ShowCLPListingPDF();
        
        // Update ContentVersion record
        testContentVersion.Title = 'Web';
        
        UPDATE testContentVersion;
        
        showPdfOnTab.ShowWebstorePDF();
        
        // Update ContentVersion record
        testContentVersion.Title = 'Business';
        
        UPDATE testContentVersion;
        
        showPdfOnTab.ShowBusinessPDF();
        
        // Update ContentVersion record
        testContentVersion.Title = 'Government';
        
        UPDATE testContentVersion;
        
        showPdfOnTab.ShowGovernmentPDF();
        
        // Update ContentVersion record
        testContentVersion.Title = 'Search';
        
        UPDATE testContentVersion;
        
        showPdfOnTab.ShowSearchPDF();
        
        // Update ContentVersion record
        testContentVersion.Title = 'WebsiteandSocial';
        
        UPDATE testContentVersion;
        
        showPdfOnTab.ShowWebsiteSocialPDF();
        
        // Update ContentVersion record
        testContentVersion.Title = 'Background';
        
        UPDATE testContentVersion;
        
        showPdfOnTab.ShowBackgroundPDF();
        
        // Update ContentVersion record
        testContentVersion.Title = 'Financial';
        
        UPDATE testContentVersion;
        
        showPdfOnTab.ShowFinancialPDF();
        
        Test.stopTest();
        
        DELETE contentlink;
    }
}
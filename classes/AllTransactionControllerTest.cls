@isTest
public class AllTransactionControllerTest {
	
    
    @isTest
    public static void function(){
        
        Account acc = new Account(Name='Test');
        insert acc;
        
        OAC_Transactions__c tran = new OAC_Transactions__c(Transaction_Date__c = Date.today(),
                                                       Remarks__c = 'test remark',
                                                       Transaction_Type__c = 'test',
                                                       Amount__c=43,
                                                       To_Account_Name__c = acc.id,
                                                       From_Account_External_Id__c =acc.Id);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        
        
        PageReference pageRef = Page.Transactions;
        pageRef.getParameters().put('id', String.valueOf(acc.Id));
        Test.setCurrentPage(pageRef);
        
        AllTransactionsController transactions = new AllTransactionsController(sc);
        transactions.cancel();
    }
}
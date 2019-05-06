@isTest
public class AllBankAcctsTransactionsControllerTest {
  
    
    @isTest
    public static void function(){
        
        Account acc = new Account(Name='Test');
        insert acc;
        
        BankAccount__c bnkAcc= new BankAccount__c();
        bnkAcc.Name ='Test';
        bnkAcc.Account__c=acc.id;
        
        insert bnkAcc;
        
        OAC_Transactions__c tran = new OAC_Transactions__c(Transaction_Date__c = Date.today(),
                                                       Remarks__c = 'test remark',
                                                       Transaction_Type__c = 'test',
                                                       Amount__c=43,
                                                       To_Account_Name__c = acc.id,
                                                       From_Account_External_Id__c =acc.Id,
                                                       From_Bank_Account_External_Id__c = bnkAcc.id);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(bnkAcc);
        
        
        PageReference pageRef = Page.Transactions;
        pageRef.getParameters().put('id', String.valueOf(bnkAcc.Id));
        Test.setCurrentPage(pageRef);
        
        AllBankAccountsTransactionsController transactions = new AllBankAccountsTransactionsController(sc);
        transactions.cancel();
    }
}
public class AllBankAccountsTransactionsController {
    public List<OAC_Transactions__c> transactionList{set;get;}
    
    
    public AllBankAccountsTransactionsController(ApexPages.StandardController controller){
        this();
    }
    
    public AllBankAccountsTransactionsController(){
        String accId = ApexPages.currentPage().getParameters().get('id');
        if(accId !=null)
            initializeRecords(accId);
    }
    
    private void initializeRecords(String accId){
        transactionList = [select Transaction_Date__c,Error_Code__c,Remarks__c,Transaction_Type__c,Amount__c,To_Account_Name__c,CreditDebit__c,ExternalId__c,Fee__c,From_Account_External_Id__c,From_Account_Name__c,To_Bank_Account_External_Id__c from OAC_Transactions__c where From_Bank_Account_External_Id__c = :accId order by Transaction_Date__c desc];
    }
    
    public PageReference cancel(){
        String accId = ApexPages.currentPage().getParameters().get('id');
        return new PageReference('/'+accId);
    }
}
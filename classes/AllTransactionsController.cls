public class AllTransactionsController {
    public List<OAC_Transactions__c> transactionList{set;get;}
    
    
    public AllTransactionsController(ApexPages.StandardController controller){
        this();
    }
    
    public AllTransactionsController(){
        String accId = ApexPages.currentPage().getParameters().get('id');
        if(accId !=null)
            initializeRecords(accId);
    }
    
    private void initializeRecords(String accId){
        transactionList = [select Transaction_Date__c,Remarks__c,Transaction_Type__c,Amount__c,To_Account_Name__c from OAC_Transactions__c where From_Account_External_Id__c = :accId];
    }
    
    public PageReference cancel(){
        String accId = ApexPages.currentPage().getParameters().get('id');
        return new PageReference('/'+accId);
    }
}
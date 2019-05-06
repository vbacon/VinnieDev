public class MasterScoreWrapper {
	
    public Model_Indicator_Definitions__c mid;
    public Decimal inheritedValueSum;
    public Decimal residualValueSum;
    public Indicator_Value__c indicator;
    public Integer count;
    
    public MasterScoreWrapper(){
        inheritedValueSum =0;
        residualValueSum=0;
        indicator = new Indicator_Value__c();
        
        count=0;
    }
}
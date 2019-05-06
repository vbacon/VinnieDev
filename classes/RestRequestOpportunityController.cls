public class RestRequestOpportunityController {
public static final String SERVICE_URL;

     static
    {
        //Get Custom Setting for Our EndPoint URL
        RestRequestCustomSetting__c  objRequest = RestRequestCustomSetting__c.getInstance('KycEndPoint'); 
            if(objRequest != null){
                SERVICE_URL = objRequest.EndPoint__c;
            }
    }
    
    // constructor - if autoRun does not work correctly.
    private final Opportunity objOpportunity ;
    public RestRequestOpportunityController (ApexPages.StandardController controller) {
        this.objOpportunity =(Opportunity)controller.getRecord();

    }
    
        // Code we will invoke on page load.
    public PageReference autoRun() {
 
        String theId = ApexPages.currentPage().getParameters().get('id');
 
        if (theId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
        //Get Login User Details
        Map<ID,User> mapUserDetails =new Map<ID,User>();
        for(User objUser : [select id,name,email,profile.name from User where id=:UserInfo.getUserId()]){
            mapUserDetails.put(objUser.id,objUser);
        }
        for (Opportunity objOpportunity:[select id,accountid,name from Opportunity where id =:theId]) {
            // Do all the dirty work we need the code to do
            if(String.isNotBlank(objOpportunity.accountid)){
                makePostCallout(objOpportunity.accountid,mapUserDetails);
            }
        }
       
 
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
 
    }
    
    public static HttpResponse makePostCallout(String account_id,Map<ID,User> mapUserDetails) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // where to get endpoint from?
        request.setEndpoint(SERVICE_URL + '/getDocuments');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Generate a JSON Request
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject();      

        generator.writeStringField('account_id',account_id);   
        generator.writeStringField('user_name', mapUserDetails.get(UserInfo.getUserId()).name);   
        generator.writeStringField('user_email', mapUserDetails.get(UserInfo.getUserId()).email);
        generator.writeStringField('profile_name',mapUserDetails.get(UserInfo.getUserId()).profile.name);  

        generator.writeEndObject();    

        String jsonString = generator.getAsString();
        system.debug('------------jsonString-----------'+jsonString);
        request.setBody(jsonString);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('+++++++Success++++++++'+response.getBody());
        }
        return response;
    }      
    

}
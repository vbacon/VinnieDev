public class RestRequestController {

    private static final String SERVICE_URL = 'https://mowmdsazad.localtunnel.me';
    
    // constructor - if autoRun does not work correctly.
    private final Account account;
    public RestRequestController(ApexPages.StandardController controller) {
        this.account=(Account)controller.getRecord();
    }
    
        // Code we will invoke on page load.
    public PageReference autoRun() {
 
        String theId = ApexPages.currentPage().getParameters().get('id');
 
        if (theId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
 
        for (Account account:[select id, name from Account where id =:theId]) {
            // Do all the dirty work we need the code to do
            makePostCallout(theId);
        }
 
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
 
    }
    
    public static HttpResponse makePostCallout(String sfid) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

// where to get endpoint from?
        request.setEndpoint(SERVICE_URL + '/getDocuments');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"sfid":'+sfid+'}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;
    }      
    

}
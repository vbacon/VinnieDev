@IsTest 
global class RestRequestControllerTestMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
    //Set EndPoint URL
    System.assertEquals('https://mowmdsazad.localtunnel.me/getDocuments', req.getEndpoint());
    //Set Http Method
    System.assertEquals('POST', req.getMethod());
    HttpResponse res = new HttpResponse();
    //Set Header for Mock Data
    res.setHeader('Content-Type', 'application/json;charset=UTF-8');
    //Set Mock Data
    string fakeResp='{"status":1}';
   
    res.setBody(fakeResp);
    return res;
    }
}
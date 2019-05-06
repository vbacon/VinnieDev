/*
*	@Description  : Used to create fake response to http request for DocuSing.
*/
global class SendEmailControllerMockResponseGenerator implements HttpCalloutMock {
    /*
     *	@Purpose   : Crate fake responce to Http request.
	 *	@Parameter : HTTPRequest [Object]
     */
    global HTTPResponse respond(HTTPRequest httpRequest) {
        //create fake response to Accesstoken
        HttpResponse httpResponse = new HttpResponse();
        
        if( httpRequest.getMethod() == 'POST' ){
          httpResponse.setBody('{\n "envelopeId": "4fd38c86-2ca8-4c07-9413-ea9f102f2ddf",\n"uri": "/envelopes/4fd38c86-2ca8-4c07-9413-ea9f102f2ddf",\n"statusDateTime": "2018-05-28T06:37:08.8174160Z",\n"status": "sent"\n}\n');
            httpResponse.setStatusCode(200);
        }
        
        return httpResponse;
    }   
}
/* 
 * @Purpose : This class is use to send an email to contact using DocuSign templates.
 */
global class SendEmailController {
    
   /* 
    * @Purpose : Use to send an email to Contact.
    */
    @AuraEnabled
    webservice static String sendEnvelope( String contactId ){ 
        
        String responseMessage = 'Email Sent Successfully';
        
        if( String.isNotBlank( contactId ) ){
            
            //Get values from DocuSign__c Custom Setting
            DocuSign__c docuSign = DocuSign__c.getInstance();
            
            if( docuSign != NULL ){
                String contactEmail = '';
                String templateId = '';
                String contactRole = '';
                String json = '';
                String emailBody = '';
                Contact contact;
                
                // Get Contact record 
                try{
                    contact = [SELECT Id,Email,Control_Person__c, FirstName, LastName, OtherStreet, OtherCity , OtherState,Birthdate ,OtherPostalCode,
                               Social_Security_Number__c, Passport_Number__c, Country_of_Issuance__c, Account.Name, Ownership_of_Business__c,
                               Name, OAC_access__c,Nested_Owner__c
                               FROM Contact 
                               WHERE Id = : contactId ];
                }catch(Exception ex){
                    System.debug('Error occured while fetching Contact record' + ex.getMessage());
                }
                
                if( contact != NULL && contact.Email != NULL ){
                    contactEmail = contact.Email;
                    
                    String sourceObjectId = contact.Id + '~Contact';
                    
                    // Call createCustomFieldJSON() method and get CustomFieldJSON.(Used to writeback fields to Salesforce from DocuSing email)
                    String customFieldsJSON = createCustomFieldJSON( sourceObjectId, contact );
                                                
                    // Check if Control_Person__c is 'True' then Set 'ControlPersonTemplate' Template id and send an email 
                    if( contact.Control_Person__c ){
                        
                        templateId = docuSign.ControlPersonTemplateId__c; // Template Id of Control Person Template
                        
                        emailBody = getEmailBody( 'Control Person', contact );                                        
                    }
                    // Check if Nested_Owner__c is True then Set 'UBO_Nested' Template id and send an email
                    else if ( contact.Nested_Owner__c ){
                        
                        templateId = docuSign.UBO_Nested_Template_Id__c; // Template Id of UBO Nested template
                        
                        emailBody = getEmailBody( 'UBO - Nested', contact );
                    }
                    // Check if Ownership_of_Business__c is greater than '10' then Set 'UBO Template' Template id and send an email
                    else if( contact.Ownership_of_Business__c != NULL && contact.Ownership_of_Business__c > 10 ){
                        
                        templateId = docuSign.UBO_Template_Id__c; // Template Id of UBO Template 
                        
                        emailBody = getEmailBody( 'UBO', contact );                    
                    }
                    else if ( contact.OAC_access__c == 'User' ){
                        
                        templateId = docuSign.AuthorizedUserTempalteId__c; // Template Id of Authorized User Template
                        
                        emailBody = getEmailBody( 'AuthorizedUserTemplate', contact );
                    }
    
                    System.debug('Json String--' + json);
                    System.debug('templateId--' + templateId);
                    
                    if( String.isNotEmpty(templateId) ){
                        //Get Input JSON
                        json = getInputJSON( emailBody, templateId, customFieldsJSON, contactEmail, contact.Name );
                        
                        //Credentials retrive from Custom setting are stored in variables 
                        String accountID = docuSign.AccountID__c; 
                        String userName = docuSign.UserName__c;
                        String passWord = docuSign.PassWord__c; 
                        String integratorKey = docuSign.IntegratorKey__c;
                        String endPoint = docuSign.EndPoint__c + accountID +'/envelopes' ;
                        
                        if( String.isBlank(accountID) || String.isBlank(userName) || String.isBlank(passWord) || String.isBlank(integratorKey) ||
                            String.isBlank(endPoint) ){
                               responseMessage = 'Something went wrong, Please check your DocuSign custom setting\'s all field values';
                           }
                        
                        //Apex HTTP Method Initialization. 
                        HttpRequest request = new HttpRequest(); 
                        
                        request.setEndpoint(endPoint); 
                        request.setMethod('POST'); 
                        
                        //Authorization header generating using DocuSign credentials. 
                        String authorizationHeader = '<DocuSignCredentials><Username>'+userName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>'; 
                        request.setHeader('X-DocuSign-Authentication', authorizationHeader); 
                        request.setHeader('Accept','application/json'); 
                        request.setHeader('Content-Length','162100'); 
                        request.setHeader('Content-Type','application/json'); 
                        request.setHeader('Content-Disposition','form-data'); 
         
                        request.setBody(json); 
                        
                        Http http = new Http(); 
                        HTTPResponse response; 
                        
                        try{ 
                            //Docusign Request Callout. 
                            response = http.send(request); 
                            system.debug('DocuSign Response'+ response.getBody());  
                            
                            // Set responseMessage if result contains some error
                            if(response.getBody().contains('errorCode')){
                                responseMessage = 'Error Occured while sending email';
                            }
                        }catch(Exception ex){ 
                            System.debug('Error occured while sending request to Docusign' + ex.getMessage());
                            responseMessage = 'Error Occured while sending email';
                        }     
                    }else{
                        responseMessage = 'Email is not sent because criteria is not matched to send an email.' + '\n\n' +
                                          'One of the following criteria is true for Sending an email :' + '\n' + 
                                          '  1. "Ownership of Business" should be greater than 10 %.'  + '\n' +
                                          '  2. "Control Person" checkbox should be checked.'  + '\n' +
                            			  '  3. "Nested Owner" checkbox should be checked.'  + '\n' +
                                          '  4. "OAC access" value should be equal to User.';
                    }          
                }
                else 
                    if( contact.Email == Null ||  String.isBlank(String.valueOf( contact.Email ))){
                        System.debug('Email is blank');
                        responseMessage = 'Email not sent, because Email address is not found ';
                    }
            } else{
                responseMessage = 'Contact Id not found, Email not sent';
            }
        }
        
        return responseMessage;
    }
    
   /* 
    * @Purpose : Use to create Input JSON.
    */
    @AuraEnabled
    webservice static String getInputJSON( String emailBody, String templateId, String customFieldsJSON, String contactEmail, String contactName ){
        
        String json = ''; 
        
        if( String.isNotBlank(emailBody) 
            && String.isNotBlank(templateId) 
            && String.isNotBlank(customFieldsJSON)
            && String.isNotBlank(contactEmail) 
            && String.isNotBlank(contactName) ){
                
               json = +'{'+
                        '"status": "sent",'+
                        '"emailBlurb": " ' + emailBody + '",'+
                        '"emailSubject": "Information request for Dama application",'+
                        '"templateId": "' + templateId + '",'+ customFieldsJSON +
                             '"templateRoles": ['+
                                +' {'+
                                '"email": " ' + contactEmail + '",'+
                                '"name": " ' + contactName + '",'+
                                '"roleName": "Contact"'+
                                +' }'+
                                +' ]'+
                            +'}';
        }       
        
        return json;
    }
    
   /* 
    * @Purpose : Use to get Email Body based on Template Type.
    */
    @AuraEnabled
    webservice static String getEmailBody( String templateName, Contact contact ){
    
        String emailBody ='';
        
        if( String.isNotBlank(templateName) && contact != NULL){
            
            if( templateName.equals('Control Person') ){
            emailBody = +'Dear ' + contact.Name + ',' + '\n' + '\n' +
                        'You are receiving this email because '+ contact.Account.Name + ' has applied for an Account managed by Dama Financial and identified you '+ 
                        'as a person with significant responsibility, authority or influence over its business. ' + '\n' +
                        'Federal Regulation requires financial institutions to obtain, verify and record information about the beneficial owners of clients.' + '\n' +'\n' +
                        'Please click the ‘Review Document’ button to complete and sign the <b> Information Request and Consent Form.</b> ' + 
                        'We must receive your consent to process ' + contact.Account.Name +'\'s application.' +'\n' +'\n' +
                        'If you have any questions, please contact Dama Client Services at 877-401-3262 or '+
                        '<a href=mailto:clientservices@DamaFinancial.com> clientservices@DamaFinancial.com </a>' +'\n' +'\n' +
                        '©2018 Dama Financial';                    
            } 
            else if( templateName.equals('UBO') ){
               emailBody = +'Dear ' + contact.Name + ',' + '\n' + '\n' +
                            'You are receiving this email because ' + contact.Account.Name +' has applied for an Account managed by Dama Financial and ' +
                            'identified you as an Ultimate Beneficial Owner. Federal ' +
                            'Regulation requires financial institutions to obtain, verify, and record information about the beneficial owners of ' +
                            'clients.' +'\n' + '\n' +
                            'Please click ‘Review Document’ above to review and sign the <b> Information Request and Consent Form.</b> We must'+ 
                            ' receive your consent to process ' + contact.Account.Name +'\'s application.' +'\n' +'\n' +         
                            'If you have any questions, please contact Dama Client Services at 877-401-3262 or' +
                            ' <a href=mailto:clientservices@DamaFinancial.com> clientservices@DamaFinancial.com </a>' +'\n' +'\n' +       
                            '© 2018 Dama Financial ';
            }
            else if( templateName.equals('AuthorizedUserTemplate') ){
                emailBody = +'Dear ' + contact.Name + ',' + '\n' + '\n' +
                            'You are receiving this email because '+ contact.Account.Name + ' has applied for an Account managed by Dama Financial and identified you '+
                            'as an Authorized User of their account. Federal Regulation requires financial institutions to obtain, verify and record'+
                            ' information about clients and authorized users of their account. ' + '\n' + '\n' +
                            'Please click the ‘Review Document’ button to complete and sign the <b>Information Request and Consent Form.</b>' + '\n' + '\n' +
                            'We must receive your consent to process ' + contact.Account.Name +'\'s application.' + '\n' + '\n' +
                            'If you have any questions, please contact Dama Client Services at 877-401-3262 or '+
                            '<a href=mailto:clientservices@DamaFinancial.com> clientservices@DamaFinancial.com </a>' + '\n' + '\n' +
                            '©2018 Dama Financial';
            }
            if( templateName.equals('UBO - Nested') ){
                emailBody = +'Dear ' + contact.Name + ',' + '\n' + '\n' +
                            'You’re receiving this email because you have been identified as an Ultimate Beneficial Owner of '+ contact.Account.Name + '. You may '+
                            'or may not be aware that '+ contact.Account.Name + ' is an Ultimate Beneficial Owner of '+ contact.Account.Name + ' and they have applied for an'+
                            ' Account managed by Dama Financial.  Federal Regulation requires financial institutions to obtain, verify and record information about the beneficial owners of clients.' + '\n' + '\n' +
                            'Please click the ‘Review Document’ button to complete and sign the <b> Information Request and Consent Form.</b> We must receive your consent to process ' + contact.Account.Name +'\'s application.' + '\n' + '\n' +
                            'If you have any questions, please contact Dama Client Services at 877-401-3262 or '+
                            '<a href=mailto:clientservices@DamaFinancial.com> clientservices@DamaFinancial.com </a>' + '\n' + '\n' +
                            '©2018 Dama Financial';                 
            } 
        }
        
        return emailBody;
    }
    
   /* 
    * @Purpose : Use to get CustomFieldJSON.
    */
    @AuraEnabled
    webservice static String createCustomFieldJSON( String sourceObjectId, Contact contact ){
        
        String customFieldsJSON= '';
        
        if( String.isNotBlank(sourceObjectId) && contact != NULL ){
            
                   customFieldsJSON = '"CustomFields": {'+
                                            '"textCustomFields": ['+
                                            + '{'+
                                                '"Name": "DSXPartnerApplication",'+
                                                '"Show": "false",'+
                                                '"Required": "false",'+
                                                '"Value": "DSFS 6.8"'+
                                            +' },'+
                                            + '{'+
                                                '"Name": "PlatformName",'+
                                                '"Show": "false",'+
                                                '"Required": "false",'+
                                                '"Value": "Salesforce"'+
                                            +' },'+
                                            + '{'+
                                                '"Name": "AppName",'+
                                                '"Show": "false",'+
                                                '"Required": "false",'+
                                                '"Value": "DocuSignForSalesforce"'+
                                            +' },'+
                                            + '{'+
                                                '"Name": "DSFSSourceObjectId",'+
                                                '"Show": "false",'+
                                                '"Required": "false",'+
                                                '"Value":"' + sourceObjectId + '"'+ 
                                            +' },'+
                                            + '{'+
                                                '"Name": "##SFAccount",'+
                                                '"Show": "false",'+
                                                '"Required": "false",'+
                                                '"Value":"' + contact.Account.Id + '"'+ 
                                            +' },'+
                                            +' ]'+
                                            +' },';
        }
        
        return customFieldsJSON;
    }
}
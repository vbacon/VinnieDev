/**
*   @Purpose  : Controller class for following pages.
                1.ShowWebstorePDF
                2.ShowBusinessPDF
**/
public class ShowPdfOnTabController {
    Public String contentVersionId { get ; set; }
    
    /*
    *  @Purpose    : Get 'contentVersionId' of 'PDF' pdf file.
    */
    public void ShowPDF(){
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='pdf'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
    
   /*
    *  @Purpose    : Get 'contentVersionId' of 'Webstore' pdf file.
    */
    public void ShowWebstorePDF(){
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='Web'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
    
   /*
    *  @Purpose    : Get 'contentVersionId' of 'Bussiness' pdf file..
    */
    public void ShowBusinessPDF(){
         String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='Business'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
    
    /*
    *  @Purpose    : Get 'contentVersionId' of 'Government' pdf file.
    */
    public void ShowGovernmentPDF(){
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='Government'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
    
   /*
    *  @Purpose    : Get 'contentVersionId' of 'Financial' pdf file.
    */
    public void ShowSearchPDF(){
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='Search'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
    
    
    /*
    *  @Purpose    : Get 'contentVersionId' of 'Website and Social ' pdf file.
    */
    public void ShowWebsiteSocialPDF(){
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='WebsiteandSocial'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
    
    
    
    /*
    *  @Purpose    : Get 'contentVersionId' of 'CLP and Listing ' pdf file.
    */
    public void ShowCLPListingPDF(){
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='CIPScreening'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
    
    
     /*
    *  @Purpose    : Get 'contentVersionId' of 'CLP and Listing ' pdf file.
    */
    public void ShowBackgroundPDF(){
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='Background'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
    
    
    
   /*
    *  @Purpose    : Get 'contentVersionId' of 'Search' pdf file.
    */
    public void ShowFinancialPDF(){
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId :-' + accountId);
        
        if( String.isNotBlank(accountId) ){            
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            
            try{
                contentDocumentLinkList = [SELECT Id, ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = : accountId
                                          ];
            }catch(Exception Ex){
                System.debug('Error occured while fetching ContentDocumentLink record' + ex.getMessage());
            }
            
            System.debug('contentDocumentLinkList :-' + contentDocumentLinkList);
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            
            for( ContentDocumentLink contentDocumentLink : contentDocumentLinkList ){
                contentDocumentIdSet.add(contentDocumentLink.ContentDocumentId);
            }
            
            if( contentDocumentLinkList != NULL && !contentDocumentLinkList.isEmpty() ){    
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                
                try{
                    contentVersionList = [Select Id, ContentUrl, Title 
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN:contentDocumentIdSet AND Title='Financial'];                                         
                }catch(Exception Ex){
                    System.debug('Error occured while fetching ContentVersion record' + ex.getMessage());
                }
                
                System.debug('contentVersionList :-' + contentVersionList);
                
                if( contentVersionList != NULL && !contentVersionList.isEmpty() ){ 
                    contentVersionId =   contentVersionList[0].Id;      
                }
                
                System.debug('contentVersionId :-' + contentVersionId);
            }
        }
    }
}
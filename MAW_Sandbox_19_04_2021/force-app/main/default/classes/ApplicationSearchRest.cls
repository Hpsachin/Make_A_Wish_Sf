@RestResource(urlMapping='/ApplicationSearchRestService/*')
global without sharing class ApplicationSearchRest {
    @HttpPost
    global static void showList(){
        try{
            RestRequest request = RestContext.request;
            String xmlString = request.requestBody.toString();
            if(xmlString != null && String.isNotBlank(xmlString) && String.isNotEmpty(xmlString)){
                ApplicationSearchWrapper applicationSearchWrapperObj = (ApplicationSearchWrapper) JSON.deserialize(xmlString, ApplicationSearchWrapper.class);
                if(applicationSearchWrapperObj != null){
                    List<Case> applicationList = new List<Case>();
                    String queryString;
                    if(applicationSearchWrapperObj.query != null && String.isNotBlank(applicationSearchWrapperObj.query) && String.isNotEmpty(applicationSearchWrapperObj.query) && 
                       applicationSearchWrapperObj.username != null && String.isNotBlank(applicationSearchWrapperObj.username) && String.isNotEmpty(applicationSearchWrapperObj.username) &&
                       applicationSearchWrapperObj.role != null && String.isNotBlank(applicationSearchWrapperObj.role) && String.isNotEmpty(applicationSearchWrapperObj.role)){
                           List<Associated_MP_SW__c> existingAssociatedList = new List<Associated_MP_SW__c>();
                           Set<Id> idSet = new Set<Id>();
                           existingAssociatedList = [SELECT Id, Individual__c, Case__c FROM Associated_MP_SW__c WHERE Associated_Email__c =: applicationSearchWrapperObj.username AND Role__c =: applicationSearchWrapperObj.role LIMIT 10000];
                           
                           for(Associated_MP_SW__c each : existingAssociatedList){
                               idSet.add(each.Case__c);
                           }
                           
                           queryString = '%'+applicationSearchWrapperObj.query+'%';
                           if(applicationSearchWrapperObj.role == 'Medical Specialist' || applicationSearchWrapperObj.role == 'Social Worker'){
                               if(applicationSearchWrapperObj.role == 'Medical Specialist')
                                   applicationList = [SELECT CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, Status, Referral_Relationship_to_Child__c, Associated_Doctors__c, MP_Email__c, SW_Email__c
                                                      FROM Case WHERE CaseNumber LIKE :queryString AND (MP_Email__c =: applicationSearchWrapperObj.username OR Id IN: idSet) AND Form_Completed__c = 100 ORDER BY CaseNumber LIMIT 30000];
                               else if(applicationSearchWrapperObj.role == 'Social Worker')
                                   applicationList = [SELECT CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, Status, Referral_Relationship_to_Child__c, SW_Email__c, Associated_Social_Workers__c, MP_Email__c
                                                      FROM Case WHERE CaseNumber LIKE :queryString AND (SW_Email__c =: applicationSearchWrapperObj.username OR Id IN: idSet) AND Form_Completed__c = 100 ORDER BY CaseNumber LIMIT 30000];
                               if(applicationList.size() > 0){
                                   List<ApplicationListWrapper> applicationListWrapperList = new List<ApplicationListWrapper>();
                                   
                                   for(Case caseObj : applicationList){
                                       ApplicationListWrapper applicationListWrapperObj = new ApplicationListWrapper();
                                       applicationListWrapperObj.Application_Number = caseObj.CaseNumber;
                                       applicationListWrapperObj.Name = caseObj.R_First_Name__c + ' ' + caseObj.R_Surname__c;
                                       applicationListWrapperObj.Email = caseObj.R_Email__c;
                                       applicationListWrapperObj.Status = caseObj.Status;
                                       applicationListWrapperObj.Relationship = caseObj.Referral_Relationship_to_Child__c;
                                       applicationListWrapperList.add(applicationListWrapperObj);
                                   }
                                   if(applicationListWrapperList.size() > 0){
                                       RestContext.response.responseBody = Blob.valueOf('{"Status": "Success", "StatusCode": "200", "Record": '+System.JSON.serialize(applicationListWrapperList)+'}');
                                       RestContext.response.statusCode = 200;
                                   }
                                   else{
                                       RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "No record found for the matching query."}');
                                       RestContext.response.statusCode = 400;                
                                   }
                               }
                               else{
                                   RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "No record found for the matching query."}');
                                   RestContext.response.statusCode = 400;                
                               }
                           }
                           else{
                               RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid role."}');
                               RestContext.response.statusCode = 400;                
                           }
                       }
                    else{
                        if(applicationSearchWrapperObj.query == null || String.isBlank(applicationSearchWrapperObj.query) || String.isEmpty(applicationSearchWrapperObj.query))
                            RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Null or empty query received."}');
                        else
                            RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Null or empty username or role."}');
                        RestContext.response.statusCode = 400;                
                    }
                }
                else{
                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Something went wrong, null or empty data received."}');
                    RestContext.response.statusCode = 400;                
                }
            }
            else{
                RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Something went wrong, null or empty data received."}');
                RestContext.response.statusCode = 400;                
            }
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.addHeader('Access-Control-Allow-Origin','*');
            RestContext.response.addHeader('allowedOriginsPatterns','*');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'GET');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'POST');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'PUT');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'DELETE');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'OPTIONS');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Origin');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Access-Control-Allow-Origin');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Access-Control-Allow-Headers');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Access-Control-Expose-Headers');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Authorization');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Accept');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Content-Type');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'X-Auth-Token');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'X-Requested-With');
        }
        catch(Exception e){
            System.debug('Error Message:: ' + e.getMessage() + 'error line no ' + e.getLineNumber());
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400", "message ":"'+e.getMessage()+e.getLineNumber() +'"}');
        }
    }
    
    public class ApplicationSearchWrapper{
        public String query{get;set;}
        public String role{get;set;}
        public String username{get;set;}
    }
}
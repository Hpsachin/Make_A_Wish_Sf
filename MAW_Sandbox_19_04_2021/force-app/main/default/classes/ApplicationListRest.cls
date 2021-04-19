@RestResource(urlMapping='/ApplicationListRestService/*')
global without sharing class ApplicationListRest {
    
    @HttpPost
    global static void showList(){
        try{
            RestRequest request = RestContext.request;
            String xmlString = request.requestBody.toString();
            if(xmlString != null && String.isNotBlank(xmlString) && String.isNotEmpty(xmlString)){
                Map<String, Object> stringVsEmail = (Map<String, Object>)JSON.deserializeUntyped(xmlString);
                String role = RestContext.request.params.get('role');
                String offsetLimit = RestContext.request.params.get('offsetLimit');
                String dataLimit = RestContext.request.params.get('limit');
                
                if(dataLimit != null && String.isNotBlank(dataLimit) && String.isNotEmpty(dataLimit)){
                    if(Integer.valueOf(dataLimit) <= 50000){
                        List<Case> caseList = new List<Case>();
                        String emailId = String.valueOf(stringVsEmail.get('Email'));
                        Set<Id> idSet = new Set<Id>();
                        List<Associated_MP_SW__c> existingAssociatedList = new List<Associated_MP_SW__c>();
                        
                        if(String.isNotEmpty(role) && String.isNotBlank(role)){
                            if(String.isNotEmpty(offsetLimit) && String.isNotBlank(offsetLimit)){
                                role = role.replace('_', ' ');
                                if(String.isNotEmpty(emailId) && String.isNotBlank(emailId)){
                                    existingAssociatedList = [SELECT Id, Individual__c, Case__c FROM Associated_MP_SW__c WHERE Associated_Email__c =: emailId AND Role__c =: role LIMIT 10000];
                                    
                                    for(Associated_MP_SW__c each : existingAssociatedList){
                                        idSet.add(each.Case__c);
                                    }
                                    
                                    if(role == 'Medical Specialist'){
                                        caseList = [SELECT CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, Status, Referral_Relationship_to_Child__c, Associated_Doctors__c, MP_Email__c, SW_Email__c
                                                    FROM Case WHERE (MP_Email__c =: emailId OR Id IN: idSet) AND Form_Completed__c = 100 ORDER BY CaseNumber ASC 
                                                    LIMIT : Integer.valueOf(dataLimit) OFFSET : Integer.valueOf(offsetLimit)];
                                    }
                                    else if(role == 'Social Worker'){
                                        caseList = [SELECT CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, Status, Referral_Relationship_to_Child__c, SW_Email__c, Associated_Social_Workers__c, MP_Email__c
                                                    FROM Case WHERE (SW_Email__c =: emailId OR Id IN: idSet) AND Form_Completed__c = 100 ORDER BY CaseNumber ASC 
                                                    LIMIT : Integer.valueOf(dataLimit) OFFSET : Integer.valueOf(offsetLimit)];
                                    }
                                    else{
                                        RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400", "Message":"Invalid role."}');
                                        RestContext.response.statusCode = 400;
                                    }
                                    if(caseList.size() > 0){
                                        List<ApplicationListWrapper> dataRecord = new List<ApplicationListWrapper>();
                                        for(Case caseObj : caseList){
                                            ApplicationListWrapper applicationListWrapperObj = new ApplicationListWrapper();
                                            applicationListWrapperObj.Application_Number = caseObj.CaseNumber;
                                            if(caseObj.R_First_Name__c != null && caseObj.R_Surname__c != null)
                                                applicationListWrapperObj.Name = caseObj.R_First_Name__c + ' ' + caseObj.R_Surname__c;
                                            else if(caseObj.R_First_Name__c != null && caseObj.R_Surname__c == null)
                                                applicationListWrapperObj.Name = caseObj.R_First_Name__c;
                                            else if(caseObj.R_First_Name__c == null && caseObj.R_Surname__c != null)
                                                applicationListWrapperObj.Name = caseObj.R_Surname__c;
                                            else
                                                applicationListWrapperObj.Name = '';
                                            applicationListWrapperObj.Email = caseObj.R_Email__c != null ? caseObj.R_Email__c : '';
                                            applicationListWrapperObj.Status = caseObj.Status != null ? caseObj.Status : '';
                                            applicationListWrapperObj.Relationship = caseObj.Referral_Relationship_to_Child__c != null ? caseObj.Referral_Relationship_to_Child__c : '';
                                            dataRecord.add(applicationListWrapperObj);
                                        }
                                        RestContext.response.responseBody = Blob.valueOf('{"Status":"Success", "StatusCode":"200", "Record":'+System.JSON.serialize(dataRecord)+'}');
                                        RestContext.response.statusCode = 200;
                                    }
                                    else{
                                        RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400", "Message":"No application found related to this '+role+'."}');
                                        RestContext.response.statusCode = 400;
                                    }
                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                    RestContext.response.addHeader('Access-Control-Allow-Origin','*');
                                    RestContext.response.addHeader('Access-Control-Allow-Methods', 'GET');
                                    RestContext.response.addHeader('Access-Control-Allow-Methods', 'POST');
                                    RestContext.response.addHeader('Access-Control-Allow-Methods', 'PUT');
                                    RestContext.response.addHeader('Access-Control-Allow-Methods', 'DELETE');
                                    RestContext.response.addHeader('Access-Control-Allow-Methods', 'OPTIONS');
                                    RestContext.response.addHeader('Access-Control-Allow-Headers', 'Origin');
                                    RestContext.response.addHeader('Access-Control-Allow-Headers', 'Access-Control-Allow-Origin');
                                    RestContext.response.addHeader('Access-Control-Allow-Headers', 'Authorization');
                                    RestContext.response.addHeader('Access-Control-Allow-Headers', 'Accept');
                                    RestContext.response.addHeader('Access-Control-Allow-Headers', 'Content-Type');
                                    RestContext.response.addHeader('Access-Control-Allow-Headers', 'X-Auth-Token');
                                    RestContext.response.addHeader('Access-Control-Allow-Headers', 'Access-Control-Allow-Headers');
                                    RestContext.response.addHeader('Access-Control-Allow-Headers', 'X-Requested-With');
                                }
                                else{
                                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Email is empty or blank."}');
                                    RestContext.response.statusCode = 400;
                                }
                            }
                            else{
                                RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"402", "Message":"OffSet limit is not specified."}');
                                RestContext.response.statusCode = 400;
                            } 
                        }
                        else{
                            RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400", "Message":"Role is not specified."}');
                            RestContext.response.statusCode = 400;
                        }
                    }
                    else{
                        RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400", "Message":"Limit cannot be more than 50000."}');
                        RestContext.response.statusCode = 400;
                    }
                }
                else{
                    RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400", "Message":"Limit is not specified."}');
                    RestContext.response.statusCode = 400;
                }
            }
            else{
                RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400", "Message":"Something went wrong, null data received."}');
                RestContext.response.statusCode = 400;
            }
        }
        catch(Exception e){
            System.debug('Error Message:: ' + e.getMessage() + 'error line no ' + e.getLineNumber());
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400", "message ":"'+e.getMessage()+e.getLineNumber() +'"}');
        }
    }
}
@RestResource(urlMapping='/DashboardDetailRestService/*')
global without sharing class DashboardDetailRest {
    @HttpPost
    global static void dashboardDetails(){
        try{
            RestRequest request = RestContext.request;
            String xmlString = request.requestBody.toString();
            if(xmlString != null && String.isNotBlank(xmlString) && String.isNotEmpty(xmlString)){
                LoginFormWrapper loginFormWrapperObj = (LoginFormWrapper) System.JSON.deserialize(xmlString, LoginFormWrapper.class);
                if(loginFormWrapperObj != null){
                    List<Case> caseList = new List<Case>();
                    Set<Id> idSet = new Set<Id>();
                    List<Associated_MP_SW__c> existingAssociatedList = new List<Associated_MP_SW__c>();
                    
                    if(loginFormWrapperObj.username != null && String.isNotBlank(loginFormWrapperObj.username) && String.isNotEmpty(loginFormWrapperObj.username) && loginFormWrapperObj.role != null && String.isNotBlank(loginFormWrapperObj.role) && String.isNotEmpty(loginFormWrapperObj.role)){
                        existingAssociatedList = [SELECT Id, Individual__c, Case__c FROM Associated_MP_SW__c WHERE Associated_Email__c =: loginFormWrapperObj.username AND Role__c =: loginFormWrapperObj.role LIMIT 10000];
                        
                        for(Associated_MP_SW__c each : existingAssociatedList){
                            idSet.add(each.Case__c);
                        }
                        
                        if(loginFormWrapperObj.role == 'Medical Specialist'){
                            caseList = [SELECT CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, Status, Referral_Relationship_to_Child__c, Associated_Doctors__c, SW_Email__c, MP_First_Name__c, MP_Surname__c, MP_Email__c, MP_Phone__c, MP_Hospital__c, MP_Department__c, LastModifiedDate FROM Case WHERE (MP_Email__c =: loginFormWrapperObj.username OR Id IN: idSet) AND Form_Completed__c = 100 AND Status != null AND LastModifiedDate >=: (DateTime.now()).addMonths(-6) ORDER BY LastModifiedDate DESC LIMIT 30000];
                        }
                        else if(loginFormWrapperObj.role == 'Social Worker'){
                            caseList = [SELECT CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, Status, Referral_Relationship_to_Child__c, Associated_Social_Workers__c, MP_Email__c, SW_First_Name__c, SW_Surname__c, SW_Email__c, SW_Phone__c, SW_Hospital__c, LastModifiedDate FROM Case WHERE (SW_Email__c =: loginFormWrapperObj.username OR Id IN: idSet) AND Form_Completed__c = 100 AND Status != null AND LastModifiedDate >=: (DateTime.now()).addMonths(-6) ORDER BY LastModifiedDate DESC LIMIT 30000];
                        }
                        
                        if(caseList.size() > 0 && caseList != null && !caseList.isEmpty()){
                            Integer approved = 0, pending = 0, applied = 0;
                            Map<Date,Integer> sameDateVsNumberApproved = new Map<Date,Integer>();
                            Map<Date,Integer> sameDateVsNumberPending = new Map<Date,Integer>();
                            Map<Date,Integer> sameDateVsNumberApplied = new Map<Date,Integer>();
                            List<DashboardDetailRestWrapper.Data> dataList = new List<DashboardDetailRestWrapper.Data>();
                            
                            for(Case caseObj : caseList){                                
                                if(caseObj.Status == 'Approved'){
                                    approved++;
                                    if(!sameDateVsNumberApproved.containsKey((caseObj.LastModifiedDate).Date())){
                                        sameDateVsNumberApproved.put((caseObj.LastModifiedDate).Date(), 1);
                                    }else{
                                        Integer NumberOfApproved =  sameDateVsNumberApproved.get((caseObj.LastModifiedDate).Date())+1;
                                        sameDateVsNumberApproved.put((caseObj.LastModifiedDate).Date(),NumberOfApproved);
                                    }
                                }
                                else if(caseObj.Status == 'Pending'){
                                    pending++;
                                    if(!sameDateVsNumberPending.containsKey((caseObj.LastModifiedDate).Date())){
                                        sameDateVsNumberPending.put((caseObj.LastModifiedDate).Date(), 1);
                                        
                                    }else{
                                        Integer NumberOfPending = sameDateVsNumberPending.get((caseObj.LastModifiedDate).Date())+1;
                                        sameDateVsNumberPending.put((caseObj.LastModifiedDate).Date(),NumberOfPending);
                                    }
                                }
                                if(!sameDateVsNumberApplied.containsKey((caseObj.LastModifiedDate).Date())){
                                    sameDateVsNumberApplied.put((caseObj.LastModifiedDate).Date(), 1);
                                }
                                else{
                                    Integer NumberOfPending = sameDateVsNumberApplied.get((caseObj.LastModifiedDate).Date())+1;
                                    sameDateVsNumberApplied.put((caseObj.LastModifiedDate).Date(),NumberOfPending);
                                }
                            }
                            
                            for(Date each : sameDateVsNumberApplied.keySet()){
                                DashboardDetailRestWrapper.Data dataObj = new DashboardDetailRestWrapper.Data();
                                if(sameDateVsNumberApplied.containsKey(each))
                                    dataObj.applied = sameDateVsNumberApplied.get(each);
                                else
                                    dataObj.applied = 0;
                                if(sameDateVsNumberApproved.containsKey(each))
                                    dataObj.approved = sameDateVsNumberApproved.get(each);
                                else
                                    dataObj.approved = 0;
                                if(sameDateVsNumberPending.containsKey(each))
                                    dataObj.pending = sameDateVsNumberPending.get(each);
                                else
                                    dataObj.pending = 0;
                                dataObj.dateValue = each;
                                
                                dataObj.month = String.valueOf(each.month());
                                dataList.add(dataObj);
                            }                        
                            applied = caseList.size();
                            
                            List<Contact> newContactList = new List<Contact>();
                            
                            if(loginFormWrapperObj.role == 'Medical Specialist'){
                                newContactList = [SELECT Id, Name, Email, Phone, Hospital__c, Hospital_Department__c FROM Contact WHERE Email =: loginFormWrapperObj.username AND RecordTypeId =: Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId() LIMIT 1];
                                if(newContactList.size() > 0){
                                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Success", "StatusCode": "200", "Profile Details": {"Name": "'+newContactList[0].Name+'", "Email": "'+newContactList[0].Email+'", "Phone": "'+newContactList[0].Phone+'", "Hospital": "'+newContactList[0].Hospital__c+'", "Department": "'+newContactList[0].Hospital_Department__c+'"}, "Approved": "'+approved+'", "Pending": "'+pending+'", "Applied": "'+applied+'", "Data":'+JSON.serializePretty(dataList)+'}');
                                    RestContext.response.statusCode = 200;
                                }
                                else{
                                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid username or role."}');
                                    RestContext.response.statusCode = 400;                                    
                                }
                            }
                            else if(loginFormWrapperObj.role == 'Social Worker'){
                                newContactList = [SELECT Id, Name, Email, Phone, Hospital__c, Hospital_Department__c FROM Contact WHERE Email =: loginFormWrapperObj.username AND RecordTypeId =: Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId() LIMIT 1];
                                if(newContactList.size() > 0){
                                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Success", "StatusCode": "200", "Profile Details": {"Name": "'+newContactList[0].Name+'", "Email": "'+newContactList[0].Email+'", "Phone": "'+newContactList[0].Phone+'", "Hospital": "'+newContactList[0].Hospital__c+'", "Department": "Not mentioned."}, "Approved": "'+approved+'", "Pending": "'+pending+'", "Applied": "'+applied+'", "Data":'+JSON.serializePretty(dataList)+'}');
                                    RestContext.response.statusCode = 200;
                                }
                                else{
                                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid username or role."}');
                                    RestContext.response.statusCode = 400;                                    
                                }
                            }
                            
                        }
                        else if(caseList == null || caseList.isEmpty() || caseList.size() == 0){
                            RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "No application found."}');
                            RestContext.response.statusCode = 400;                
                        }
                    }
                    else{
                        RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid username or role."}');
                        RestContext.response.statusCode = 400;                
                    }
                }
                else{
                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Something went wrong, null data received."}');
                    RestContext.response.statusCode = 400;              
                }
            }
            else{
                RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Something went wrong, null data received."}');
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
            System.debug('Exception: '+e.getMessage() +' At Line: '+e.getLineNumber());
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400", "message ":"'+e.getMessage()+e.getLineNumber() +'"}');
        }
    }
}
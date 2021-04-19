@RestResource(urlMapping='/LoginFormRestService/*')
global without sharing class LoginFormRest {
    
    @HttpPost
    global static void verifyLoginDetails(){
        try{
            RestRequest request = RestContext.request;
            String xmlString = request.requestBody.toString();
            LoginFormWrapper loginFormWrapperObj = (LoginFormWrapper) System.JSON.deserialize(xmlString, LoginFormWrapper.class);
            if(loginFormWrapperObj != null){
                List<Contact> contactList = new List<Contact>();
                if(loginFormWrapperObj.OTP != null && String.isNotBlank(loginFormWrapperObj.OTP) && String.isNotEmpty(loginFormWrapperObj.OTP) && loginFormWrapperObj.username != null 
                   && loginFormWrapperObj.username != '' && String.isNotBlank(loginFormWrapperObj.username) && String.isNotEmpty(loginFormWrapperObj.username)){
                       contactList = [SELECT Id FROM Contact WHERE Email =: loginFormWrapperObj.username AND OTP__c =: loginFormWrapperObj.OTP LIMIT 1];
                       if(contactList.size() > 0){
                           RestContext.response.responseBody = Blob.valueOf('{"Status": "Success", "StatusCode": "200", "Message": "OTP matched."}');
                           RestContext.response.statusCode = 200;                                                      
                       }
                       else{
                           RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid OTP."}');
                           RestContext.response.statusCode = 400;                    
                       }  
                   }
                else{
                    Id recordId;
                    if(loginFormWrapperObj.role == 'Medical Specialist')
                        recordId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
                    else if(loginFormWrapperObj.role == 'Social Worker')
                        recordId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
                    if(recordId != null && loginFormWrapperObj.username != null && loginFormWrapperObj.username != '' && String.isNotBlank(loginFormWrapperObj.username) && 
                       String.isNotEmpty(loginFormWrapperObj.username)){
                           contactList = [SELECT Id, Name, Email, Phone, Hospital__c, Hospital_Department__c, Password__c FROM Contact WHERE RecordTypeId =: recordId AND Email =: loginFormWrapperObj.username LIMIT 1];
                           if(contactList.size() > 0 && loginFormWrapperObj.password != null && loginFormWrapperObj.password != '' && String.isNotBlank(loginFormWrapperObj.password) && 
                              String.isNotEmpty(loginFormWrapperObj.password)){
                                  if(contactList[0].Password__c != null && loginFormWrapperObj.password == contactList[0].Password__c){
                                      Contact newContact = new Contact();
                                      newContact.Id = contactList[0].Id;
                                      newContact.OTP__c = AutoGenerateApplicationNumber.uniqueCode();
                                      DateTime dt = DateTime.now();
                                      newContact.OTP_DateTime__c = dt.addMinutes(-58);
                                      update newContact;
                                      
                                      SendEmailClass.sendEmailMethod('Login OTP', contactList[0]);
                                      RestContext.response.responseBody = Blob.valueOf('{"Status": "Success", "StatusCode": "200", "Message": "An email has been sent to your email id with unique one time six digit code. Please enter the code to verify your identity.", "Username": "'+contactList[0].Email+'", "Name": "'+contactList[0].Name+'"}');
                                      RestContext.response.statusCode = 200;
                                  }
                                  else{
                                      RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid password."}');
                                      RestContext.response.statusCode = 400;                           
                                  }
                              }
                           else{
                               RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid username or password."}');
                               RestContext.response.statusCode = 400;                           
                           }
                       }
                    else if(recordId == null){
                        RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Incorrect role."}');
                        RestContext.response.statusCode = 400;                           
                    }
                    else{
                        RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid username."}');
                        RestContext.response.statusCode = 400;                    
                    }
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
    
    @HttpPut
    global static void resetForgotPassword(){
        try{
            RestRequest request = RestContext.request;
            String xmlString = request.requestBody.toString();
            String taskId = RestContext.request.params.get('id');
            LoginFormWrapper loginFormWrapperObj;
            if(xmlString != null && String.isNotBlank(xmlString) && String.isNotEmpty(xmlString))
                loginFormWrapperObj = (LoginFormWrapper) System.JSON.deserialize(xmlString, LoginFormWrapper.class);
            if(loginFormWrapperObj != null && loginFormWrapperObj.username != null && String.isNotBlank(loginFormWrapperObj.username) && String.isNotEmpty(loginFormWrapperObj.username) 
               && loginFormWrapperObj.role != null && String.isNotBlank(loginFormWrapperObj.role) && String.isNotEmpty(loginFormWrapperObj.role)){
                   List<Contact> contactList = new List<Contact>();
                   Id recordId;
                   if(loginFormWrapperObj.role == 'Medical Specialist')
                       recordId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
                   else if(loginFormWrapperObj.role == 'Social Worker')
                       recordId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
                   
                   if(recordId != null){
                       contactList = [SELECT Id, Name, Email, OwnerId, Password__c, RecordTypeId FROM Contact WHERE RecordTypeId =: recordId AND Email =: loginFormWrapperObj.username AND Email != null LIMIT 1];
                       if((loginFormWrapperObj.password == null || String.isBlank(loginFormWrapperObj.password) || String.isEmpty(loginFormWrapperObj.password)) && (taskId == null || String.isBlank(taskId) || String.isEmpty(taskId))){
                           if(contactList.size() > 0){
                               if(contactList[0].Password__c != null){
                                   SendEmailClass.sendEmailMethod('Forget Password', contactList[0]);
                                   RestContext.response.responseBody = Blob.valueOf('{"Status": "Success", "StatusCode": "200", "Message": "An email to reset the password has been sent to your mail id."}');
                                   RestContext.response.statusCode = 200;
                               }
                               else{
                                   RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "No record exists, please signup first."}');
                                   RestContext.response.statusCode = 400;                                   
                               }
                           }
                           else{
                               RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Invalid username."}');
                               RestContext.response.statusCode = 400;                           
                           }
                       }
                       else if((loginFormWrapperObj.password != null && String.isNotBlank(loginFormWrapperObj.password) && String.isNotEmpty(loginFormWrapperObj.password)) && (taskId != null && String.isNotBlank(taskId) && String.isNotEmpty(taskId))){
                           if(contactList.size() > 0){
                               if(contactList[0].Password__c != loginFormWrapperObj.password){
                                   List<Task> taskList = new List<Task>();
                                   taskList = [SELECT Status FROM Task WHERE Id =: taskId AND Status = 'In Progress' LIMIT 1];
                                   if(taskList.size() > 0){
                                       contactList[0].Password__c = loginFormWrapperObj.password;
                                       update contactList;
                                       
                                       Task newTask = new Task();
                                       newTask.Id = taskId;
                                       newTask.Status = 'Completed';
                                       update newTask;
                                       
                                       RestContext.response.responseBody = Blob.valueOf('{"Status": "Success", "StatusCode": "200", "Message": "Your have reset new password successfully."}');
                                       RestContext.response.statusCode = 200;
                                   }
                                   else{
                                       RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Unsuccessfull attempt."}');
                                       RestContext.response.statusCode = 400;  
                                   }
                               }
                               else{
                                   RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "This password is already in use."}');
                                   RestContext.response.statusCode = 400;  
                               }
                           }
                           else{
                               RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "Unsuccessfull attempt."}');
                               RestContext.response.statusCode = 400;                           
                           } 
                       }
                       else{
                           if(loginFormWrapperObj.password == null || String.isBlank(loginFormWrapperObj.password) || String.isEmpty(loginFormWrapperObj.password))
                               RestContext.response.responseBody = Blob.valueOf('{"Status": "Error", "StatusCode": "400", "Message": "Please enter password."}');
                           else if(taskId == null || String.isBlank(taskId) || String.isEmpty(taskId))
                               RestContext.response.responseBody = Blob.valueOf('{"Status": "Error", "StatusCode": "400", "Message": "URL suspected."}');                               
                           RestContext.response.statusCode = 400;
                       }
                   }
                   else{
                       RestContext.response.responseBody = Blob.valueOf('{"Status": "Error", "StatusCode": "400", "Message": "Invalid role."}');
                       RestContext.response.statusCode = 400;
                   }
               }
            else if(taskId != null && loginFormWrapperObj.password == null ){
                List<Task> taskList = new List<Task>();
                taskList = [SELECT Status FROM Task WHERE Id =: taskId LIMIT 1];
                if(taskList.size() > 0){
                    if(taskList[0].Status == 'In Progress'){
                        RestContext.response.responseBody = Blob.valueOf('{"Status": "Success", "StatusCode": "200", "Message": "The URL to reset password is valid."}');
                        RestContext.response.statusCode = 200;
                    }
                    else if(taskList[0].Status == 'Completed'){
                        RestContext.response.responseBody = Blob.valueOf('{"Status": "Error", "StatusCode": "400", "Message": "The URL to reset password is already used."}');
                        RestContext.response.statusCode = 400;
                    }
                }
                else{
                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Error", "StatusCode": "400", "Message": "The URL to reset password is invalid."}');
                    RestContext.response.statusCode = 400;
                }
            }
            else{
                if(loginFormWrapperObj == null)
                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Error", "StatusCode": "400", "Message": "Null data received."}');
                else{
                    if(loginFormWrapperObj.username == null || String.isBlank(loginFormWrapperObj.username) || String.isEmpty(loginFormWrapperObj.username))
                        RestContext.response.responseBody = Blob.valueOf('{"Status": "Error", "StatusCode": "400", "Message": "Please enter username."}');
                    else if(loginFormWrapperObj.role == null || String.isBlank(loginFormWrapperObj.role) || String.isEmpty(loginFormWrapperObj.role))
                        RestContext.response.responseBody = Blob.valueOf('{"Status": "Error", "StatusCode": "400", "Message": "Please select a role."}');
                }
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
@RestResource(urlMapping='/SignupFormRestService/*')
global without sharing class SignupFormRest {
    
    @HttpPost
    global static void saveSignupDetails() {
        try{
            RestRequest request = RestContext.request;
            String xmlString = request.requestBody.toString();
            SignupFormWrapper SignupFormWrapperObj;
            String errorMessage;
            if(xmlString != null && String.isNotBlank(xmlString) && String.isNotEmpty(xmlString))
                SignupFormWrapperObj = (SignupFormWrapper) System.JSON.deserialize(xmlString, SignupFormWrapper.class);
            else
                errorMessage = 'Something went wrong, null data received.';
            List<Contact> newContactList = new List<Contact>();
            Contact newContact = new Contact();
            if(SignupFormWrapperObj != null){
                if(SignupFormWrapperObj.Email != null && SignupFormWrapperObj.Email != '' && String.isNotEmpty(SignupFormWrapperObj.Email) && String.isNotBlank(SignupFormWrapperObj.Email)){
                    if(SignupFormWrapperObj.Role != null){
                        Id contactRecordTypeId;
                        if(SignupFormWrapperObj.Role == 'Medical Specialist')
                            contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
                        else if(SignupFormWrapperObj.Role == 'Social Worker')
                            contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
                        if(contactRecordTypeId != null){
                            newContact.RecordTypeId = contactRecordTypeId;
                            newContactList = [SELECT Id FROM Contact WHERE Email =: SignupFormWrapperObj.Email AND RecordTypeId =: contactRecordTypeId LIMIT 1];
                        }
                        if(newContactList.size() == 0 && contactRecordTypeId != null){
                            if(SignupFormWrapperObj.FirstName != null && String.isNotEmpty(SignupFormWrapperObj.FirstName) && String.isNotBlank(SignupFormWrapperObj.FirstName))
                                newContact.FirstName = SignupFormWrapperObj.FirstName;
                            if(SignupFormWrapperObj.LastName != null && String.isNotEmpty(SignupFormWrapperObj.LastName) && String.isNotBlank(SignupFormWrapperObj.LastName))
                                newContact.LastName = SignupFormWrapperObj.LastName;
                            newContact.Email = SignupFormWrapperObj.Email;
                            if(SignupFormWrapperObj.Password != null && String.isNotEmpty(SignupFormWrapperObj.Password) && String.isNotBlank(SignupFormWrapperObj.Password))
                                newContact.Password__c = SignupFormWrapperObj.Password;
                            if(newContact.LastName != null && newContact.Password__c != null)
                                insert newContact;
                            else{
                                if(newContact.LastName == null)
                                    errorMessage = 'Please enter last name.';
                                else if(newContact.Password__c == null)
                                    errorMessage = 'Please enter password.';
                            }
                        }
                        else{
                            if(contactRecordTypeId == null)
                                errorMessage = 'Invalid role for the profile.';
                            else if(SignupFormWrapperObj.Role == 'Medical Specialist')
                                errorMessage = 'A Medical Specialist with the same email id already exists in our record.';
                            else if(SignupFormWrapperObj.Role == 'Social Worker')
                                errorMessage = 'A Social Worker with the same email id already exists in our record.';
                        }
                    }
                }
                else{
                    errorMessage = 'Invalid email.';
                }
            }
            if(newContact != null && newContact.Id != null){
                RestContext.response.responseBody = Blob.valueOf('{"Status":"Success", "StatusCode":"200", "Message":"Record inserted successfully."}');
                RestContext.response.statusCode = 200;
            }
            else{
                RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400", "Message":"'+errorMessage+'"}');
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
        }catch(Exception e){
            System.debug('Exception: '+e.getMessage() +' At Line: '+e.getLineNumber());
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400", "message ":"'+e.getMessage() +'"}');
        }
    }
}
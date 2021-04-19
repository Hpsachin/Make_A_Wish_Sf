@isTest
public class SignupFormRest_Test {
    @isTest
    static void  saveSignupDetails_Test(){
        try{
            
            Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
            Id contactRecordTypeId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
            Contact cntObj = new Contact();
            cntObj.LastName = 'xyz';
            cntObj.RecordTypeId  = contactRecordTypeId;
            insert cntObj;
            
            Contact cntObj1 = new Contact();
            cntObj1.FirstName = 'Test Sign In';
            cntObj1.LastName = 'Doctor';
            cntObj1.Email = 'iesha@team.humanpixel.com.au';
            cntObj1.RecordTypeId  = contactRecordTypeId1;
            cntObj1.Password__c = 'sfdc1234';
            insert cntObj1;
            
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.addHeader('httpMethod', 'POST');
            req.requestUri = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/SignupFormRestService/';
            req.requestBody = Blob.valueof('{"FirstName":"Test Sign In","LastName":"Doctor","Email":"iesha@team.humanpixel.com.au","Role":"Social Worker","Password":"sfdc1234"}');
            RestContext.request = req;
            RestContext.response = res;
            
            Test.startTest();
            SignupFormRest.saveSignupDetails();
            Test.stopTest();
        }
        Catch(Exception ex){
            System.debug('error'+ex.getMessage()+'At Line Number'+ex.getLineNumber());  
        }
    }
    @isTest
    static void  saveSignupDetails2_Test(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('httpMethod', 'POST');
        req.requestUri = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/SignupFormRestService/';
        req.requestBody = Blob.valueof('{"FirstName":"Test Sign In","LastName":"Doctor","Email":"iesha@team.humanpixel.com.au","Role":"Social Worker","Password":"sfdc1234"}');
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        SignupFormRest.saveSignupDetails();
        Test.stopTest();
    }
}
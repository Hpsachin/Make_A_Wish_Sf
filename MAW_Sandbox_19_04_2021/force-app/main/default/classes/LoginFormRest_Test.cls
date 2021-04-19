@isTest
public class LoginFormRest_Test {
    @testSetup static void setup(){
        Id recId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
        
        Contact contactObj = new Contact();
        contactObj.Email = 'Testmail@gmail.com';
        contactObj.LastName = 'Last name';
        contactObj.Phone = '8756675';
        contactObj.Hospital__c = 'Delhi hospital';
        contactObj.Hospital_Department__c = 'xyz';
        contactObj.Password__c = 'test@123';
        contactObj.RecordTypeId = recId;
        insert contactObj;
        
        Contact contactObj1 = new Contact();
        contactObj1.LastName = 'Lastname';
        contactObj1.Email = 'Test@gmail.com';
        contactObj1.Hospital__c = 'Delhi hospital';
        contactObj1.Hospital_Department__c = 'xyz';
        contactObj1.Password__c = 'test123';
        contactObj1.Phone = '875667562';
        insert contactObj1;
        Task newTask = new Task();
        newTask.Status = 'In Progress';
        insert newTask;
        
    }
    @isTest
    static void verifyLoginDetailsTest(){
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id, Name, Email, Phone, Hospital__c, Hospital_Department__c, Password__c FROM Contact LIMIT 1];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"username": "Testmail@gmail.com","role": "Medical Specialist","password": "test@123"}');
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.verifyLoginDetails();
        
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"username": "mail@gmail.com","role": "Medical Specialist","password": "test@123"}');
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.verifyLoginDetails();
        
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"username": "Testmail@gmail.com","role": "Medical Specialist","password": "test123"}');
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.verifyLoginDetails();
        
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"username": "Test@gmail.com","role": "","password": "test123"}');
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.verifyLoginDetails();
        
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"username": "Test@gmail.com","role": "Medical Specialist","password": "test123"}');
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.verifyLoginDetails();
        
    }
    @isTest 
    static void resetForgotPasswordTest(){
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id, Name, Email, Phone, Hospital__c, Hospital_Department__c, Password__c FROM Contact LIMIT 1]; 
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('{"username": "Testmail@gmail.com","role": "Medical Specialist","password": ""}');
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.resetForgotPassword();
        
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('{"username": "Testmail@gmail.com","role": "Medical Specialist","password": "test@123"}');
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.resetForgotPassword();
        
    }
    
    @isTest 
    static void updatePasswordTest(){
        
        Test.startTest();
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id, Name, Email, Phone, Hospital__c, Hospital_Department__c, Password__c FROM Contact LIMIT 1]; 
        Task taskObj = [SELECT Id FROM Task WHERE Status =: 'In Progress' LIMIT 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('{"username": "Testmail@gmail.com","role": "Medical Specialist","password": "test@123"}');
        req.addParameter('id',taskObj.Id );
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.resetForgotPassword();
        Test.stopTest();
    }
    @isTest 
    static void updateTaskTest(){
        Task taskObj = [SELECT Id FROM Task WHERE Status =: 'In Progress' LIMIT 1];
        System.debug('taskObj====>'+taskObj);
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/LoginFormRestService';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('{}');
        req.addParameter('id',taskObj.Id );
        RestContext.request = req;
        RestContext.response = res;
        LoginFormRest.resetForgotPassword();
        Test.stopTest();
    }
}
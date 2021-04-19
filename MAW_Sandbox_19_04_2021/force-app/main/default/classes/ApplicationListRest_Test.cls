@isTest
public  class ApplicationListRest_Test {
    @testSetup static void setup(){
        Id recordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
        Contact doctorContact = new Contact();
        doctorContact.RecordTypeId = recordType;
        doctorContact.LastName = 'Test Doctor';
        doctorContact.Email = 'Testdoctoremail@gmail.com';
       insert doctorContact;
        
        Id recordTypeForChild = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Wish Child').getRecordTypeId();
        Contact childContact = new Contact();
        childContact.RecordTypeId = recordTypeForChild;
        childContact.LastName = 'child contact';
        childContact.Doctor__c = doctorContact.Id;
        insert childContact;
        
        Id recordTypeForPrimaryContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();
        Contact primaryContactContact = new Contact();
        primaryContactContact.RecordTypeId = recordTypeForPrimaryContact;
        primaryContactContact.LastName = 'Primary Contact';
        primaryContactContact.Email = 'TestprimaryContact@gmail.com';
        primaryContactContact.Status__c = 'Pending';
        primaryContactContact.Child__c = childContact.Id;
        primaryContactContact.Application_Number__c = 'MAW-00000013';
        insert  primaryContactContact;
        
        Id recordTypeForSocialWorker = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
        Contact SocialWorkerContact = new Contact();
        SocialWorkerContact.RecordTypeId = recordTypeForSocialWorker;
        SocialWorkerContact.LastName = 'SocialWorker Test';
        SocialWorkerContact.Email = 'TestSocialWorker@gmail.com';
        SocialWorkerContact.Status__c = 'Pending';
        insert  SocialWorkerContact;
        
       
        Contact childContact1 = new Contact();
        childContact1.RecordTypeId = recordTypeForChild;
        childContact1.LastName = 'child1';
        childContact1.Social_Worker__c = SocialWorkerContact.Id;
        insert childContact1;

		Contact primaryContactContact2 = new Contact();
        primaryContactContact2.RecordTypeId = recordTypeForPrimaryContact;
        primaryContactContact2.LastName = 'Primary Contact1';
        primaryContactContact2.Email = 'TestprimaryConta+2ct@gmail.com';
        primaryContactContact2.Status__c = 'Approved';
        primaryContactContact2.Child__c = childContact1.Id;
        primaryContactContact2.Application_Number__c = 'MAW-00000015';
        insert  primaryContactContact2;        
        
    }
    @isTest
    static void showList_Test(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Email": "Testdoctoremail@gmail.com"}');
        req.addParameter('role', 'Medical_Specialist');
        req.addParameter('offsetLimit', '0');
        req.requestURI = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/ApplicationListRestService';
        RestContext.request = req;
        RestContext.response = res;
        ApplicationListRest.showList();
        Test.stopTest();
        
    }
    @isTest
    static void showList1_Test(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Email": "TestSocialWorker@gmail.com"}');
        req.addParameter('role', 'Social_Worker');
        req.addParameter('offsetLimit', '0');
        req.requestURI = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/ApplicationListRestService';
        RestContext.request = req;
        RestContext.response = res;
        ApplicationListRest.showList();
        Test.stopTest();
        
    }
    @isTest
    static void showList2_Test(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Email": "Testdoctoremail@gmail.com"}');
        req.addParameter('role', 'Medical_Specialist');
        req.addParameter('offsetLimit', '');
        req.requestURI = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/ApplicationListRestService';
        RestContext.request = req;
        RestContext.response = res;
        ApplicationListRest.showList();
        Test.stopTest();
        
    }
    
    @isTest
    static void showList3_Test(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Email": "Testdoctoremail@gmail.com"}');
        req.addParameter('role', '');
        req.addParameter('offsetLimit', '0');
        req.requestURI = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/ApplicationListRestService';
        RestContext.request = req;
        RestContext.response = res;
        ApplicationListRest.showList();
        Test.stopTest();
        
    }
    
    
    @isTest
    static void showList4_Test(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Email": ""}');
        req.addParameter('role', 'Medical_Specialist');
        req.addParameter('offsetLimit', '0');
        req.requestURI = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/ApplicationListRestService';
        RestContext.request = req;
        RestContext.response = res;
        ApplicationListRest.showList();
        Test.stopTest();
        
    }
    
    @isTest
    static void showList5_Test(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Email": "Testdoctoremail@gmail.com"}');
        req.addParameter('role', 'Medical_Specialisdsfdsft');
        req.addParameter('offsetLimit', '0');
        req.requestURI = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/ApplicationListRestService';
        RestContext.request = req;
        RestContext.response = res;
        ApplicationListRest.showList();
        Test.stopTest();
        
    }
    
    @isTest
    static void showList6_Test(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Email": "Testdoctoremail@gmail.com"}');
        req.addParameter('role', 'Medical_Specialist');
        req.addParameter('offsetLimit', '1');
        req.requestURI = 'https://makeawishau--humanpixel.my.salesforce.com/services/apexrest/ApplicationListRestService';
        RestContext.request = req;
        RestContext.response = res;
        ApplicationListRest.showList();
        Test.stopTest();
        
    }

}
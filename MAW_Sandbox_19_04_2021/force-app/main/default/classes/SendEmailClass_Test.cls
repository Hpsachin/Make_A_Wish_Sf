@isTest
public class SendEmailClass_Test {
    @testSetup static void setup(){
        Id recordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
        Contact doctorContact = new Contact();
        doctorContact.RecordTypeId = recordType;
        doctorContact.LastName = 'Test Doctor';
        doctorContact.Email = 'Testdoctoremail@gmail.com';
        insert doctorContact;
        
        Id recordTypeForSocialWorker = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
        Contact SocialWorkerContact = new Contact();
        SocialWorkerContact.RecordTypeId = recordTypeForSocialWorker;
        SocialWorkerContact.LastName = 'SocialWorker Test';
        SocialWorkerContact.Email = 'TestSocialWorker@gmail.com';
        insert  SocialWorkerContact;
        
    }
    @isTest
    static void sendEmailMethod_Test(){
        Id recordTypeForPrimaryContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
        Contact contactObj = [SELECT Id,Email,OwnerId,Name,RecordTypeId FROM Contact where RecordTypeId =:recordTypeForPrimaryContact LIMIT 1];
        system.debug(contactObj);
        Test.startTest();
        SendEmailClass.sendEmailMethod('Forget Password', contactObj);
        Test.stopTest();
    }
    @isTest
    static void sendEmailMethod1_Test(){
        Id recordTypeForSocialWorker = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
        Contact contactObj = [SELECT Id,Email,OwnerId,Name,RecordTypeId FROM Contact where RecordTypeId =:recordTypeForSocialWorker LIMIT 1];
        system.debug(contactObj);
        Test.startTest();
        SendEmailClass.sendEmailMethod('Forget Password', contactObj);
        Test.stopTest();
    }
    @isTest
    static void sendEmailMethod2_Test(){
        Id recordTypeForSocialWorker = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
        Contact contactObj = [SELECT Id,Email FROM Contact where RecordTypeId =:recordTypeForSocialWorker LIMIT 1];
        system.debug(contactObj);
        Test.startTest();
        SendEmailClass.sendEmailMethod('Forget Password', contactObj);
        Test.stopTest();
    }
    
    @isTest
    static void getEmailTemplate_Test(){
        
        Test.startTest();
        SendEmailClass.getEmailTemplate('Forget Password');
        Test.stopTest();
    }
    @isTest
    static void getEmailTemplate1_Test(){
        
        Test.startTest();
        EmailTemplate emailTemplateObj = SendEmailClass.getEmailTemplate('');
        System.assertEquals(null, emailTemplateObj);
        Test.stopTest();
    }
}
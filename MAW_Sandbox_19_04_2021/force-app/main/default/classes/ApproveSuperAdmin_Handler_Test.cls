@isTest
public class ApproveSuperAdmin_Handler_Test {
    @testSetup static void setup(){
        
        Id recordTypeForPrimaryContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();
        Contact primaryContactContact = new Contact();
        primaryContactContact.RecordTypeId = recordTypeForPrimaryContact;
        primaryContactContact.FirstName = 'first';
        primaryContactContact.LastName = 'Primary';
        primaryContactContact.Email = 'TestprimaryContact@gmail.com';
        primaryContactContact.Status__c = 'Approved';
        primaryContactContact.Application_Form_Completed__c = 100;
        primaryContactContact.Application_Number__c ='MAW-00000044';
        primaryContactContact.Relationship__c = 'Mother';
        insert  primaryContactContact;
        
       /* Contact primaryContactContact1 = new Contact();
        primaryContactContact1.RecordTypeId = recordTypeForPrimaryContact;
        primaryContactContact1.FirstName = 'first';
        primaryContactContact1.LastName = 'Primary';
        primaryContactContact1.Email = 'TestprimaryContact@gmail.com';
        primaryContactContact1.Status__c = 'Approved';
        primaryContactContact1.Application_Form_Completed__c = 100;
        primaryContactContact1.Application_Number__c ='MAW-00000045';
        primaryContactContact1.Relationship__c = 'Mother';
        insert  primaryContactContact1;*/
        
           Id recordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
        Contact doctorContact = new Contact();
        doctorContact.RecordTypeId = recordType;
        doctorContact.LastName = 'Test Doctor';
        doctorContact.Email = 'Testdoctoremail@gmail.com';

        insert doctorContact;
            
        System.debug(primaryContactContact.Application_Number__c);
        Id recordTypeForChild = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Wish Child').getRecordTypeId();
        Contact childContact = new Contact();
        childContact.RecordTypeId = recordTypeForChild;
        childContact.LastName = 'child contact';
        childContact.Primary_Contact__c = primaryContactContact.Id;
        childContact.Fit_for_Wish__c = true;
        childContact.Any_Specification_related_to_Wish__c = 'no such specifications';
        childContact.Any_Specification_related_to_Medical_con__c = 'test feild';
        childContact.Doctor__c = doctorContact.Id;
        insert childContact;
        
         primaryContactContact.Child__c = childContact.Id;
        update primaryContactContact;
    }
    @isTest
    static void getFormDetails_Test(){
        Id recordTypeForPrimaryContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();
        Contact contactObj = [SELECT Id FROM Contact where RecordTypeId =:recordTypeForPrimaryContact LIMIT 1];
        String contactId = contactObj.Id;
        Test.startTest();
        ApproveSuperAdmin_Handler.getFormDetails(contactId);
        Test.stopTest();
    }
     @isTest
    static void getFormDetails1_Test(){
        Id recordTypeForPrimaryContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();
        Contact contactObj = [SELECT Id FROM Contact where RecordTypeId =:recordTypeForPrimaryContact LIMIT 1];
        String contactId = contactObj.Id;
        Contact childContact = [SELECT Id,Fit_for_Wish__c FROM Contact WHERE Fit_for_Wish__c = true LIMIT 1];
        childContact.Fit_for_Wish__c = false;
        update childContact;
        Test.startTest();
        ApproveSuperAdmin_Handler.getFormDetails(contactId);
        Test.stopTest();
    }
 
    @isTest
    static void saveForm_Test(){
        Id recordTypeForPrimaryContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();
        Contact contactObj = [SELECT Id,Status__c FROM Contact where RecordTypeId =:recordTypeForPrimaryContact AND Status__c = 'Approved' LIMIT 1];
        String contactId = contactObj.Id;
        Test.startTest();
         String saveFormObj =  ApproveSuperAdmin_Handler.saveForm(contactId,contactObj.Status__c,'test feild','Yes','no such specifications');
        System.assertEquals('Success', saveFormObj);
        Test.stopTest();
    }
     @isTest
    static void saveForm1_Test(){
        Id recordTypeForPrimaryContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();
        Contact contactObj = [SELECT Id,Status__c FROM Contact where RecordTypeId =:recordTypeForPrimaryContact AND Status__c = 'Approved'  LIMIT 1];
        
        contactObj.Status__c = 'Rejected';
        update contactObj;
        String contactId = contactObj.Id;
        Test.startTest();
        String saveFormObj =  ApproveSuperAdmin_Handler.saveForm(contactId,contactObj.Status__c,'test feild','No','no such specifications');
        System.assertEquals('Success', saveFormObj);
        Test.stopTest();
    }
}
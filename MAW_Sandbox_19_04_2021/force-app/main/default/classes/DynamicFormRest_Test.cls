@isTest
public class DynamicFormRest_Test {
    
    @testSetup static void setup(){
        Contact contactObj = new Contact();        
        Contact contactObj1 = new Contact();
        Contact contactObj2 = new Contact();
        Contact contactObj3 = new Contact();
        contactObj2.LastName = 'contactObj2 Last Name';
        contactObj2.FirstName = 'contactObj2 First Name';
        insert contactObj2;
        
        contactObj3.LastName = 'contactObj3 Last Name';
        contactObj3.FirstName = 'contactObj3 First Name';
        insert contactObj3;
        String strId = contactObj2.Id + ', ' + contactObj3.Id ;
        System.debug(strId);
        
        contactObj.FirstName = 'Test Contact';
        contactObj.LastName = 'Last Name';
        contactObj.Application_Form_Completed__c = 22;
        //contactObj.RecordTypeId = 'Primary Contact';
        contactObj.Email = 'Testmail@gmail.com';
        contactObj.Phone = '124566778';
        
        contactObj.Relationship__c = 'Social Worker';
        contactObj.Application_Number__c = 'MAW-00000056';
        insert contactObj;
        
        contactObj1.FirstName = 'Test Contact1';
        contactObj1.LastName = 'Last Name1';
        contactObj1.Doctor__c = contactObj2.Id;
        contactObj1.Family_Member__c = strId ;
        contactObj1.Social_Worker__c = contactObj3.Id;
        contactObj1.Case_Worker__c = contactObj2.Id;
        contactObj1.Parent_Guardian__c = contactObj2.Id;
        contactObj1.Not_New_Fields__c = 'New Feild';
        contactObj1.Primary_Contact__c = contactObj.Id;
        contactObj1.Application_Form_Completed__c = 20;
        insert contactObj1;
        contactObj.Child__c = contactObj1.Id;
        Update contactObj;
        System.debug(contactObj1);
    }
    
    @isTest
    static void DynamicFormCreation_Test()
    {
        Contact contactQuery =[Select id,Application_Number__c,Child__c From Contact WHERE LastName = 'Last Name' Limit 1];
        System.debug(contactQuery);
        String ApplicationStr = contactQuery.Application_Number__c;
        System.debug('Application No :: '+ApplicationStr);
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://na11.salesforce.com';  // sample Endpoint
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        DynamicFormRest.DynamicFormCreation();
        Test.stopTest();
    }
    @isTest
    static void DynamicFormApplicationNo_Test(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"FirstName" : "Test Contact1","LastName" : "Last Name1","Email" : "Testmail@gmail.com","Phone" : "124566778", "ApplicationNumber": "MAW-00000056"}');
        RestContext.request = req;
        RestContext.response = res;
        DynamicFormRest.DynamicFormApplicationNo();
        Test.stopTest();
        
    }
    @isTest
    static void DynamicFormSaveDetails_Test(){
        Contact contactQuery =[Select id,Application_Number__c,Child__c From Contact WHERE LastName = 'Last Name' Limit 1];
        System.debug('ContactQuery-->>'+ContactQuery);
        String ApplicationStr = contactQuery.Application_Number__c;
        System.debug('Application No :: '+ApplicationStr);
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.addParameter('applicationNo', ApplicationStr);
        req.requestBody = Blob.valueof('{"Mother": [ { "ToScreen": "Second", "title": "First", "innerfield": [ { "value": "Yes", "type": "radio", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Relationship", "field": "Relationship__c", "disabled": false, "cssClass": null } ], "content": "Choose your Relationship to Child?" }, { "ToScreen": "Third", "title": "Second", "innerfield": [ { "value": "12345", "type": "number", "required": true, "recordType": "Primary Contact", "name": "Contact", "label": "Phone", "field": "Phone", "disabled": false, "cssClass": "col-md-5 text-align-right" }, { "value": "1234567890", "type": "number", "required": true, "recordType": "Primary Contact", "name": "Contact", "label": "Mobile", "field": "MobilePhone", "disabled": false, "cssClass": "col-md-5 text-align-left" }, { "value": "iesha@team.humanpixel.com.au", "type": "text", "required": true, "recordType": "Primary Contact", "name": "Contact", "label": "Email", "field": "Email", "disabled": false, "cssClass": "col-md-8 text-align-center" } ], "content": "Please provide us your contact details" }, { "ToScreen": "Fourth", "title": "Third", "innerfield": [ { "value": "Sydney", "type": "text", "required": true, "recordType": "Primary Contact", "name": "Contact", "label": "State", "field": "MailingState", "disabled": false, "cssClass": null }, { "value": "012432", "type": "number", "required": true, "recordType": "Primary Contact", "name": "Contact", "label": "Post Code", "field": "MailingPostalCode", "disabled": false, "cssClass": null }, { "value": "Old Opera House Road", "type": "text", "required": true, "recordType": "Primary Contact", "name": "Contact", "label": "Address", "field": "MailingStreet", "disabled": false, "cssClass": null } ], "content": "Great to meet you Mickail!\r\nWhats your home address?" }, { "ToScreen": "Fifth", "title": "Fourth", "innerfield": [ { "value": "Child", "type": "text", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "First Name", "field": "FirstName", "disabled": false, "cssClass": null }, { "value": "Patel", "type": "text", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Last Name", "field": "LastName", "disabled": false, "cssClass": null } ], "content": "Hey! Please provide us Childs Full Name" }, { "ToScreen": "Sixth", "title": "Fifth", "innerfield": [ { "value": "Male", "type": "picklist", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Gender", "field": "Gender__c", "disabled": false, "cssClass": null } ], "content": "Please select Johns gender" }, { "ToScreen": "Seventh", "title": "Sixth", "innerfield": [ { "value": true, "type": "radio", "required": true, "recordType": "Primary Contact", "name": "Contact", "label": "Child Lives With You", "field": "Child_Lives_With_You__c", "disabled": false, "cssClass": null } ], "content": "Does the child live with you?" }, { "ToScreen": "Eight", "title": "Seventh", "innerfield": [ { "value": "012432", "type": "number", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Childs Post Code", "field": "MailingPostalCode", "disabled": false, "cssClass": null }, { "value": "Sydney", "type": "text", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Childs State", "field": "MailingState", "disabled": false, "cssClass": null }, { "value": "Old Opera House Road", "type": "text", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Childs Address", "field": "MailingStreet", "disabled": false, "cssClass": null } ], "content": "Please fill Johns home address" }, { "ToScreen": "Ninth", "title": "Eight", "innerfield": [ { "value": "Family", "type": "text", "required": true, "recordType": "Family_Members", "name": "Contact", "label": "First Name", "field": "FirstName", "disabled": false, "cssClass": null }, { "value": "Male", "type": "picklist", "required": true, "recordType": "Family_Members", "name": "Contact", "label": "Gender", "field": "Gender__c", "disabled": false, "cssClass": null }, { "value": "2000-02-02", "type": "date", "required": true, "recordType": "Family_Members", "name": "Contact", "label": "Date of Birth", "field": "Birthdate", "disabled": false, "cssClass": null }, { "value": "Brother", "type": "text", "required": true, "recordType": "Family_Members", "name": "Contact", "label": "Relationship with Child", "field": "Relationship_With_Child__c", "disabled": false, "cssClass": null }, { "value": "Patel", "type": "text", "required": true, "recordType": "Family_Members", "name": "Contact", "label": "Last Name", "field": "LastName", "disabled": false, "cssClass": null } ], "content": "Details of all other people residing with John?" }, { "ToScreen": "Tenth", "title": "Ninth", "innerfield": [ { "value": "Dr.", "type": "text", "required": true, "recordType": "Medical_Specialist", "name": "Contact", "label": "Title", "field": "Salutation", "disabled": false, "cssClass": null }, { "value": "Doctor", "type": "text", "required": true, "recordType": "Medical_Specialist", "name": "Contact", "label": "First Name", "field": "FirstName", "disabled": false, "cssClass": null }, { "value": "Singh", "type": "text", "required": true, "recordType": "Medical_Specialist", "name": "Contact", "label": "Last Name", "field": "LastName", "disabled": false, "cssClass": null } ], "content": "Please fill in the full name of Treating Medical Specialist" }, { "ToScreen": "Eleventh", "title": "Tenth", "innerfield": [ { "value": "Vedanta", "type": "text", "required": true, "recordType": "Medical_Specialist", "name": "Contact", "label": "Hospital Name", "field": "Hospital__c", "disabled": false, "cssClass": null } ], "content": "Please fill Hospital name where the specialist treats your child" }, { "ToScreen": "Twelfth", "title": "Eleventh", "innerfield": [ { "value": "Cardiologist", "type": "text", "required": true, "recordType": "Medical_Specialist", "name": "Contact", "label": "Hospital Department Name", "field": "Hospital_Department__c", "disabled": false, "cssClass": null } ], "content": "Please fill in Hospital Department name" }, { "ToScreen": "Thirteen", "title": "Twelfth", "innerfield": [ { "value": "iesha@team.humanpixel.com.au", "type": "text", "required": true, "recordType": "Medical_Specialist", "name": "Contact", "label": "Email", "field": "Email", "disabled": false, "cssClass": null }, { "value": "012432", "type": "number", "required": true, "recordType": "Medical_Specialist", "name": "Contact", "label": "Phone", "field": "Phone", "disabled": false, "cssClass": null } ], "content": "Please fill in the contact details of the Treating Medical Specialist" }, { "ToScreen": "Fourteen", "title": "Thirteen", "innerfield": [ { "value": "Critical", "type": "text", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Child Condition", "field": "Childs_Condition__c", "disabled": false, "cssClass": null } ], "content": "Please fill in the Childs medical condition" }, { "ToScreen": "Fifteen", "title": "Fourteen", "innerfield": [ { "value": true, "type": "picklist", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Is Child Aware?", "field": "Childs_Awareness__c", "disabled": false, "cssClass": null } ], "content": "Is your Child aware that his/her condition is life-threatening?" }, { "ToScreen": "Sixteen", "title": "Fifteen", "innerfield": [ { "value": true, "type": "radio", "required": true, "recordType": "Wish_Child", "name": "Contact", "label": "Can Child communicate verbally?", "field": "Can_your_child_communicate_verbally__c", "disabled": false, "cssClass": null } ], "content": "Can your Child communicate verbally?" }, { "ToScreen": "Seventeen", "title": "Sixteen", "innerfield": null, "content": "What is the primary language spoken in Childs home? (if other than English)" }, { "ToScreen": "Eighteen", "title": "Seventeen", "innerfield": null, "content": "Does your family need an Interpreter?" }, { "ToScreen": "Nineteen", "title": "Eighteen", "innerfield": null, "content": "Please fill in Interpreter details" }, { "ToScreen": "Twenty", "title": "Nineteen", "innerfield": null, "content": "Please fill in the contact details of Cultural Considerations?" }, { "ToScreen": "Twenty One", "title": "Twenty", "innerfield": null, "content": "Is your child of Aboriginal or Torres Strait Islander descent?" }, { "ToScreen": "Twenty Two", "title": "Twenty One", "innerfield": null, "content": "Who referred you to Make-A-Wish?" }, { "ToScreen": "Twenty Three", "title": "Twenty Two", "innerfield": null, "content": "Please fill in the Name of the school or kindergarten?" }, { "ToScreen": "Twenty Four", "title": "Twenty Three", "innerfield": null, "content": "Please fill in the school address?" }, { "ToScreen": "Twenty Five", "title": "Twenty Four", "innerfield": null, "content": "Are you happy for us to contact your Childs school regarding their cherished wish?" }, { "ToScreen": "Twenty Six", "title": "Twenty Five", "innerfield": null, "content": "Does the school know of your childs illness?" }, { "ToScreen": "Twenty Seven", "title": "Twenty Six", "innerfield": null, "content": "Please fill in your comment?" }, { "ToScreen": "Zero", "title": "Twenty Seven", "innerfield": null, "content": "Hey! Please fill in the below details to continue the form" } ]}');
        RestContext.request = req;
        RestContext.response = res;
        DynamicFormRest.DynamicFormSaveDetails();
        Test.stopTest();
    }
    
}
@isTest
public class testVolunteer {
    
    static testMethod void testVolunteerEOItrigger() {
        
        Contact c = new Contact( FirstName = 'first', LastName = 'last', Email = 'mail@email.com', External_Id__c = 'firstlastmail@email.com', Volunteer_App_Status__c = 'Volunteer Application In Progress' );
        insert c;
        
        Test.startTest();
        
        Form__c f = new Form__c( Contact__c = c.Id, Volunteer_Status__c = 'Suitable' );
        insert f;
        
        test.stopTest();
        
    }
    
    static testMethod void testVolunteerApplicationFile() {
        
        Contact c = new Contact( FirstName = 'first', LastName = 'last', Email = 'mail@email.com', External_Id__c = 'firstlastmail@email.com', Volunteer_App_Status__c = 'Volunteer Application In Progress' );
        insert c;
        
        Form__c f = new Form__c( Contact__c = c.Id, Volunteer_Application_Status__c = 'Referee Submitted' );
        insert f;
        
        Test.setCurrentPage(Page.volunteerApplicationFiles);
        System.currentPageReference().getParameters().put('v', f.Id);
        
        Test.startTest();
        
        volunteerApplicationFileController obj = new volunteerApplicationFileController();
        
        String attachmentBody = 'BODYBODYBODY';
        String attachmentName = 'Attachment Name';
        String attachmentId = null;
        
        volunteerApplicationFileController.doUploadAttachment(c.Id, attachmentBody, attachmentName, attachmentId);
        
        obj.confirmFiles();
        
        Test.stopTest();
        
    }
    
    static testMethod void testVolunteerApplicationStage() {

        User u = [SELECT Id FROM User LIMIT 1];
        Contact bc = new Contact( FirstName = 'Vol', LastName = 'Branch', Email = 'vol@branch.com', Community_User_Id__c = u.Id );
        insert bc;
        
        Account vb = new Account( Name = 'Test', Branch_Volunteer_Co_ordinator__c = bc.Id );
        insert vb;
        
        Contact c = new Contact( FirstName = 'first', LastName = 'last', Email = 'mail@email.com', External_Id__c = 'firstlastmail@email.com', Volunteer_App_Status__c = 'Volunteer Application In Progress' );
        insert c;
        
        Form__c f = new Form__c( Contact__c = c.Id, Volunteer_Surname__c = 'Last', Volunteer_Application_Status__c = 'Referee Submitted', Account__c = vb.Id );
        insert f;
        
        Test.setCurrentPage(Page.volunteerApplicationStage);
        System.currentPageReference().getParameters().put('v', f.Id);

        Test.startTest();
        
        volunteerApplicationStageController obj = new volunteerApplicationStageController();

        obj.checkStatus();
        
        obj.wwcc = true;
        obj.ccDate = System.Today();
        obj.ccName = 'Test Person';
        
        obj.submitVolunteerApp();
        
        Test.stopTest();
        
    }

    static testMethod void testVolunteerEOI() {
        
        Test.setCurrentPage(Page.volunteerEOI);
        
        Test.startTest();
        
        volunteerApplicationController obj = new volunteerApplicationController();
            
        obj.getBranches();
        obj.getOffices();
        obj.getStores();
        
        obj.f.Volunteer_First_Name__c = 'First';
        obj.f.Volunteer_Surname__c = 'Last';
        obj.f.Volunteer_Email__c = 'test@mail.com';
        
        obj.submitVolunteerLead();
        
        Test.stopTest();    
            
    }
    
}
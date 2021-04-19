@isTest
public class testWish {
    
    static testMethod void testWishTaskController() {
        
        Wish__c w = new Wish__c();
        insert w;
        
        //create tasks...
        //SELECT Id, Subject, TaskTemplateId__c, Type, ActivityDate, Owner.Name, Status, Description FROM Task WHERE WhatId = :wish.Id ORDER BY Subject, ActivityDate
        
        Task t = new Task(WhatId = w.Id);
        insert t;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(w);
        
        Test.startTest();
        
        wishTaskController obj = new wishTaskController(sc);
        
        obj.getTaskPlanList();
        
        obj.completeTaskId = t.Id;
        
        obj.completeTask();

        Test.stopTest();
        
    }
    
    static testMethod void testWishStarlightController() {
        
        Case c = new Case(Status = 'Awaiting Starlight');
        insert c;
        
        Test.startTest();
      
        wishStarlightController obj = new wishStarlightController();
        
        obj.passwordInput = 'makeawish';
        obj.checkPassword();
        
        obj.caseList[0].Starlight_Response__c = 'Yes';
        
        obj.saveCaseList();
        
        Test.stopTest();
    }
    
    static testMethod void testWishHomeVisitController() {
        
        Wish__c w = new Wish__c();
        insert w;
        
        Home_Visit__c hv = new Home_Visit__c( Wish__c = w.Id );
        insert hv;
        
        Test.setCurrentPage(Page.wishHomeVisit);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(hv);
        
        Test.startTest();
        
        wishHomeVisitController obj = new wishHomeVisitController(sc);
        
        obj.childName = 'Set Value';
        obj.save();
        
        Test.stopTest();
    }
    
    static testMethod void testStatusDisplayController() {
        
        Case c = new Case();
        
        insert c;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        
        statusDisplayController obj = new statusDisplayController(sc);
        
        obj.getStatus();
    }
    
    static testMethod void testWishStatusDisplayController() {
        
        Wish__c w = new Wish__c(Stage__c = 'Application', Stage_Status_Start_Date__c  = System.today().addDays(-10), Status__c = 'Awaiting Consent');
        
        insert w;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(w);
        
        wishStatusDisplayController obj = new wishStatusDisplayController(sc);
        
        obj.getStatus();
        
        Integer daysInStage = obj.statusMap.get('Application').daysInStage;
        
    }

    static testMethod void testWishParticpants() {

        Contact u = new Contact(LastName = 'PotalUser', Email = 'portalUser@mail.com');
        insert u;
        
        Id adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id; 
        Id portalProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User'].Id; 
        
        //Create Users First
        User iUser = new User( LastName = 'Admin', UserName = 'admin@wish.com', Alias = 'admin', ProfileId = adminProfile, Email = 'admin@wish.com', TimeZoneSidKey='Australia/Sydney', LocaleSidKey='en_AU', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert iUser;
        
        User pUser = new User( LastName = 'User', ContactId = u.Id, UserName = 'test@wish.com', Alias = 'vol', ProfileId = portalProfile, Email = 'test@wish.com', TimeZoneSidKey='Australia/Sydney', LocaleSidKey='en_AU', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US' );
        insert pUser;
        
        Wish__c w = new Wish__c();
        
        insert w;
        
        Map<String, Id> wpType = new Map<String, Id>();
        for(RecordType r : [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = 'Wish_Participation__c'])
            wpType.put(r.DeveloperName, r.Id);
        
        //Internal - Lead Designer
        Wish_Participation__c  wp1 = new Wish_Participation__c ( Wish_Name__c = w.Id, RecordTypeId = wpType.get('Internal_Participant'), User__c = iUser.Id, Type__c = 'Lead Designer');
        insert wp1;
        
        //Volunteer - Branch Volunteer Team Leader
        Wish_Participation__c  wp2 = new Wish_Participation__c ( Wish_Name__c = w.Id, RecordTypeId = wpType.get('Volunteer_Participant'), User__c = pUser.Id, Type__c = 'Branch Volunteer Team Leader');
        insert wp2;
        
        Contact c = new Contact( LastName = 'Contact', Email = 'contact@mail.com');
        insert c;
        
        //External - Lead Designer
        Wish_Participation__c  wp3 = new Wish_Participation__c ( Wish_Name__c = w.Id, RecordTypeId = wpType.get('External_Participant'), Name__c = c.Id);
        insert wp3;
        
        
    }
    
    static testMethod void testValidateWishCase() {
        
        Case c = new Case();
        
         //Child
        c.C_First_Name__c = 'Wish';
        c.C_Last_Name__c = 'Child';
        c.C_DOB__c = System.Today().addYears(-5);
        c.C_Address__c = '123 Fake St';
        c.C_City__c = 'Suburb';
        c.C_State__c = 'VIC';
        
        insert c;
        
        Contact cn = new Contact(LastName = 'Child', FirstName = 'Wish', BirthDate = System.Today().addYears(-5) );
        
        insert cn;
        
        pageReference pageRef = Page.validateWishCase;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        
        validateWishCaseController obj = new validateWishCaseController(sc);

    }
    
    static testMethod void testWishConversion() {
        
        Case c = new Case();
        
        //Referer
        c.R_First_Name__c = 'Refer';
        c.R_Surname__c = 'Surname';
        c.R_Email__c = 'email@email.com';
        c.R_Address__c = '123 Fake St';
        c.R_Suburb__c = 'Suburb';
        c.R_State__c = 'VIC';   
        
        //Child
        c.C_First_Name__c = 'Wish';
        c.C_Last_Name__c = 'Child';
        c.C_DOB__c = System.Today().addYears(-5);
        c.C_Address__c = '123 Fake St';
        c.C_City__c = 'Suburb';
        c.C_State__c = 'VIC';
        
        //Parent
        c.PC_First_Name__c = 'Parent';
        c.PC_Surname__c = 'Contact';
        c.PC_Email__c = 'parent@email.com';
        c.PC_Address__c = '123 Fake St';
        c.PC_Suburb__c = 'Suburb';
        c.PC_State__c = 'VIC';    
        
        //Medical
        c.MP_First_Name__c = 'Medical';
        c.MP_Surname__c = 'Person';
        c.MP_Email__c = 'med@email.com';
        c.MP_Hospital__c = 'Hospital';
        c.MP_Postcode__c = '3000';
        c.MP_State__c = 'VIC';   
        
         //Social Worker
        c.SW_First_Name__c = 'Social';
        c.SW_Surname__c = 'Worker';
        c.SW_Email__c = 'sw@email.com';
       
        insert c;
        
        Application_Participant__c ap = new Application_Participant__c();
        
        ap.First_Name__c = 'Application';
        ap.Surname__c  = 'Participant';
        ap.Case__c = c.Id;
        
        insert ap;
        
        WishClass.validateAge(c);
        
        WishClass.checkDuplicate(c);
        
        WishClass.convert(c.Id);
        
    }
    
    static testMethod void testWishApplication() {
        
        wishApplicationController obj = new wishApplicationController();
        
        obj.getRelationships();
        obj.selectedRelationship = 'Social Worker';
        
        obj.checkConsent();
        
        obj.addAppPart();
        
        //Referer
        obj.wishCase.R_First_Name__c = 'Social';
        obj.wishCase.R_Surname__c = 'Worker';
        obj.wishCase.R_Email__c = 'email@email.com';
        obj.wishCase.R_Address__c = '123 Fake St';
        obj.wishCase.R_Suburb__c = 'Suburb';
        obj.wishCase.R_State__c = 'VIC';   
        
        //Child
        obj.wishCase.C_First_Name__c = 'Wish';
        obj.wishCase.C_Last_Name__c = 'Child';
        obj.wishCase.C_DOB__c = System.Today().addYears(-5);
        obj.wishCase.C_Address__c = '123 Fake St';
        obj.wishCase.C_City__c = 'Suburb';
        obj.wishCase.C_State__c = 'VIC';
        
        //Parent
        obj.wishCase.PC_First_Name__c = 'Parent';
        obj.wishCase.PC_Surname__c = 'Contact';
        obj.wishCase.PC_Email__c = 'email@email.com';
        obj.wishCase.PC_Address__c = '123 Fake St';
        obj.wishCase.PC_Suburb__c = 'Suburb';
        obj.wishCase.PC_State__c = 'VIC';    
        
        //Medical
        obj.wishCase.MP_First_Name__c = 'Medical';
        obj.wishCase.MP_Surname__c = 'Person';
        obj.wishCase.MP_Email__c = 'email@email.com';
        obj.wishCase.MP_Hospital__c = 'Hospital';
        obj.wishCase.MP_Postcode__c = '3000';
        obj.wishCase.MP_State__c = 'VIC';   
        
        obj.wishCase.Who_referred_you_to_Make_A_Wish__c = 'Other';
        
        //Submit Initial EOI
        obj.submitWishCase();
        
        //Complete with Consent
        pageReference pageRef = Page.wishApplication;
        Test.setCurrentPageReference(pageRef);
        
        System.currentPageReference().getParameters().put('id', obj.wishCase.Id);

        wishApplicationController objWithConsent = new wishApplicationController();

        objWithConsent.getRelationships();
        objWithConsent.selectedRelationship = 'Father';
        
        objWithConsent.checkConsent();
        
        objWithConsent.submitWishCase();
    }
    
}
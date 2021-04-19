public class volunteerApplicationStageController {
    
    public Form__c eoi {get;set;}
    public Contact c {get;set;}
    public Boolean closeForm { get { return closeForm == null ? false : closeForm; } set; }
    
    public volunteerApplicationStageController() {
        
        eoi = new Form__c();
        
        refOne = new refer();
        refTwo = new refer();
        
        String eoiId = ApexPages.currentPage().getParameters().get('v');
        
        if(eoiId != null) {
            
          
            List<Form__c> fList = new List<Form__c>([SELECT Id, Contact__c, Contact__r.External_Id__c, Volunteer_Application_Status__c, Volunteer_Employment_Status__c,Volunteer_Gender__c,Volunteer_Occupation__c,Volunteer_Position_Title__c,Volunteer_State__c,Volunteer_T_Shirt_Size__c,Volunteer_Title__c, Account__r.Branch_Volunteer_Co_ordinator__c, Account__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c, Contact__r.Volunteer_App_Status__c, Contact__r.WWCC_Number__c, Contact__r.WWCC_Expiry_Date__c, Account__c, Account__r.Name, Volunteer_Address__c,Volunteer_DOB__c,Volunteer_Email__c,Volunteer_Employer__c,Volunteer_First_Name__c,Volunteer_Home_Phone__c,Volunteer_Mobile_Phone__c,Volunteer_Postcode__c,Volunteer_Preferred_Name__c,Volunteer_Status__c,Volunteer_Suburb__c,Volunteer_Surname__c FROm Form__c WHERE Id = :eoiId AND Contact__c != null]);
            
            if(!fList.isEmpty()) {
                
                eoi = fList[0];
                
                if(eoi.Contact__r.Volunteer_App_Status__c != 'Volunteer Application In Progress')
                    closeForm = true;
            }
            
        }
    }
    
    public pageReference checkStatus() {
        
        if(eoi.Volunteer_Application_Status__c == 'Referee Submitted') {
            
            //redirect to docs page
            pageReference pageRef = Page.volunteerApplicationFiles;
            pageRef.setRedirect(true);
            pageRef.getParameters().put('v', eoi.Id);
            
            return pageRef;
            
        } else {
            
            return null;
        }
        
    }

    public refer refOne {get;set;}
    public refer refTwo {get;set;}
    
    public class refer {
        
        public String refName {get;set;}
        public String refNumber {get;set;}
        public String refRelationship {get;set;}                    
        
        public refer() {}
    }
    
    public Boolean wwcc {get;set;}
    public String wwccNumber {get;set;}
    public Date wwccExpiry {get;set;}
    
    public String ccName {get;set;}
    public Date ccDate {get;set;}
    
    public pageReference submitVolunteerApp() {
        
        //update form
        eoi.Volunteer_Application_Status__c = 'Referee Submitted';

        update eoi;
        
        System.Debug('eoi - ' + eoi);
        
        Wish_Triggers__c wt = Wish_Triggers__c.getOrgDefaults();
        
        //create ref tasks
        Task t1 = new Task();
        
        t1.Subject = 'Contact Volunteer Referee ' + refOne.refName;
        t1.ActivityDate = System.today().addDays(14);
        t1.WhatId = eoi.Id;
        t1.WhoId = eoi.Contact__c;
        t1.Description = 'Contact number: ' + refOne.refNumber + '\r\n' + 'Relationship to volunteer: ' + refOne.refRelationship;
       	t1.OwnerId = (wt.Task_Owner__c != null ? t1.OwnerId = wt.Task_Owner__c : eoi.Account__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c);
      
        System.Debug('t1 ' + t1);
        
        insert t1;
        
        Task t2 = new Task();
        
        t2.Subject = 'Contact Volunteer Referee ' + refTwo.refName;
        t2.ActivityDate = System.today().addDays(14);
        t2.WhatId = eoi.Id;
        t2.WhoId = eoi.Contact__c;
        t2.Description = 'Contact number: ' + refTwo.refNumber + '\r\n' + 'Relationship to volunteer: ' + refTwo.refRelationship;
       	t2.OwnerId =  (wt.Task_Owner__c != null ? t2.OwnerId = wt.Task_Owner__c : eoi.Account__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c);
        //eoi.Account__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c;
        
        System.Debug('t2 ' + t2);
        
        insert t2;
        
        Contact updateContact = new Contact();
        
        //copy fields
        updateContact.Salutation = eoi.Volunteer_Title__c;
        updateContact.FirstName = eoi.Volunteer_First_Name__c;
        updateContact.LastName = eoi.Volunteer_Surname__c;
        updateContact.Preferred_Name__c = eoi.Volunteer_Preferred_Name__c;
        updateContact.Birthdate = eoi.Volunteer_DOB__c;
        updateContact.Gender__c = eoi.Volunteer_Gender__c;

        updateContact.Email = eoi.Volunteer_Email__c;
        updateContact.Phone = eoi.Volunteer_Home_Phone__c;
        updateContact.MobilePhone = eoi.Volunteer_Mobile_Phone__c;
        
        updateContact.MailingStreet = eoi.Volunteer_Address__c;
        updateContact.MailingCity = eoi.Volunteer_Suburb__c;
        updateContact.MailingState = eoi.Volunteer_State__c;
        updateContact.MailingPostalCode = eoi.Volunteer_Postcode__c;
        
        updateContact.T_Shirt_Size__c = eoi.Volunteer_t_shirt_size__c;
        
        //apply wwcc
        updateContact.Applied_for_WWCC__c = (wwcc != null ? wwcc : false);
        updateContact.WWCC_Number__c = (wwccNumber != null || wwccNumber != '' ? wwccNumber : eoi.Contact__r.WWCC_Number__c);
        updateContact.WWCC_Expiry_Date__c = (wwccExpiry != null ? wwccExpiry : eoi.Contact__r.WWCC_Expiry_Date__c);
        
        //coc
        updateContact.Accept_Code_of_Conduct__c = ccName;
        updateContact.Accept_Code_of_Conduct_Date__c = ccDate;
        
        //next step
        updateContact.Volunteer_App_Status__c = 'Volunteer Application In Progress';
        
        updateContact.External_Id__c = eoi.Contact__r.External_Id__c;
        
        upsert updateContact External_Id__c;
        
        //redirect to docs page
        pageReference pageRef = Page.volunteerApplicationFiles;
        pageRef.setRedirect(true);
        pageRef.getParameters().put('v', eoi.Id);
        
        return pageRef;
    }
    
}
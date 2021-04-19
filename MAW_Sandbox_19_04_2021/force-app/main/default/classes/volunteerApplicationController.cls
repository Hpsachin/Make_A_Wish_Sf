public class volunteerApplicationController {

    
    public Form__c f {get;set;}
    
    public volunteerApplicationController() {
        
        f = new Form__c();
        
        List<RecordType> rList = new List<RecordType>([SELECT Id FROM RecordType WHERE sObjectType = 'Form__c' AND DeveloperName = 'Volunteer_EOI']);
        
        f.RecordTypeId = !rList.isEmpty() ? rList[0].Id : null;

    }
    
    public List<SelectOption> getBranches () {
        
        List<SelectOption> result = new List<SelectOption>();
        
        for(Account a : [SELECT Id, Name, BillingState FROM Account WHERE Display_on_EOI__c = true AND RecordType.DeveloperName = 'Volunteer_Branch' ORDER BY Name])
        	result.add(new SelectOption(a.Name, a.Name + ', ' + a.BillingState));
        
        return result;
    }
    
    public List<SelectOption> getOffices () {
        
        List<SelectOption> result = new List<SelectOption>();
        
        for(Account a : [SELECT Id, Name, BillingState FROM Account WHERE Display_on_EOI__c = true AND RecordType.DeveloperName = 'Make_A_Wish_Office' ORDER BY Name])
        	result.add(new SelectOption(a.Name, a.Name + ', ' + a.BillingState));
        
        return result;
    }
    
    public List<SelectOption> getStores () {
        
        List<SelectOption> result = new List<SelectOption>();
        
        for(Account a : [SELECT Id, Name, BillingState FROM Account WHERE Display_on_EOI__c = true AND RecordType.DeveloperName = 'Retail_Location' ORDER BY Name])
        	result.add(new SelectOption(a.Name, a.Name + ', ' + a.BillingState));
        
        return result;
    }
    
    public String submitError {get;set;}
    
    public pageReference submitVolunteerLead() {
     
        try {

            List<RecordType> rList = new List<RecordType>([SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact']);
            Id rId = rList.isEmpty() ? null : rList[0].Id;
            
            Contact c = new Contact();
            
            c.RecordTypeId = rId;
            
            c.Salutation = f.Volunteer_Title__c;
            c.FirstName = f.Volunteer_First_Name__c;
            c.LastName = f.Volunteer_Surname__c;
            c.Birthdate = f.Volunteer_DOB__c;
			c.Gender__c = f.Volunteer_Gender__c;
            c.Preferred_Name__c = f.Volunteer_Preferred_Name__c;

            c.Email = f.Volunteer_Email__c;
            c.Phone = f.Volunteer_Home_Phone__c;
            c.MobilePhone = f.Volunteer_Mobile_Phone__c;
            
            c.MailingStreet = f.Volunteer_Address__c;
            c.MailingCity = f.Volunteer_Suburb__c;
            c.MailingState = f.Volunteer_State__c;
            c.MailingPostalCode = f.Volunteer_Postcode__c;
            
            c.Employment_Status__c = f.Volunteer_Employment_Status__c;
            c.Employer__c = f.Volunteer_Employer__c;
            c.Occupation__c = f.Volunteer_Occupation__c;
            c.Position_Title__c = f.Volunteer_Position_Title__c;
            
            c.Language_other_than_English__c = f.Speak_a_language_other_than_English__c;
            c.Language__c = f.Language_other_than_English__c;
            c.Current_drivers_license__c = f.Do_you_have_a_current_drivers_license__c;
            c.Personal_car_available__c = f.Do_you_have_a_personal_car_available__c;
            
            c.Volunteer_Type__c = 'Branch';
            c.Volunteer_App_Status__c = 'Expression of Interest';
            
            c.External_Id__c = c.FirstName + c.LastName + c.Email;
            
           //Associte Account
            f = volunteerClass.eoiSingleOwnership(f);
            
            if(f.Account__c != null) {

                c.AccountId = f.Account__c;
                upsert c External_Id__c;
                
                f.Contact__c = c.Id;
                
            }
            
            f.Volunteer_Status__c = 'Expression of Interest Submitted';
            
            insert f;
            
            pageReference pageRef = Page.volunteerApplicationConfirm;
            pageRef.setRedirect(true);
            pageRef.getParameters().put('id', f.Id);
            
            return pageRef;
            
        } catch(Exception e) {
            
            System.debug('ERROR: ' + e);
            submitError = 'There has been an error submitting your application. ';
            
            return null;
        }
        
        
    }
    
}
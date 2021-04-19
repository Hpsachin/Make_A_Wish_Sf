public class volunteerClass {

    public static void convertEOI(Set<Id> fSet) {
        
        //convert eoi form to volunteer
        //get form details, only convert those without contacts and with accounts.
        //
        List<Form__c> fList = new List<Form__c>([SELECT Id, Volunteer_Address__c,Volunteer_DOB__c,Volunteer_Email__c,Volunteer_Employer__c,
                                                 Volunteer_Employment_Status__c,Volunteer_Occupation__c,Language_other_than_English__c,Volunteer_Gender__c,Volunteer_Position_Title__c,Volunteer_State__c,Volunteer_Title__c,
                                                 Volunteer_First_Name__c,Volunteer_Home_Phone__c,Volunteer_Mobile_Phone__c,
                                                 Volunteer_Postcode__c,Volunteer_Preferred_Name__c,Volunteer_Status__c,
                                                 Volunteer_Suburb__c,Volunteer_Surname__c, Account__c, Contact__c, Speak_a_language_other_than_English__c,
                                                  Do_you_have_a_current_drivers_license__c, Do_you_have_a_personal_car_available__c, Contact__r.External_Id__c,
                                                 Account__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c, How_did_you_hear_about_us__c, Why_do_you_want_to_volunteer__c
                                                 FROM Form__c WHERE Id IN :fSet AND Account__c != null]);
        
        Map<Id, Contact> cMap = new Map<Id, Contact>();
        
        List<Form__c> fUpdates = new List<Form__c>();
        
        //get recordType
        List<RecordType> rList = new List<RecordType>([SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Contact']);
        Id rId = rList.isEmpty() ? null : rList[0].Id;
        
        for(Form__c f : fList) {
        
            if(f.Contact__c == null) {
                //create contact, assgin to account
                Contact c = new Contact();
                
                //c.RecordTypeId = rId;
                
                //c.Salutation = f.Volunteer_Title__c;
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
                
                c.How_did_you_hear_about_us__c = f.How_did_you_hear_about_us__c;
                //c.Interests_and_other_needs__c = f.Interests_and_other_needs__c;
                c.Why_do_you_want_to_volunteer__c = f.Why_do_you_want_to_volunteer__c;
                
                
                c.npsp__Primary_Affiliation__c = f.Account__c;
                c.Volunteer_Type__c = 'Branch';
                c.Volunteer_App_Status__c = 'Application';
                
                c.External_Id__c = c.FirstName + c.LastName + c.Email;
                c.Volunteer_Co_Ordinator__c  = f.Account__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c;
                
                
                cMap.put(f.Id, c);
            
            } else if(f.Volunteer_Status__c != 'Converted') {
                

                Contact c = new Contact();
                
                c.Volunteer_App_Status__c = 'Application';
                c.External_Id__c = f.Contact__r.External_Id__c;
                c.Volunteer_Co_Ordinator__c = f.Account__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c;
                
                cMap.put(f.Id, c);
            }
            
        }
        
        //activate user
        if(!cMap.isEmpty()) {
            
            upsert cMap.values() External_Id__c;
        
            for(Form__c f : fList) {
                
                if(cMap.get(f.Id) != null && cMap.get(f.Id).Id != null) {
                    
                    f.Contact__c = cMap.get(f.Id).Id;
                    f.Volunteer_Status__c = 'Converted';
                    f.Volunteer_Application_Status__c = 'Not Started';
                    
                    fUpdates.add(f);
                }
            }
            
        }
            
        if(!fUpdates.isEmpty())
            update fUpdates;

    }
    
    public static Form__c eoiSingleOwnership(Form__c newRecord) {
        
        List<Form__c> tempList = new List<Form__c>();
        tempList.add(newRecord);
        
        tempList = volunteerClass.eoiOwnership(tempList);
        
        return tempList[0];
    }
    
    public static List<Form__c> eoiOwnership(List<Form__c> newRecords) {
        
        //assign to Branch, Branch Vo Co becomes Owner.
        Map<Id, RecordType> rMap = new Map<Id, RecordType>([SELECT Id, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Form__c' AND DeveloperName = 'Volunteer_EOI']);
        
        Set<String> pSet = new Set<String>();
        
        for(Form__c f : newRecords) {
            
            if(rMap.get(f.RecordTypeId) != null && f.Account__c == null && f.Volunteer_Postcode__c != null) {
                
                pSet.add(f.Volunteer_Postcode__c);
            }
        }
        
        if(!pSet.isEmpty()) {
            
            Map<String, volunteerClass.VolBranch> pMap = new Map<String, volunteerClass.VolBranch>();
            
            for(Branch_Postcode__c bp : [SELECT Id, Postcode__c, Volunteer_Branch__c, Volunteer_Branch__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c FROM Branch_Postcode__c WHERE Postcode__c IN :pSet]) {
                pMap.put(bp.Postcode__c, new volunteerClass.VolBranch(bp));
            }
            
            for(Form__c f : newRecords) {
                
                if(rMap.get(f.RecordTypeId) != null && f.Account__c == null && f.Volunteer_Postcode__c != null) {
                 
                    if(pMap.get(f.Volunteer_Postcode__c) != null) {
                        
                        f.Account__c = pMap.get(f.Volunteer_Postcode__c).AccountId;
                        
                        if(pMap.get(f.Volunteer_Postcode__c).VolunteerId != null)
                            f.OwnerId = pMap.get(f.Volunteer_Postcode__c).VolunteerId;
                    }
                }
            }

        }
        
        return newRecords;
        
        
    }
    
    public class VolBranch {
            
            public Id AccountId {get;set;}
            public Id VolunteerId {get;set;}
            
            public VolBranch(Branch_Postcode__c bp) {
                
                this.AccountId = bp.Volunteer_Branch__c;
                this.VolunteerId = bp.Volunteer_Branch__r.Branch_Volunteer_Co_ordinator__r.Community_User_Id__c;
            }
        }
    
}
global class WishClass {
    
    public static Case validateAge(Case c) {
        
        if(c != null
           && c.C_DOB__c != null) {
               
               Date dob = c.C_DOB__c;
               
               Integer totalDays = dob.daysBetween(System.Today());
               
               Integer Age = (integer)(math.Floor(totalDays/365.2425));
               
               if(Age < 3) {
                   //young, hamper list
                   c.Status = 'Hamper';
                   c.Ineligible_Reason__c = 'Age Under 3';
               } else if(Age >= 18 && Age <=21) {
                   c.Status = 'Starlight Referral';
                   c.Ineligible_Reason__c = 'Age Over 18';
               } else if(Age > 21) {
                   c.Status = 'Ineligible';
                   c.Ineligible_Reason__c = 'Age Over 21';
               }
           }
        
        return c;
    }
    
    public static case checkDuplicate(Case c) {
        
        if(c != null && c.C_Last_Name__c != null) {
            
            
            Boolean dupeFound = false;
            
            String caseChildExternalId = c.C_First_Name__c + c.C_Last_Name__c + c.C_DOB__c.Year() + c.C_DOB__c.Month() + c.C_DOB__c.Day();
            
            List<Contact> cList = new List<Contact>([SELECT Id, FirstName, LastName, Birthdate FROM Contact WHERE External_Id__c = :caseChildExternalId]);
            
            if(!cList.isEmpty()) {
                
                dupeFound = true;
            } else {
                
                cList = new List<Contact>([SELECT Id, FirstName, LastName, Birthdate FROM Contact WHERE (FirstName = :c.C_First_Name__c AND LastName = :c.C_Last_Name__c) OR (LastName = :c.C_Last_Name__c AND BirthDate = :c.C_DOB__c)]);
                
                if(!cList.isEmpty()) {
                    
                    dupeFound = true;
                } 
            }
            
            c.Possible_Duplicate__c = dupeFound;
            
        }
        
        return c;
    }
    
    webservice static String convert(Id caseId) {
        
        Case app = [SELECT Aboriginal_or_Torres_Strait_Islander__c,Can_your_child_communicate_verbally__c,Child_also_has_a_case_worker__c,Contact_school_regarding_wish__c, LastModifiedDate, Application_Received_Date_Time__c,
                    Currently_in_respite_care__c,C_Address__c,C_City__c,C_Condition__c,C_DOB__c,C_First_Name__c,C_Gender__c,C_Last_Name__c,C_State__c,C_Postcode__c,Does_family_require_an_interpreter__c,
                    Email_Opt_Out__c,Ineligible_Reason__c,Interpreter_Organisation__c,IO_Phone__c,Is_child_aware_condition_is_life_threat__c,Medical_Professional__c,MP_Email__c,MP_Fax__c,
                    MP_First_Name__c,MP_Hospital__c,MP_Phone__c,MP_Postcode__c,MP_State__c,MP_Surname__c,MP_Title__c,Name_of_School_or_Kindergarten__c,PC_Address__c,PC_Email__c,
                    PC_First_Name__c,PC_Phone__c,PC_Postcode__c,PC_Secondary_Phone__c,PC_State__c,PC_Suburb__c,PC_Surname__c,PC_DOB__c,PC_Gender__c,Possible_Duplicate__c,Primary_Contact__c,
                    Primary_language_spoken_at_home__c,Referral_other__c,Relationship_to_child__c,R_Address__c,R_Email__c,R_First_Name__c,R_State__c,R_Suburb__c,R_Surname__c,
                    School_know_of_the_child_s_illness__c,SK_Address__c,SK_Phone__c,SK_State__c,Social_Worker__c,Spoken_to_Parent_Guardian__c,Status,Subject,SW_Email__c, Fit_For_Wish__c, 
                    SW_First_Name__c,SW_Hospital__c,SW_Phone__c,SW_Surname__c,SW_Title__c,Type,Urgent_Wish__c,Who_referred_you_to_Make_A_Wish__c,Wish__c,
                    (SELECT Id, First_Name__c, Surname__c, Gender__c, Birthdate__c, DOB__c, Relationship__c FROM Application_Participants__r)
                    FROM Case WHERE Id = :caseId];
        //
        if(app.Wish__c != null || app.Status == 'Converted Wish') {
            return 'Error: Application already converted.';
        }
        
        Wish__c wish;
        Map<String, Contact> cMap = new Map<String, Contact>();
        
        Map<String, Id> relationshipMap = new Map<String, Id>();
        
        Map<String, RecordType> rMap = new Map<String, RecordType>();
        for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = 'Contact']){
            System.debug(rt);
            rMap.put(rt.DeveloperName, rt); 
        }
        System.debug(rMap);
        Contact child = new Contact();
        
        child.RecordTypeId = rMap != null && rMap.get('Wish_Child') != null ? rMap.get('Wish_Child').Id : null;
        
        child.FirstName = app.C_First_Name__c;
        child.LastName = app.C_Last_Name__c;
        child.Gender__c = app.C_Gender__c;
        child.Birthdate = app.C_DOB__c;
        
        child.MailingStreet = app.C_Address__c;
        child.MailingState = app.C_State__c;
        child.MailingCity = app.C_City__c;
        child.MailingPostalCode = app.C_Postcode__c;
        
        child.External_Id__c = app.C_First_Name__c + app.C_Last_Name__c + app.C_DOB__c.Year() + app.C_DOB__c.Month() + app.C_DOB__c.Day();
        
        cMap.put('Wish Child', child);
        
        if(!String.isBlank(app.PC_Surname__c) ) {
            
            Contact primaryContact = new Contact(FirstName = app.PC_First_Name__c, LastName = app.PC_Surname__c, MobilePhone = app.PC_Phone__c, HomePhone = app.PC_Secondary_Phone__c, npe01__PreferredPhone__c = 'Personal', Email = app.PC_Email__c, MailingStreet = app.PC_Address__c, MailingCity = app.PC_Suburb__c, MailingState = app.PC_State__c, MailingPostalCode = app.PC_Postcode__c, Gender__c = app.PC_Gender__c, Birthdate = app.PC_DOB__c );
            primaryContact.RecordTypeId = rMap != null && rMap.get('Primary_Contact') != null ? rMap.get('Primary_Contact').Id : null;
            
            primaryContact.External_Id__c = app.PC_First_Name__c + app.PC_Surname__c + app.PC_Email__c;
            
            cMap.put(app.Relationship_to_child__c, primaryContact);
            
        }
        
        if(app.Medical_Professional__c != null) {
            
            relationshipMap.put('Medical Specialist', app.Medical_Professional__c);
            
        } else if(!String.isBlank(app.MP_Surname__c) ) {
            
            Contact medSpecialist = new Contact(Salutation = app.MP_Title__c, FirstName = app.MP_First_Name__c, LastName = app.MP_Surname__c, Phone = app.MP_Phone__c,  npe01__PreferredPhone__c = 'Work', Fax = app.MP_Fax__c, Email = app.MP_Email__c, MailingState = app.MP_State__c, MailingPostalCode = app.MP_Postcode__c);
            medSpecialist.RecordTypeId = rMap != null && rMap.get('Medical_Specialist') != null ? rMap.get('Medical_Specialist').Id : null;
            
            medSpecialist.External_Id__c = app.MP_First_Name__c + app.MP_Surname__c + app.MP_Email__c;
            
            cMap.put('Medical Specialist', medSpecialist);
            
        }
        
        if(app.Social_Worker__c != null) {
            
            relationshipMap.put('Social Worker', app.Social_Worker__c);
            
        } else if(!String.isBlank(app.SW_Surname__c) ) {
            
            Contact socialWorker = new Contact(Salutation = app.SW_Title__c, FirstName = app.SW_First_Name__c, LastName = app.SW_Surname__c, Phone = app.SW_Phone__c,  npe01__PreferredPhone__c = 'Work', Email = app.SW_Email__c);
            socialWorker.RecordTypeId = rMap != null && rMap.get('Social_Worker') != null ? rMap.get('Social_Worker').Id : null;
            
            socialWorker.External_Id__c = app.SW_First_Name__c + app.SW_Surname__c + app.SW_Email__c;
            
            cMap.put('Social Worker', socialWorker);
            
        }
        
        if(!app.Application_Participants__r.isEmpty()) {
            //more applicants
            
            Integer i = 0;
            
            for(Application_Participant__c ap : app.Application_Participants__r){
                
                if(ap.Surname__c != null) {
                    
                    Contact p = new Contact();
                    
                    p.RecordTypeId = rMap != null && rMap.get('Family_Members') != null ? rMap.get('Family_Members').Id : null;
                    
                    p.FirstName = ap.First_Name__c;
                    p.LastName = ap.Surname__c;
                    p.Gender__c = ap.Gender__c;
                    p.Birthdate = ap.Birthdate__c;
                    p.Relationship_With_Child__c = ap.Relationship__c;
                    
                    
                    try {
                        if(ap.DOB__c != null) {
                            String[] dt = ap.DOB__c.split('/');
                            p.Birthdate = Date.newInstance(Integer.valueOf(dt[2]), Integer.valueOf(dt[1]), Integer.valueOf(dt[0]));
                        }
                    } catch (Exception e) {}
                    
                    if(ap.Birthdate__c != null) {
                        p.External_Id__c = ap.First_Name__c + ap.Surname__c + ap.Birthdate__c.Year() + ap.Birthdate__c.Month() + ap.Birthdate__c.Day();
                    } else {
                        p.External_Id__c = ap.First_Name__c + ap.Surname__c;
                    }
                    
                    
                    if(cMap.get(ap.Relationship__c) == null) {
                        
                        cMap.put(ap.Relationship__c, p);
                    } else {
                        
                        cMap.put(ap.Relationship__c + ':' + String.valueOf(i), p);
                        i++;
                    }
                    
                }
            }
        }
        
        if(cMap != null && !cMap.isEmpty()) {
            
            try {
                for(String key : cMap.keySet())
                    SYstem.debug(cMap.get(key));
                //System.debug(External_Id__c);
                
                upsert cMap.values();
                
            } catch(Exception e) {
                
                System.Debug('convert: ' + e.getMessage() + e.getLineNumber());
                return 'Error:' + e.getMessage();
            }
            
            if(cMap.get('Wish Child') != null && cMap.get('Wish Child').Id != null) {
                
                wish = new Wish__c(Name = child.FirstName + ' ' + child.LastName, Child__c = cMap.get('Wish Child').Id);
                
                try {
                    
                    //wish.Application_Date__c = date.newInstance(app.Application_Received_Date_Time__c.Year(), app.Application_Received_Date_Time__c.Month(), app.Application_Received_Date_Time__c.Day());
                    
                    insert wish;
                    
                } catch(Exception e) {
                    
                    return 'Error:' + e.getMessage();
                }
                
                List<Wish_Participation__c> wpList = new List<Wish_Participation__c>();
                
                for(String key : cMap.keySet()) {
                    
                    Wish_Participation__c wp = new Wish_Participation__c();      
                    
                    wp.Wish_Name__c = wish.Id;
                    wp.Name__c = cMap.get(key).Id;
                    
                    key = key.contains(':') ? key.left(key.indexOf(':')) : key;
                    
                    wp.Type__c = key;
                    
                    wpList.add(wp);
                }
                
                for(String key : relationshipMap.keySet()) {
                    
                    Wish_Participation__c wp = new Wish_Participation__c();      
                    
                    wp.Wish_Name__c = wish.Id;
                    wp.Name__c = relationshipMap.get(key);
                    wp.Type__c = key;
                    
                    wpList.add(wp);
                }
                
                try {
                    
                    insert wpList;
                    
                } catch(Exception e) {
                    
                    return 'Error:' + e.getMessage();
                }
            }
            
        }
        
        if(wish != null && wish.Id != null) {
            
            app.Status = 'Approved';
            app.Wish__c = wish.id;
            
            try {
                System.debug('In');
                update app;
            } catch (Exception e) {
                
                return 'Error: ' + e.getMessage();
            }
            
            return wish.Id;
        } else {
            
            return 'Error: conversion failed.';
        }
        
    }
    
    //Add entry point for Lightning Component
    @AuraEnabled
    public static String caseToWish(Id caseId){
        
        //Convert method needs refactoring 
        String message = WishClass.convert(caseId);
        if(Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( message ).matches()){
            return message;
        }else{
            throw new AuraHandledException(message);
        }
        
    }
    
}
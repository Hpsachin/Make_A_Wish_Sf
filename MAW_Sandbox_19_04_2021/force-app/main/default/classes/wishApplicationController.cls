public class wishApplicationController {
    
    public Case wishCase {
        get;
        set;
    }
    public String caseId {
        get;
        set;
    }
    
    public List<Application_Participant__c> apList {
        get;
        set;
    }
    
    public Set<String> guardianTypes = new Set<String> {
        'Mother',
            'Father',
            'Legal Guardian'
            };
                public Boolean hasConsent {
                    get;
                    set;
                }
    
    public Set<String> medicalTypes = new Set<String> {
        'Treating Medical Specialist',
            'Social Worker',
            'Case Worker'
            };
                public Boolean hasMedical {
                    get;
                    set;
                }
    
    public Boolean isChild {
        get;
        set;
    }
    
    public String childDeterminer {
        get {
            return childDeterminer == null ? 'the' : childDeterminer;
        }
        set;
    }
    
    public wishApplicationController() {
        
        caseId = ApexPages.currentPage().getParameters().get('Id');
        
        System.Debug('caseId: ' + caseId);
        
        apList = new List<Application_Participant__c> ();
        apList.add(new Application_Participant__c());
        
        if (caseId != null) {
            
            List<Case> cList = new List<Case> ([SELECT Aboriginal_or_Torres_Strait_Islander__c, Can_your_child_communicate_verbally__c, Child_also_has_a_case_worker__c, Contact_school_regarding_wish__c, LastModifiedDate,
                                                Currently_in_respite_care__c, C_Address__c, C_City__c, C_Condition__c, C_DOB__c, C_First_Name__c, C_Gender__c, C_Last_Name__c, C_State__c, C_Postcode__c, Does_family_require_an_interpreter__c,
                                                Email_Opt_Out__c, Ineligible_Reason__c, Interpreter_Organisation__c, IO_Phone__c, Is_child_aware_condition_is_life_threat__c, Medical_Professional__c, MP_Email__c, MP_Fax__c,
                                                MP_First_Name__c, MP_Hospital__c, MP_Department__c, MP_Phone__c, MP_Postcode__c, MP_State__c, MP_Surname__c, MP_Title__c, Name_of_School_or_Kindergarten__c, PC_Address__c, PC_Email__c,
                                                PC_First_Name__c, PC_DOB__c, PC_Phone__c, PC_Postcode__c, PC_Gender__c, PC_Secondary_Phone__c, PC_State__c, PC_Suburb__c, PC_Surname__c, Possible_Duplicate__c, Primary_Contact__c,
                                                Primary_language_spoken_at_home__c, Referral_other__c, Relationship_to_child__c, R_Address__c, R_Postcode__c, R_Email__c, R_First_Name__c, R_State__c, R_Suburb__c, R_Surname__c,
                                                School_know_of_the_child_s_illness__c, SK_Address__c, SK_Phone__c, SK_State__c, SK_Postcode__c, SK_Suburb__c, Social_Worker__c, Spoken_to_Parent_Guardian__c, Status, Subject, SW_Email__c,
                                                SW_First_Name__c, SW_Hospital__c, SW_Phone__c, SW_Surname__c, SW_Title__c, Type, Urgent_Wish__c, Who_referred_you_to_Make_A_Wish__c, Wish__c,
                                                (SELECT Id, Case__c, First_Name__c, Surname__c, Relationship__c, Gender__c, Birthdate__c, DOB__c FROM Application_Participants__r) FROM Case WHERE Id = :caseId
                                               ]);
            
            System.Debug('Number of cases: ' + cList.size());
            
            if (!cList.isEmpty() && cList[0].Status == 'Awaiting Application Completion') {
                //Only load case when still in "Awaiting Application Completion" status
                wishCase = cList[0].clone();
                
                if (!wishCase.Application_Participants__r.isEmpty()) {
                    apList = wishCase.Application_Participants__r;
                }
                
                checkConsent();
                
            } else {
                caseId = null;
            }
            
            System.Debug('wishCase: ' + wishCase);
            
        }
        
        if (wishCase == null) {
            //new application
            wishCase = new Case();
            
            //Assign RecordType
            List<RecordType> rtList = new List<RecordType> ([SELECT Id FROM RecordType WHERE sObjectType = 'Case'
                                                             AND DeveloperName = 'Wish_Referral'
                                                            ]);
            
            if (!rtList.isEmpty())
                wishCase.RecordTypeId = rtList[0].Id;
        }
        
    }
    
    public List<SelectOption> getChildGuardianTypes() {
        
        List<SelectOption> result = new List<SelectOption> ();
        
        for (String g: guardianTypes)
            result.add(new SelectOption(g, g));
        
        return result;
    }
    
    public String selectedRelationship {
        get;
        set;
    }
    public list<SelectOption> getRelationships() {
        
        List<SelectOption> result = new List<SelectOption> ();
        guardianTypes = new Set<String> ();
        
        result.add(new SelectOption('', ''));
        
        Schema.DescribeFieldResult fieldResult1 = Case.Relationship_to_child__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        
        for (Schema.PicklistEntry f: ple1) {
            //add to validate list
            guardianTypes.add(f.getValue());
            result.add(new SelectOption(f.getValue(), f.getLabel()));
        }
        
        if (wishCase != null && caseId == null) {
            
            Schema.DescribeFieldResult fieldResult2 = Case.Referral_Relationship_to_Child__c.getDescribe();
            List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
            
            for (Schema.PicklistEntry f: ple2)
                result.add(new SelectOption(f.getValue(), f.getLabel()));
            
        }
        
        return result;
    }
    
    public void addAppPart() {
        apList.add(new Application_Participant__c());
    }
    
    public void checkConsent() {
        
        if (guardianTypes != null) {
            hasConsent = guardianTypes.contains(wishCase.Referral_Relationship_to_Child__c) || guardianTypes.contains(wishCase.Relationship_to_Child__c);
            childDeterminer = 'your';
        }
        
        if (medicalTypes != null) {
            hasMedical = medicalTypes.contains(wishCase.Referral_Relationship_to_Child__c) || medicalTypes.contains(wishCase.Relationship_to_Child__c);
        }
        
        isChild = wishCase.Referral_Relationship_to_Child__c == 'Child';
    }
    
    public String submitError {
        get;
        set;
    }
    
    public pageReference submitWishCase() {
        
        submitError = null;
        
        try {
            
            Contact primaryContact;
            
            if (!String.isBlank(wishCase.PC_Surname__c)) {
                
                primaryContact = new Contact(FirstName = wishCase.PC_First_Name__c, LastName = wishCase.PC_Surname__c, Phone = wishCase.PC_Phone__c, Email = wishCase.PC_Email__c, MailingState = wishCase.PC_State__c, MailingPostalCode = wishCase.PC_Postcode__c, Birthdate = wishCase.PC_DOB__c, Gender__c = wishCase.PC_Gender__c);
                primaryContact.External_Id__c = wishCase.PC_First_Name__c + wishCase.PC_Surname__c + wishCase.PC_Email__c;
                
                upsert primaryContact External_Id__c;
                
                wishCase.Primary_Contact__c = primaryContact.Id;
            }
            
            if (hasConsent) {
                wishCase.Status = 'Application Received';
                wishCase.Subject = 'Wish Application';
                
                if (caseId == null) {
                    wishCase.Relationship_to_child__c = wishCase.Referral_Relationship_to_Child__c;
                    wishCase.Referral_Relationship_to_Child__c = null;
                }
            } else {
                wishCase.Status = 'Referral';
                wishCase.Subject = 'Wish Referral';
            }
            
            wishCase.Origin = 'Web Application';
            
            if (wishCase.Urgent_Wish__c == 'Yes')
                wishCase.Priority = 'High';
            
            //Move values to matching fields
            if (wishCase.Id == null && hasConsent) {
                //if first submission by P/G, add there details to referee
                
                wishCase.Referral_Relationship_to_Child__c = wishCase.Relationship_to_child__c;
                wishCase.R_First_Name__c = wishCase.PC_First_Name__c;
                wishCase.R_Surname__c = wishCase.PC_Surname__c;
                wishCase.R_Email__c = wishCase.PC_Email__c;
                wishCase.R_Address__c = wishCase.PC_Address__c;
                wishCase.R_Suburb__c = wishCase.PC_Suburb__c;
                wishCase.R_State__c = wishCase.PC_State__c;
                wishCase.R_Postcode__c = wishCase.PC_Postcode__c;
            }
            
            if (wishCase.Id == null && wishCase.Referral_Relationship_to_Child__c == 'Social Worker') {
                
                wishCase.SW_First_Name__c = wishCase.R_First_Name__c;
                wishCase.SW_Surname__c = wishCase.R_Surname__c;
                wishCase.SW_Email__c = wishCase.R_Email__c;
                
            }
            
            //Validate
            wishCase = WishClass.checkDuplicate(wishCase);
            wishCase = WishClass.validateAge(wishCase);
            
            if (caseId != null) {
                //upsert
                wishCase.External_Id__c = caseId;
                upsert wishCase External_Id__c;
            } else {
                
                insert wishCase;
            }
            
            if (wishCase.Id != null && !apList.isEmpty()) {
                
                List<Application_Participant__c> upsertList = new List<Application_Participant__c>();
                
                for (Application_Participant__c ap: apList) {
                    
                    if (ap.First_Name__c != null && ap.Surname__c != null) {
                        ap.Case__c = wishCase.Id;
                        upsertList.add(ap);
                    }
                }
                
                if (!upsertList.isEmpty()) {
                    upsert upsertList;
                }
            }
            
            pageReference pageRef = Page.wishApplicationConfirmation;
            pageRef.setRedirect(true);
            pageRef.getParameters().put('id', wishCase.Id);
            
            return pageRef;
            
        } catch (Exception e) {
            
            System.debug('ERROR: ' + e);
            submitError = 'There has been an error submitting your application.';
            
            return null;
        }
    }
}
public class validateWishCaseController {

    public Case c {get;set;}
    public Boolean dupeFound {get;set;}
    
    public validateWishCaseController(ApexPages.StandardController sc) {
        
        if(!Test.isRunningTest())
            sc.addFields(new List<String> {'ContactId','Primary_Contact__c','Status','Relationship_to_child__c','Social_Worker__c','Medical_Professional__c','Stage__c','Aboriginal_or_Torres_Strait_Islander__c','Can_your_child_communicate_verbally__c','Contact_school_regarding_wish__c','Currently_in_respite_care__c','C_Address__c','C_City__c','C_Condition__c','C_DOB__c','C_First_Name__c','C_Gender__c','C_Last_Name__c','C_State__c','Does_family_require_an_interpreter__c','Email_Opt_Out__c','MP_Hospital__c','Interpreter_Organisation__c','IO_Phone__c','Is_child_aware_condition_is_life_threat__c','MP_Email__c','MP_Fax__c','MP_First_Name__c','MP_Phone__c','MP_Postcode__c','MP_State__c','MP_Surname__c','Name_of_School_or_Kindergarten__c','PC_Email__c','PC_First_Name__c','PC_Phone__c','PC_Secondary_Phone__c','PC_Surname__c','Referral_other__c','SK_Address__c','SK_Phone__c','SK_State__c','SW_Email__c','SW_First_Name__c','SW_Hospital__c','SW_Phone__c','SW_Surname__c','SW_Title__c','MP_Title__c','Who_referred_you_to_Make_A_Wish__c'});
        
        c = (Case)sc.getRecord();

        if(c.Status == 'Converted Wish') {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Application Converted to Wish.'));
            
        } else {
        
            checkDup();
        	checkAge();
        }
    }
    
    public void checkAge() {
        
        if(c != null
           && c.C_DOB__c != null) {
               
               Date dob = c.C_DOB__c;
               
               Integer totalDays = dob.daysBetween(System.Today());
               
			   Integer Age = (integer)(math.Floor(totalDays/365.2425));
               
               if(Age < 3) {
                   //young, hamper list
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Wish Child\'s Age is Under 3. Referral Status set to "Hamper".'));
               } else if(Age >= 18 && Age <=21) {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Wish Child\'s Age is Over 18 but under 21. Referral Status set to "Starlight Referral".'));
                   //old but not too old
               } else if(Age > 21) {
                   //too old
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Wish Child\'s Age is Over 21. Referral Status set to "Ineligible".'));
               } else {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Age Check Complete.'));
               }
           }
        
    }
    
    public void checkDup() {

        String caseChildExternalId = c.C_First_Name__c + c.C_Last_Name__c + c.C_DOB__c.Year() + c.C_DOB__c.Month() + c.C_DOB__c.Day();
        
        List<Contact> cList = new List<Contact>([SELECT Id, FirstName, LastName, Birthdate FROM Contact WHERE External_Id__c = :caseChildExternalId]);
        
        if(!cList.isEmpty()) {
            
            dupeFound = true;
            
            String result = '<ul style="margin-bottom: 0px;">';
            for(Contact d : cList)
                result += '<li><a href="/' + d.id + '" target="_blank">' + d.FirstName + ' ' + d.LastName + ' ' + d.BirthDate.Day() +'/'+  d.BirthDate.Month() +'/'+  d.BirthDate.Year() + '</a></i>';
            
            result += '</ul>';
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate Contact Found.' + result));
        } else {
            
            cList = new List<Contact>([SELECT Id, FirstName, LastName, Birthdate FROM Contact WHERE (FirstName = :c.C_First_Name__c AND LastName = :c.C_Last_Name__c) OR (LastName = :c.C_Last_Name__c AND BirthDate = :c.C_DOB__c)]);
            
            if(!cList.isEmpty()) {
                
                dupeFound = true;
                
                String result = '<ul style="margin-bottom: 0px;">';
                for(Contact d : cList)
                    result += '<li><a href="/' + d.id + '" target="_blank">' + d.FirstName + ' ' + d.LastName + ' ' + (d.BirthDate != null ? d.BirthDate.Day() +'/'+  d.BirthDate.Month() +'/'+  d.BirthDate.Year() : '') + '</a></i>';
                
                result += '</ul>';
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Possible Duplicate Contact Found.' + result));
                
            } else {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Duplicate Check Complete.'));
            }
            
        }
        
    }
    
}
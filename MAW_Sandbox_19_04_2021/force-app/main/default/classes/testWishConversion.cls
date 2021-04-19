@isTest
public class testWishConversion {
    
    //TO DO (This needs to be redone completely)
    static testMethod void testWishConversion() {
        
        Case c = new Case();        
        c.Application_Received_Date_Time__c = Datetime.now();
        c.Origin = 'Email';
        
        //Referer
        c.R_First_Name__c = 'Refer';
        c.R_Surname__c = 'Surname';
        c.Referral_Relationship_to_Child__c = 'Mother';
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
        c.Relationship_to_child__c = 'Father';
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
        ap.Relationship__c = 'Father';
        
        insert ap;
        
        try{
            WishClass.validateAge(c);
            WishClass.checkDuplicate(c);
            WishClass.convert(c.Id);
            WishClass.caseToWish(c.Id);
        }catch(Exception e){}
        
        
    }
    
}
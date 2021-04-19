public class wishHomeVisitController {
    
    public Home_Visit__c visit {get;set;}
    
    public String childName {get;set;}
    
    public wishHomeVisitController(ApexPages.StandardController sc) {
        
        if(!Test.isRunningTest())
            sc.addFields(new List<String> {'Status__c','Scheduled_Date__c','Medical_Equipment__c','Any_other_details_to_assist_in_planning__c','Are_they_able_to_stand_walk__c','Cherished_Wish__c','Comfortable_with_these_ideas__c','Date_of_Home_Visit__c','Does_the_child_have_a_paid_carer__c','Groud_floor_Wheelchair_Accomodation__c','How_do_you_feel__c','Id','Ideas_on_how_the_wish_might_happen__c','Include_others_in_wish__c','Is_the_child_in_a_wheelchair__c','Medical_Equipment_Required__c','Name','Reason_for_Phone_Visit__c','Report_Completed_By__c','Suitable_for_public_relations_reason__c','Suitable_for_Public_Relations__c','SystemModstamp','Visit_Place__c','Wheelchair_accessible_transfers__c','Wheelchair_type__c','Wish_Child_Name__c','Wish_family_dynamics__c','Wish_specifics__c','Wish__c','Wish__r.Name'});
        
        visit = (Home_Visit__c)sc.getRecord();

        if(visit.Status__c == null)
           visit.Status__c = 'In Progress'; 
        
        if(visit.Report_Completed_By__c == null)
            visit.Report_Completed_By__c = UserInfo.getUserId();
        
    }

    
    public pageReference save() {
        
        try {
            
            upsert visit;
            
            pageReference pageRef = new pageReference('/' + visit.Id);
            pageRef.setRedirect(true);
            
            return pageRef;
            
        } catch(Exception e) {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            
            return null;
        }
        
    }

}
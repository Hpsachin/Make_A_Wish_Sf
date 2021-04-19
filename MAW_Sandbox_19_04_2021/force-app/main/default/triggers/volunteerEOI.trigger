trigger volunteerEOI on Form__c (before insert, before update, after insert, after update) {

    if(Trigger.isBefore) {
     	//assign volunteer eoi form
        volunteerClass.eoiOwnership(Trigger.New);
    }
    
    if(Trigger.isAfter) {
        //convert form into contact
        Set<Id> fSet = new Set<Id>();
        
        for(Form__c f : Trigger.new) {
            if(f.Volunteer_Status__c == 'Suitable' && f.Account__c != null) {
                fSet.add(f.Id);
            }
        }
        
        if(!fSet.isEmpty())
            volunteerClass.convertEOI(fSet);
    }
    
}
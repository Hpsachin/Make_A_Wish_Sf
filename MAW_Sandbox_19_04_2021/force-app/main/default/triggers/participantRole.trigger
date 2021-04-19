trigger participantRole on Wish_Participation__c (after insert, after update) {

    Set<Id> wSet = new Set<Id>();
    
    System.debug('participantRole: ' + Trigger.New);
    
    for(Wish_Participation__c wp : Trigger.New) {
        if(wp.Type__c == 'Branch Volunteer Team Leader' || wp.Type__c == 'Lead Designer')
            wSet.add(wp.Wish_Name__c);
    }
        
    if(!wSet.isEmpty()) {
        
        Boolean updateRequired = false;
        Map<Id, Wish__c> wMap = new Map<Id, Wish__c>([SELECT Id, Volunteer_Team_Leader__c, Designer__c FROM Wish__c WHERE Id IN :wSet]);
        
        for(Wish_Participation__c wp : Trigger.New) {
            if(wp.Type__c == 'Branch Volunteer Team Leader' && wMap.get(wp.Wish_Name__c) != null && wMap.get(wp.Wish_Name__c).Volunteer_Team_Leader__c != wp.User__c) {
                wMap.get(wp.Wish_Name__c).Volunteer_Team_Leader__c = wp.User__c;
                updateRequired = true;
            }
            if(wp.Type__c == 'Lead Designer' && wMap.get(wp.Wish_Name__c) != null && wMap.get(wp.Wish_Name__c).Designer__c != wp.User__c) {
                wMap.get(wp.Wish_Name__c).Designer__c = wp.User__c;
                updateRequired = true;
            }
        }
        
        if(updateRequired)
            update wMap.values();
        
    }

}
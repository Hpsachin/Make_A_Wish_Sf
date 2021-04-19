trigger participantSharing on Wish_Participation__c (after insert, after update) {

    Set<Id> wSet = new Set<Id>();
    for(Wish_Participation__c w : Trigger.New)
        wSet.add(w.Wish_Name__c);

    Map<String, Wish__Share> wsMap = new Map<String, Wish__Share>();
    
    for(Wish__Share ws : [SELECT Id, ParentId, UserOrGroupId FROM Wish__Share WHERE ParentId IN :wSet])
        wsMap.put(ws.ParentId +''+ ws.UserOrGroupId, ws);
    
    Map<Id, RecordType> rMap = new Map<Id, RecordType>([SELECT Id FROM RecordType WHERE sObjectType = 'Wish_Participation__c' AND DeveloperName = 'Volunteer_Participant']);
    
    List<Wish__Share> wsList = new List<Wish__Share>();
        
    for(Wish_Participation__c w : Trigger.New) {
        
        if(w.User__c != null && w.Wish_Sharing__c != null && rMap.get(w.RecordTypeId) != null && wsMap.get(w.Wish_Name__c +''+ w.User__c) == null) {
            
            Wish__Share ws = new Wish__Share();
            
            ws.ParentId = w.Wish_Name__c;
            ws.UserOrGroupId = w.User__c;
            ws.AccessLevel = w.Wish_Sharing__c;
            ws.RowCause = Wish__Share.rowCause.Wish_Participant__c;
            
            wsList.add(ws);
            
        }
    }
    
    if(!wsList.isEmpty()) {
        
            upsert wsList;
    }
    
}
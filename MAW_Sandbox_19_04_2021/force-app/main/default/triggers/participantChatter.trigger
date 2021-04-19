trigger participantChatter on Wish_Participation__c (after insert, after update) {

    Set<Id> wSet = new Set<Id>();
    for(Wish_Participation__c w : Trigger.New)
        wSet.add(w.Wish_Name__c);
    
    Map<Id, User> uMap = new Map<Id, User>([SELECT Id FROM User WHERE UserType = 'PowerCustomerSuccess']);
    
    Id nId = null;
    
    if(!uMap.isEmpty()) {
        List<Network> nList = new List<Network>([SELECT Id FROM Network WHERE Name = 'Volunteers']);
        nId = nList.isEmpty() ? null : nList[0].Id;
    }
    
    Map<String, EntitySubscription> esMap = new Map<String, EntitySubscription>();
    
    for(EntitySubscription es : [SELECT Id, ParentId, SubscriberId FROM EntitySubscription WHERE ParentId IN :wSet])
        esMap.put(es.ParentId +''+ es.SubscriberId, es);
    
    List<EntitySubscription> esList = new List<EntitySubscription>();
         
    for(Wish_Participation__c w : Trigger.New) {
        
        if(w.User__c != null && esMap.get(w.Wish_Name__c +''+ w.User__c) == null) {
            
            EntitySubscription es = new EntitySubscription();
            
            es.ParentId = w.Wish_Name__c;
            es.SubscriberId = w.User__c;
            
            if(!uMap.isEmpty() && uMap.get(w.User__c) != null && nId != null) {
                //Need to specify Network Id of Community Users
                es.NetworkId = nId;
            }
            
            esList.add(es);
            
        }
    }
    
    if(!esList.isEmpty()) {
        
        try {
            upsert esList;
        } catch (Exception e) {
            System.debug(e);
        }
    }
    
}
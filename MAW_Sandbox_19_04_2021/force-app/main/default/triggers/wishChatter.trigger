trigger wishChatter on Wish__c (after insert, after update) {
    
    Wish_Triggers__c wt = Wish_Triggers__c.getOrgDefaults();
    
    if(!wt.Disable_wishChatter__c) {
        
        Map<String, EntitySubscription> esMap = new Map<String, EntitySubscription>();
        
        for(EntitySubscription es : [SELECT Id, ParentId, SubscriberId FROM EntitySubscription WHERE ParentId IN :Trigger.New])
            esMap.put(es.ParentId +''+ es.SubscriberId, es);
        
        List<EntitySubscription> esList = new List<EntitySubscription>();
        Set<Id> completedWishes = new Set<Id>();
        
        for(Wish__c w : Trigger.New) {
            
            if (String.isBlank(w.Admin_Status__c) || w.Admin_Status__c != 'Complete') {
                if(w.Wish_Co_Ordinator__c != null && esMap.get(w.Id +''+ w.Wish_Co_Ordinator__c) == null) {
                    
                    EntitySubscription es = new EntitySubscription();
                    
                    es.ParentId = w.Id;
                    es.SubscriberId = w.Wish_Co_Ordinator__c;
                    
                    esList.add(es);
                    
                }
                
                if(w.Wish_Co_Ordinator_Assisting__c != null && esMap.get(w.Id +''+ w.Wish_Co_Ordinator_Assisting__c) == null) {
                    
                    EntitySubscription es2 = new EntitySubscription();
                    
                    es2.ParentId = w.Id;
                    es2.SubscriberId = w.Wish_Co_Ordinator_Assisting__c;
                    
                    esList.add(es2);
                    
                }
            } else if (!String.isBlank(w.Admin_Status__c) && w.Admin_Status__c == 'Complete') {
            	completedWishes.add(w.Id);
            }
        }
        
        if(!esList.isEmpty()) {
            
            upsert esList;
        }
        
        if (!completedWishes.isEmpty()) {
            List<EntitySubscription> eSubs = new List<EntitySubscription>([SELECT Id FROM EntitySubscription WHERE ParentId IN :completedWishes]);
                        
            delete eSubs;
        }
        
    }

}
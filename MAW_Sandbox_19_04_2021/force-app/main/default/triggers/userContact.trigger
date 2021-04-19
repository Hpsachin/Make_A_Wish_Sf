trigger userContact on User (after insert, after update) {
    
    Set<Id> cSet = new Set<Id>();

    for(User u : Trigger.New) {
        //collect contact id's from user records
        if(u.ContactId != null)
            cSet.add(u.ContactId);
    }
    
    if(!cSet.isEmpty()) {
        //get contacts
        Map<Id, Contact> cMap = new Map<Id, Contact>([SELECT Id, Community_User_Id__c FROM Contact WHERE Id IN :cSet AND Community_User_Id__c = null]);
        
        if(!cMap.isEmpty()) {
            
            List<Contact> cList = new List<Contact>();
            
            for(User u : Trigger.New) {
                
                if(u.ContactId != null && cMap.get(u.ContactId) != null) {
                    //add user id to contact
                    cMap.get(u.ContactId).Community_User_Id__c = u.Id;
                    cList.add(cMap.get(u.ContactId));
                }
            }
            
            if(!cList.isEmpty())
                update cList;
            
        }
        
    }
    
}
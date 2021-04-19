trigger wishSharing on Wish__c (after insert, after update) {
    
    Wish_Triggers__c wt = Wish_Triggers__c.getOrgDefaults();
    
    if(!wt.Disable_wishSharing__c) {
        
        Map<String, Wish__Share > wsMap = new Map<String, Wish__Share >();
        
        for(Wish__Share  ws : [SELECT Id, ParentId, UserOrGroupId FROM Wish__Share WHERE ParentId IN :Trigger.New])
            wsMap.put(ws.ParentId +''+ ws.UserOrGroupId, ws);
        
        Set<Id> bSet = new Set<Id>();
        
        for(Wish__c w : Trigger.New)
            bSet.add(w.Volunteer_Branch__c);
        
        if(!bSet.isEmpty()) {
            
            Map<Id, Account> aMap = new Map<Id, Account>([SELECT Id, Branch_Wish_Granting_Co_ordinator__c, Branch_Wish_Granting_Co_ordinator__r.Community_User_Id__c, Branch_President__c, Branch_President__r.Community_User_Id__c FROM Account WHERE Id IN :bSet]);
            
            List<Wish__Share> wsList = new List<Wish__Share>();
            
            for(Wish__c w : Trigger.New) {
                
                if(w.Volunteer_Branch__c != null) {
                    
                    
                    if(!aMap.isEmpty() && aMap.containsKey(w.Volunteer_Branch__c)) {
                        
                        if(aMap.get(w.Volunteer_Branch__c).Branch_Wish_Granting_Co_ordinator__c != null && aMap.get(w.Volunteer_Branch__c).Branch_Wish_Granting_Co_ordinator__r.Community_User_Id__c != NULL && wsMap.get(w.Id +''+ aMap.get(w.Volunteer_Branch__c).Branch_Wish_Granting_Co_ordinator__r.Community_User_Id__c) == null) {
                            
                            Wish__Share ws1 = new Wish__Share();
                            
                            ws1.ParentId = w.Id;
                            ws1.UserOrGroupId = aMap.get(w.Volunteer_Branch__c).Branch_Wish_Granting_Co_ordinator__r.Community_User_Id__c;
                            ws1.AccessLevel = 'Edit';
                            ws1.RowCause = Wish__Share.rowCause.Volunteer_Branch_Contact__c;
                            
                            wsList.add(ws1);
                            
                        }
                        
                        if(aMap.get(w.Volunteer_Branch__c).Branch_President__c != null && aMap.get(w.Volunteer_Branch__c).Branch_President__r.Community_User_Id__c != NULL && wsMap.get(w.Id +''+ aMap.get(w.Volunteer_Branch__c).Branch_President__r.Community_User_Id__c) == null) {
                            
                            Wish__Share ws2 = new Wish__Share();
                            
                            ws2.ParentId = w.Id;
                            ws2.UserOrGroupId = aMap.get(w.Volunteer_Branch__c).Branch_President__r.Community_User_Id__c;
                            ws2.AccessLevel = 'Edit';
                            ws2.RowCause = Wish__Share.rowCause.Volunteer_Branch_Contact__c;
                            
                            wsList.add(ws2);
                            
                        }
                    }
                    
                }
            }
            
            if(!wsList.isEmpty()) {
                
                upsert wsList;
            }
            
        }
        
    }
}
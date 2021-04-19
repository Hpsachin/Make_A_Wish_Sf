trigger wishStatus on Wish__c (before insert, after insert, before update, after update) {
    
    Wish_Triggers__c wishTriggers = Wish_Triggers__c.getOrgDefaults();
    
    if(!wishTriggers.Disable_wishStatus__c) {
        
        if(Trigger.isInsert) {
            
            List<Wish_Stage_Tracking__c> wstList = new List<Wish_Stage_Tracking__c>();
            
            for(Wish__c w : Trigger.New) {
                
                if(w.Stage__c != null && w.Status__c != null) {
                    
                    if(Trigger.isBefore && w.Stage__c != null) {
                        
                        w.Stage_Status_Start_Date__c = System.Today();
                        
                    } else {
                        
                        Wish_Stage_Tracking__c wst = new Wish_Stage_Tracking__c();
                        
                        wst.Wish__c = w.Id;
                        wst.Stage__c = w.Stage__c;
                        wst.Stage_Status__c = w.Status__c;
                        wst.Stage_Status_Start_Date__c = System.Today();
                        wst.Stage_Status_Started_by__c = UserInfo.getUserId();
                        
                        wst.External_Id__c = w.Id + w.Stage__c + w.Status__c + System.today().year() + System.today().month() + System.today().day(); 
                        
                        wstList.add(wst);
                        
                    }
                }
            }
            
            if(!wstList.isEmpty())
                upsert wstList External_Id__c;
            
        } else {
            //Find previous Stage & Status
            Set<Id> wSet = new Set<Id>();
            List<Wish_Stage_Tracking__c> wstList = new List<Wish_Stage_Tracking__c>();
            
            for(Wish__c w : Trigger.New) {
                
                if(w.Stage__c != Trigger.oldMap.get(w.Id).Stage__c
                   || w.Status__c != Trigger.oldMap.get(w.Id).Status__c) {
                       wSet.add(w.Id);
                   }
                
            }
            
            System.Debug('wSet - ' + wSet);
            
            if(!wSet.isEmpty()) {
                
                Map<Id, Map<String, Wish_Stage_Tracking__c>> wMap = new Map<Id, Map<String, Wish_Stage_Tracking__c>>();
                
                for(Wish_Stage_Tracking__c wt : [SELECT Id, Wish__c, Stage__c, Stage_Status__c, Stage_Status_Start_Date__c, Stage_Status_End_Date__c FROM Wish_Stage_Tracking__c WHERE Wish__c IN :wSet]) {
                    
                    if(wMap.get(wt.Wish__c) == null)
                        wMap.put(wt.Wish__c, new Map<String, Wish_Stage_Tracking__c>());
                    
                    wMap.get(wt.Wish__c).put(wt.Stage__c +''+ wt.Stage_Status__c, wt);
                }
                
                for(Wish__c w : Trigger.New) {
                    
                    if(w.Stage__c != Trigger.oldMap.get(w.Id).Stage__c
                       || w.Status__c != Trigger.oldMap.get(w.Id).Status__c) {
                           
                           if(Trigger.isBefore && w.Stage__c != Trigger.oldMap.get(w.Id).Stage__c) {
                               
                               w.Stage_Status_Start_Date__c = System.Today();
                               
                           } else {
                               
                               Wish_Stage_Tracking__c wst = new Wish_Stage_Tracking__c();
                               
                               wst.Wish__c = w.Id;
                               wst.Stage__c = w.Stage__c;
                               wst.Stage_Status__c = w.Status__c;
                               wst.Stage_Status_Start_Date__c = System.Today();
                               wst.Stage_Status_Started_by__c = UserInfo.getUserId();
                               
                               wst.External_Id__c = w.Id + w.Stage__c + w.Status__c + System.today().year() + System.today().month() + System.today().day();
                               
                               wstList.add(wst);
                               
                               if(wMap.get(w.Id) != null) {
                                   
                                   String oldMapKey = Trigger.oldMap.get(w.Id).Stage__c +''+ Trigger.oldMap.get(w.Id).Status__c;
                                   
                                   if(wMap.get(w.Id).get(oldMapKey) != null) {
                                       
                                       Wish_Stage_Tracking__c ut = wMap.get(w.Id).get(oldMapKey);
                                       
                                       ut.Stage_Status_End_Date__c = System.Today();
                                       ut.Stage_Status_Completed_by__c = UserInfo.getUserId();
                                       
                                       if(ut.External_Id__c == null)
                                           ut.External_Id__c = ut.Wish__c + ut.Stage__c + ut.Stage_Status__c + ut.Stage_Status_Start_Date__c.year() + ut.Stage_Status_Start_Date__c.month() + ut.Stage_Status_Start_Date__c.day();
                                       
                                       wstList.add(ut);
                                   }
                               }
                               
                           }
                           
                       }
                }
                
                try {
                    
                    if(!wstList.isEmpty())
                        upsert wstList;
                    
                } catch(Exception e){
                    System.Debug(e);
                }
                
            }
        }
        
    }
    
}
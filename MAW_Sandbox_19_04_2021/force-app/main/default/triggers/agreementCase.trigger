trigger agreementCase on echosign_dev1__SIGN_Agreement__c (after insert, after update) {

    Set<Id> cSet = new Set<Id>();
    
    for(echosign_dev1__SIGN_Agreement__c a : Trigger.New) {
        
        if(a.echosign_dev1__Status__c == 'Signed') {
            
            cSet.add(a.Case__c);
        }
    }
    
    if(!cSet.isEmpty()) {
        
        Map<Id, Case> cMap = new Map<Id, Case>([SELECT Id, Status, Application_Consent_Received_Date_Time__c FROM Case WHERE Status = 'Awaiting Consent' AND Id IN :cSet]);
        
        if(!cMap.isEmpty()) {
            
            List<Case> updateCase = new List<Case>();
            
            for(echosign_dev1__SIGN_Agreement__c a : Trigger.New) {
                
                if(a.echosign_dev1__Status__c == 'Signed' && cMap.get(a.Case__c) != null) {
                    
                    Case c = cMap.get(a.Case__c);
                    
                    c.Status = 'Awaiting Starlight';
                    c.Application_Consent_Received_Date_Time__c = a.echosign_dev1__DateSigned__c;
                    
                    updateCase.add(c);
                }
            }
            
            if(!updateCase.isEmpty())
                update updateCase;
            
        }
        
    }

}
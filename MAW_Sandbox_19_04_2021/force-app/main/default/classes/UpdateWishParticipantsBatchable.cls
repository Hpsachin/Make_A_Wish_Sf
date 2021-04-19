/************************************************************************************************************
* @description  : Ticks the related wish participants' send annual survey field
* @author       : Salesfix - CI
* @date         : 2018-07-30
*************************************************************************************************************/
global class UpdateWishParticipantsBatchable implements Database.Batchable<sObject>{
    
    global String compareDate = '';
    
    global UpdateWishParticipantsBatchable(){
        Date queryDate = Date.today();
        this.compareDate = String.valueOf(queryDate).replace('00:00:00','');
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Next_Annual_Survey__c, (SELECT Id, Send_Annual_Survey__c FROM Celebrities__r)';
        query += ' FROM Wish__c WHERE (Next_Annual_Survey__c =' +compareDate+')';
        System.debug('@@@query: ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Wish__c> scope){
        if(!scope.isEmpty()){
            List<Wish_Participation__c> wishParticipantsUpdateList = new List<Wish_Participation__c>();
            for(Wish__c wishItem : scope){
                for(Wish_Participation__c participantItem : wishItem.Celebrities__r){
                    Wish_Participation__c wishParticipant = new Wish_Participation__c();
                    wishParticipant.Id = participantItem.Id;
                    wishParticipant.Send_Annual_Survey__c = true;
                    wishParticipantsUpdateList.add(wishParticipant);
                }
            }
            
            if(!wishParticipantsUpdateList.isEmpty()){
                update wishParticipantsUpdateList;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){

    }    
}
/************************************************************************************************************
* @description  : Schedulable class for UpdateWishParticipantsBatchable
* @author       : Salesfix - CI
* @date         : 2018-07-30
*************************************************************************************************************/
global class UpdateWishParticipantsSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
        UpdateWishParticipantsBatchable updateBatch = new UpdateWishParticipantsBatchable();
        Database.executebatch(updateBatch);
    }
}
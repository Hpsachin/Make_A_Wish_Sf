/************************************************************************************************************
* @description  : Test Class for UpdateWishParticipantsBatchable
* @author       : Salesfix - CI
* @date         : 2018-07-30
*************************************************************************************************************/
@isTest
private class UpdateWishParticipantsTest{
    @testSetup static void setupTestData(){
        Id wishParticipantVolunteerId = Schema.SObjectType.Wish_Participation__c.getRecordTypeInfosByName().get('External Participant').getRecordTypeId();
        
        Wish__c newWish = new Wish__c();
        newWish.Name = 'Test Wish';
        newWish.Next_Annual_Survey__c = Date.today();
        insert newWish;
        
        Wish_Participation__c newParticipation = new Wish_Participation__c();
        newParticipation.RecordTypeId = wishParticipantVolunteerId;
        newParticipation.User__c = UserInfo.getUserId();
        newParticipation.Wish_Name__c = newWish.Id;
        newParticipation.Type__c = 'Branch Volunteer';
        insert newParticipation;
    }
    
    @isTest static void UpdateSendAnnualCheckboxTest() {
        Test.startTest();
        //instantiate the schedulable class
        UpdateWishParticipantsSchedulable schJob = new UpdateWishParticipantsSchedulable();

        //create the cron expression
        Decimal hour= System.now().hour();
        Decimal minute= System.now().minute();
        String cronExp = '0 '+minute+' '+hour+' * * ?';

        //schedule the job
        String jobId = System.schedule('Test Job', cronExp, schJob);
        Test.stopTest();

        //select the scheduled job
        CronTrigger jobTriggered = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId LIMIT 1];
        
        //check the values
        System.assertEquals(cronExp, jobTriggered.CronExpression, 'Did not match');
        System.assertEquals(0, jobTriggered.TimesTriggered, 'Did not match');
    }
}
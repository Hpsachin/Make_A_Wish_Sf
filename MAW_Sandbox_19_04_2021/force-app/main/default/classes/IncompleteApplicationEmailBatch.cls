global class IncompleteApplicationEmailBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        try{
            Id recordId;
            recordId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary Contact').getRecordTypeId();
            String RecordTypeIdvalue = String.valueOf(recordId);
            String Query = 'SELECT Id, RecordTypeId, Name ,FirstName ,Child__c, Email , Application_Form_Completed__c FROM Contact Where RecordTypeId =: recordId AND Application_Form_Completed__c != 100  AND Email != Null And Application_Form_Completed__c > 0 LIMIT 10';
            return Database.getQueryLocator(Query);
        }
        catch(Exception e){
            System.debug('The error is '+e.getMessage()+' in line number '+e.getLineNumber());
            return null;
        }
    }
    global void execute(Database.BatchableContext bc, List<Contact> contactList){
        try{
            if(contactList.size() > 0){
                String userName = UserInfo.getUserName();
                EmailTemplate et = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body FROM EmailTemplate WHERE Name = 'Incomplete Form Reminder'];
                List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
                for(Contact contactObj :contactList){
                    List<String> sendEmail = new List<String>();
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    sendEmail.add(contactObj.Email);
                    message.toAddresses = new String[] {contactObj.Email};
                        message.setTargetObjectId(contactObj.Id);
                    message.setTreatTargetObjectAsRecipient(false);
                    message.setTemplateId(et.Id);
                    message.setSubject(et.subject);
                    message.setHTMLBody(et.Body + contactObj.Email );
                    messages.add(message);
                }
                Messaging.sendEmail(messages);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
                if(results[0].success){
                    System.debug('The email was sent successfully.');
                }
                else{
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
            } 
        }
        catch(Exception e){
            System.debug('The error is '+e.getMessage()+' in line number '+e.getLineNumber());
        }
    }
    global void finish(Database.BatchableContext bc){
        try{
            System.debug('FINISH');
        } 
        catch(Exception e){
            System.debug('The error is '+e.getMessage()+' in line number '+e.getLineNumber());
        }
    }
}
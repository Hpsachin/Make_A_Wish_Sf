public class SendEmailClass {
    public static void sendEmailMethod(String templateName, Contact contactObj){
        try{
            if(templateName != null && String.isNotBlank(templateName) && String.isNotEmpty(templateName) && contactObj != null && contactObj.Id != null && contactObj.Email != null){
                List<EmailTemplate>  emailTemplateList = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name =: templateName LIMIT 1];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                if(emailTemplateList.size() > 0 && emailTemplateList[0].Id != null){
                    message.setTemplateID(emailTemplateList[0].Id);
                    if(templateName == 'Forget Password'){
                        Task newTask = new Task();
                        newTask.Subject = emailTemplateList[0].Subject;
                        newTask.Status = 'In Progress';
                        newTask.Priority = 'Normal';
                        newTask.ActivityDate = Date.today();
                        newTask.WhoId = contactObj.ID;
                        newTask.OwnerId = contactObj.OwnerId;
                        insert newTask;
                        
                        emailTemplateList[0].Body = emailTemplateList[0].Body.replace('{!Contact.Name}', contactObj.Name);
                        if(contactObj.RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId())
                            emailTemplateList[0].Body = emailTemplateList[0].Body.replace('{resetURL}', '?role=Medical_Specialist&id=' + newTask.Id);
                        else if(contactObj.RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId())
                            emailTemplateList[0].Body = emailTemplateList[0].Body.replace('{resetURL}', '?role=Social_Worker&id=' + newTask.Id);
                        message.setHtmlBody(emailTemplateList[0].Body);
                        message.setSubject(emailTemplateList[0].Subject);
                    }
                    message.toAddresses = new String[] {contactObj.Email};
                        message.setTargetObjectId(contactObj.Id);
                    message.setTreatTargetObjectAsRecipient(false);
                    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    System.debug(messages);
                    if(results.size() > 0 && results[0].success)
                        System.debug('The email was sent successfully.');
                    else
                        System.debug('The email failed to send: ' +  results[0].errors[0].message);
                }
            }
        }
        catch(Exception e){
            System.debug('The error is :: ' + e.getMessage() + ' in line ' + e.getLineNumber());
        }
    }
    
    public static void sendEmailMethod1(String templateName, Case caseObj, String emailId){
        try{
            if(templateName != null && String.isNotBlank(templateName) && String.isNotEmpty(templateName) && caseObj != null && caseObj.Id != null){
                List<EmailTemplate>  emailTemplateList = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name =: templateName LIMIT 1];
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                if(emailTemplateList.size() > 0 && emailTemplateList[0].Id != null){
                    message = Messaging.renderStoredEmailTemplate(emailTemplateList[0].Id, null, caseObj.Id);
                    message.toAddresses = new String[] {emailId};
                        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    if(results.size() > 0 && results[0].success)
                        System.debug('The email was sent successfully.');
                    else
                        System.debug('The email failed to send: ' +  results[0].errors[0].message);
                }
            }
        }
        catch(Exception e){
            System.debug('The error is :: ' + e.getMessage() + ' in line ' + e.getLineNumber());
        }
    }
    
    public static EmailTemplate getEmailTemplate(String templateName){
        try{
            if(templateName != null && String.isNotBlank(templateName) && String.isNotEmpty(templateName)){
                List<EmailTemplate>  emailTemplateList = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name =: templateName LIMIT 1];
                if(emailTemplateList.size() > 0 && emailTemplateList[0].Id != null)
                    return emailTemplateList[0];
            }
        }
        catch(Exception e){
            System.debug('The error is :: ' + e.getMessage() + ' in line ' + e.getLineNumber());
        }
        return null;
    }
}
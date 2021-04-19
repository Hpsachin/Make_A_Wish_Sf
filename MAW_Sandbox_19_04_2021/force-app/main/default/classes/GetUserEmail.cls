public class GetUserEmail {
    
    @AuraEnabled
    public static User getUserEmailIdAndName(){
        try{
            User userList = new User();
            userList = [SELECT Id,Name,Email FROM User WHERE Id =: UserInfo.getUserId()];
            return userList ;
        }
        catch(Exception e){
            System.debug('Exception in line number'+e.getLineNumber()+'Exception in code'+e.getCause());  
        }
        return null;
    }
    
    @AuraEnabled 
    public static List<ContentDocument> getAttachmentList(){
        try{
            List<ContentDocument>  contentDocumentList = new List<ContentDocument>();
            contentDocumentList = [SELECT Title, ContentModifiedDate, ContentSize, Description, FileExtension, FileType FROM ContentDocument];
            if(contentDocumentList.size()>0){
                return contentDocumentList;
            }else{
                return null;
            }
        }
        catch(Exception e){
            System.debug('Exception in line number'+e.getLineNumber()+'Exception in code'+e.getCause());  
        }
        return null;
    }
    
    @AuraEnabled 
    public static List<ContentDocument> findByTitle(String searchKey){
        try{
            if(searchKey.length() >0){
                String title= '%' + searchKey + '%';
                List<ContentDocument>  contentDocumentList = new List<ContentDocument>();
                contentDocumentList = [SELECT Title, ContentModifiedDate, ContentSize, Description, FileExtension, FileType
                                       FROM ContentDocument WHERE Title LIKE :title];
                return contentDocumentList;  
            }
            
        }
        catch(Exception e){
            System.debug('Exception in line number'+e.getLineNumber()+'Exception in code'+e.getCause());  
        }
        return null;
    }
    
    @AuraEnabled 
    public static void sendMailMethod(List<String> mailTo, String mSubject ,String mbody, List<String> attachmentFileId){
        try{
            List<ContentVersion> contentVersionList = new List<ContentVersion>();
            List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
            
            Set<Id> documentId = new Set<Id>();
            if(attachmentFileId.size()>0){
                for(String obj :attachmentFileId){
                    documentId.add(obj);
                } 
            }
            if(documentId.size()>0){
                contentVersionList = [SELECT VersionData,Title,FileExtension FROM ContentVersion WHERE ContentDocumentId In :documentId AND IsLatest = true] ; 
            }
            if(contentVersionList.size()>0){
                for(ContentVersion fileobj : contentVersionList){
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.filename = fileobj.Title + '.' + fileobj.FileExtension;
                    attach.body = fileobj.VersionData;
                    attachmentList.add(attach);
                }
            }
            
            
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // Step 2: Set list of people who should get the email
            mail.setToAddresses(mailTo);
            // Step 3: Set who the email is sent from
            mail.setFileAttachments(attachmentList);
            // Step 4. Set email contents - you can use variables! 
            mail.setSubject(mSubject);
            mail.setHtmlBody(mbody);
            // Step 5. Add your email to the master list
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
        catch(Exception e){
            System.debug('The error is '+e.getMessage()+' in line '+e.getLineNumber());
        }
    }
    
    @AuraEnabled
    public static EmailTemplateAndEmailWrap getTemplate(String role){
        try{
            if(role != null && String.isNotBlank(role) && String.isNotEmpty(role)){
                EmailTemplateAndEmailWrap emailWrapperobj = new EmailTemplateAndEmailWrap(); 
                List<Contact> contactList = new List<Contact>();
                Set<String> emailIdSet = new Set<String>();
                Id RecordTypeIdValue = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(role).getRecordTypeId();
                contactList = [SELECT Id, Name, Email, Phone, Hospital__c, Hospital_Department__c FROM Contact WHERE Email != null  AND RecordTypeId =: RecordTypeIdValue LIMIT 50000];
                System.debug('contactList=====>'+contactList);
                for(Contact contactObj : contactList){
                    emailIdSet.add(contactObj.Email);
                }
                if(emailIdSet.size() > 0 && emailIdSet != null){
                    emailWrapperobj.emailSet = emailIdSet;
                }
                EmailTemplate newEmailTemplate;
                if(role == 'Medical Specialist')
                    newEmailTemplate = SendEmailClass.getEmailTemplate('Medical Professional Signup Invite');
                else if(role == 'Social Worker')
                    newEmailTemplate = SendEmailClass.getEmailTemplate('Social Worker Signup Invite');
                
                if(newEmailTemplate != null){
                    emailWrapperobj.emailTemplateData = newEmailTemplate;
                    return emailWrapperobj;
                }
            }
        }
        catch(Exception e){
            System.debug('The error is '+e.getMessage()+' in line '+e.getLineNumber());
        }
        return null;
    }
    
    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class EmailTemplateAndEmailWrap{
        @AuraEnabled
        public EmailTemplate emailTemplateData{get;set;}
        @AuraEnabled
        public Set<String> emailSet{get;set;}
    }
    
}
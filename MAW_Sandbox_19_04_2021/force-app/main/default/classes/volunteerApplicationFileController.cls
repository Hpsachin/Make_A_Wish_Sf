public class volunteerApplicationFileController {

    public Boolean closeForm { get { return closeForm == null ? false : closeForm; } set;}
    public String cId {get;set;}
    public String extId {get;set;}
    public Form__c eoi {get;set;}
    
    public volunteerApplicationFileController() {
        
        String eId = ApexPages.currentPage().getParameters().get('v');
        
        if(eId == null) {
            closeForm = true;
        } else {
            
            List<Form__c> fList = new List<Form__c>([SELECT Contact__c, Contact__r.External_Id__c, Volunteer_Application_Status__c FROM Form__c WHERE Id = :eId]);
            
            if(fList.isEmpty()) {
                closeForm = true;
            } else {
                
                eoi = fList[0];
                cId = eoi.Contact__c;
                extId = eoi.Contact__r.External_Id__c;
            }
        }
            
        
    }    
    
    @RemoteAction
    public static String doUploadAttachment(String cId, String attachmentBody, String attachmentName, String attachmentId) {
        if(cId != null) {
            if(attachmentBody != null) {
                Attachment att = getAttachment(attachmentId);
                String newBody = '';
                if(att.Body != null) {
                    newBody = EncodingUtil.base64Encode(att.Body);
                }
                newBody += attachmentBody;
                att.Body = EncodingUtil.base64Decode(newBody);
                if(attachmentId == null) {
                    att.Name = attachmentName;
                    att.parentId = cId;
                }
                upsert att;
                return att.Id;
            } else {
                return 'Attachment Body was null';
            }
        } else {
            return 'Contact Id was null';
        }
    }
     
  

    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
    
    public pageReference confirmFiles() {
        
        eoi.Volunteer_Application_Status__c = 'Documents Submitted';
        update eoi;
        
        Contact v = new Contact();
        
        v.External_Id__c = extId;
        v.Volunteer_App_Status__c = 'Volunteer Application Complete';
        
        upsert v External_Id__c;
       
        
        //redirect to confrim page
        pageReference pageRef = Page.volunteerApplicationStageConfirm;
        pageRef.setRedirect(true);
        pageRef.getParameters().put('id', cId);
        
        return pageRef;
    }

}
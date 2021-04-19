public class ShowAllRecordsController {
    @AuraEnabled
    public static ContactWrapper showAllRecordApex(String selectedRecordType, String caseId){
        try{
            if(selectedRecordType != null && String.isNotBlank(selectedRecordType) && String.isNotEmpty(selectedRecordType) && caseId != null && String.isNotBlank(caseId) && String.isNotEmpty(caseId)){
                List<Case> caseList = new List<Case>();
                Set<String> idSet = new Set<String>();
                List<Associated_MP_SW__c> existingAssociatedList = new List<Associated_MP_SW__c>();
                
                existingAssociatedList = [SELECT Id, Individual__c FROM Associated_MP_SW__c WHERE Case__c =: caseId AND Role__c =: selectedRecordType LIMIT 10000];
                
                for(Associated_MP_SW__c each : existingAssociatedList){
                    idSet.add(each.Individual__c);
                }
                
                caseList = [SELECT MP_First_Name__c, MP_Surname__c, MP_Email__c, SW_Email__c, Medical_Professional__c, SW_First_Name__c, SW_Surname__c, Social_Worker__c  FROM Case WHERE Id =: caseId LIMIT 1];
                if(selectedRecordType == 'Medical Specialist' && caseList.size() > 0){
                    String recordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
                    List<Contact> contactList = new List<Contact>();
                    contactList = [SELECT Id, Email, Name FROM Contact WHERE RecordTypeId =: recordType AND Id !=: caseList[0].Medical_Professional__c AND Email != null ORDER BY Name LIMIT 30000];
                    if(contactList != null && contactList.size() > 0){
                        ContactWrapper contactWrapperObj = new ContactWrapper();
                        contactWrapperObj.ContactList = contactList;
                        contactWrapperObj.IdSet = idSet;
                        String name;
                        if(caseList[0].MP_First_Name__c != null && caseList[0].MP_Surname__c != null)
                            name = caseList[0].MP_First_Name__c + ' ' + caseList[0].MP_Surname__c;
                        else if(caseList[0].MP_First_Name__c != null && caseList[0].MP_Surname__c == null)
                            name = caseList[0].MP_First_Name__c;
                        else if(caseList[0].MP_First_Name__c == null && caseList[0].MP_Surname__c != null)
                            name = caseList[0].MP_Surname__c;
                        else
                            name = null;
                        contactWrapperObj.LookupName = name;
                        return contactWrapperObj;
                    }
                    return null;
                }
                else if (selectedRecordType == 'Social Worker' && caseList.size() > 0) {
                    String recordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
                    List<Contact> contactList = [SELECT Id, Email, Name FROM Contact WHERE RecordTypeId = :recordType AND Id !=: caseList[0].Social_Worker__c AND Email != null ORDER BY Name LIMIT 30000];
                    if(contactList != null && contactList.size() > 0){
                        ContactWrapper contactWrapperObj = new ContactWrapper();
                        contactWrapperObj.ContactList = contactList;
                        contactWrapperObj.IdSet = idSet;
                        String name;
                        if(caseList[0].SW_First_Name__c != null && caseList[0].SW_Surname__c != null)
                            name = caseList[0].SW_First_Name__c + ' ' + caseList[0].SW_Surname__c;
                        else if(caseList[0].SW_First_Name__c != null && caseList[0].SW_Surname__c == null)
                            name = caseList[0].SW_First_Name__c;
                        else if(caseList[0].SW_First_Name__c == null && caseList[0].SW_Surname__c != null)
                            name = caseList[0].SW_Surname__c;
                        else
                            name = null;
                        contactWrapperObj.LookupName = name;
                        return contactWrapperObj;
                    }
                    return null;
                }
            }
            return null;
        }
        catch(Exception e){
            System.debug('Exception: '+e.getMessage() +' At Line: '+e.getLineNumber());
            return null;
        }
    }
    
    @AuraEnabled
    public static void saveApex(List<String> stringOfIds , String selectedValue, String caseId){
        try{
            List<Associated_MP_SW__c> existingAssociatedList = new List<Associated_MP_SW__c>();
            List<Associated_MP_SW__c> associatedList = new List<Associated_MP_SW__c>();
            Map<Id, Associated_MP_SW__c> contactIdVsAssociatedMPSWMap = new Map<Id, Associated_MP_SW__c>();
            
            if(caseId != null && String.isNotBlank(caseId) && String.isNotEmpty(caseId) && selectedValue != null && String.isNotBlank(selectedValue) && String.isNotEmpty(selectedValue)){
                existingAssociatedList = [SELECT Id, Individual__c FROM Associated_MP_SW__c WHERE Case__c =: caseId AND Role__c =: selectedValue LIMIT 10000];
                for(Associated_MP_SW__c each : existingAssociatedList){
                    contactIdVsAssociatedMPSWMap.put(each.Individual__c, each);
                }
                if(selectedValue == 'Medical Specialist'){
                    for(String str : stringOfIds){
                        if(contactIdVsAssociatedMPSWMap.containsKey(str)){
                            contactIdVsAssociatedMPSWMap.remove(str);
                            continue;
                        }
                        Associated_MP_SW__c associatedObj = new Associated_MP_SW__c();
                        associatedObj.Role__c = 'Medical Specialist';
                        associatedObj.Case__c = caseId;
                        associatedObj.Individual__c = str;
                        associatedList.add(associatedObj);
                    }
                }
                else if(selectedValue == 'Social Worker') {
                    for(String str : stringOfIds){
                        if(contactIdVsAssociatedMPSWMap.containsKey(str)){
                            contactIdVsAssociatedMPSWMap.remove(str);
                            continue;
                        }
                        Associated_MP_SW__c associatedObj = new Associated_MP_SW__c();
                        associatedObj.Role__c = 'Social Worker';
                        associatedObj.Case__c = caseId;
                        associatedObj.Individual__c = Id.valueOf(str);
                        associatedList.add(associatedObj);
                    }
                }
                if(associatedList.size() > 0)
                    insert associatedList;
                if(contactIdVsAssociatedMPSWMap.size() > 0){
                    database.delete(contactIdVsAssociatedMPSWMap.values(), false);
                }
            }
        }
        catch(Exception e){
            System.debug('Exception: '+e.getMessage() +' At Line: '+e.getLineNumber());
        }
    }
    
    public class ContactWrapper{
        @AuraEnabled public List<Contact> ContactList {get;set;}
        @AuraEnabled public Set<String> IdSet {get;set;}
        @AuraEnabled public String LookupName {get;set;}
    }
}
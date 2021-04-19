@RestResource(urlMapping='/Test/*')
global without sharing class Test {
    @HttpPut
    global static void DynamicFormSaveDetails() {
        try{
            RestRequest request = RestContext.request;
            String xmlString = request.requestBody.toString();
            String applicationNo = RestContext.request.params.get('applicationNo');
            String formCompleted = RestContext.request.params.get('formCompleted');
            
            System.debug(applicationNo);
            
            List<Case> caseList = new List<Case>();
            /*, C_First_Name__c, C_Last_Name__c, C_Gender__c, C_DOB__c, C_Address__c, C_City__c, C_State__c, C_Postcode__c, Relationship_to_child__c, PC_First_Name__c, PC_Surname__c, PC_Phone__c, PC_Secondary_Phone__c,  PC_Gender__c, PC_DOB__c, PC_Address__c, PC_State__c, PC_Postcode__c*/
            caseList = [SELECT Id, Form_Completed__c, R_First_Name__c, R_Surname__c,Referal_Signature__c,Primary_Contact_Signature__c,Medical_Professional_Signature__c, R_Phone__c, R_Email__c, CaseNumber, C_First_Name__c FROM Case WHERE CaseNumber =: applicationNo LIMIT 1];
            
            
            List<Application_Participant__c> applicationParticipantList = new List<Application_Participant__c>();
            if(caseList.size() > 0)
                applicationParticipantList = [SELECT Id FROM Application_Participant__c WHERE Case__c =: caseList[0].Id];
            
            DynamicFormWrapper dynamicFormWrapperObj = (DynamicFormWrapper) System.JSON.deserialize(xmlString, DynamicFormWrapper.class);
            System.debug('dynamicFormWrapperObj --->>>> '+dynamicFormWrapperObj);
            
            Case newCaseObj = new Case();
            
            List<Application_Participant__c> newApplicationParticipantList = new List<Application_Participant__c>();
            
            Integer i = 1, socialWorkerCount = 0, doctorCount = 0;
            
            String message;
            
            Set<String> usedFields = new Set<String>();
            Set<String> savedScreen = new Set<String>();
            
            Contact doctorContactObj = new Contact();
            Contact socialWorkerContactObj = new Contact();
            Contact contactObj = new Contact();
            
            if(caseList.size() > 0){
                if(dynamicFormWrapperObj.Mother != null && (dynamicFormWrapperObj.Mother).size() > 0 && dynamicFormWrapperObj.Mother[0].innerfield != null 
                   && (dynamicFormWrapperObj.Mother[0].innerfield).size() > 0 && dynamicFormWrapperObj.Mother[0].innerfield[0].value != ''){
                       for(DynamicFormWrapper.Mother motherObj : dynamicFormWrapperObj.Mother){
                           if(motherObj.innerfield != new List<DynamicFormWrapper.innerfield>() && motherObj.innerfield != null){
                               DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = DynamicFormRest.saveFieldsDetails(newCaseObj, caseList, motherObj.innerfield, usedFields);
                               newCaseObj = innerfieldDataWrapperObj.newCaseObj;
                               caseList = innerfieldDataWrapperObj.caseList;
                               usedFields = innerfieldDataWrapperObj.usedFields;
                           }
                           if(motherObj.saved)
                               savedScreen.add(motherObj.title);
                       }
                   }
                else if(dynamicFormWrapperObj.Father != null && (dynamicFormWrapperObj.Father).size() > 0 && dynamicFormWrapperObj.Father[0].innerfield != null 
                        && (dynamicFormWrapperObj.Father[0].innerfield).size() > 0 && dynamicFormWrapperObj.Father[0].innerfield[0].value != ''){
                            for(DynamicFormWrapper.Father fatherObj : dynamicFormWrapperObj.Father){
                                if(fatherObj.innerfield != new List<DynamicFormWrapper.innerfield>()){
                                    DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = DynamicFormRest.saveFieldsDetails(newCaseObj, caseList, fatherObj.innerfield, usedFields);
                                    newCaseObj = innerfieldDataWrapperObj.newCaseObj;
                                    caseList = innerfieldDataWrapperObj.caseList;
                                    usedFields = innerfieldDataWrapperObj.usedFields;
                                }
                                if(fatherObj.saved)
                                    savedScreen.add(fatherObj.title);
                            }
                        }
                else if(dynamicFormWrapperObj.Legal_Guardian != null && (dynamicFormWrapperObj.Legal_Guardian).size() > 0 
                        && dynamicFormWrapperObj.Legal_Guardian[0].innerfield != null && (dynamicFormWrapperObj.Legal_Guardian[0].innerfield).size() > 0 
                        && dynamicFormWrapperObj.Legal_Guardian[0].innerfield[0].value != ''){
                            for(DynamicFormWrapper.Legal_Guardian legalGuardianObj : dynamicFormWrapperObj.Legal_Guardian){
                                if(legalGuardianObj.innerfield != new List<DynamicFormWrapper.innerfield>()){
                                    DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = DynamicFormRest.saveFieldsDetails(newCaseObj, caseList, legalGuardianObj.innerfield, usedFields);
                                    newCaseObj = innerfieldDataWrapperObj.newCaseObj;
                                    caseList = innerfieldDataWrapperObj.caseList;
                                    usedFields = innerfieldDataWrapperObj.usedFields;
                                }
                                if(legalGuardianObj.saved)
                                    savedScreen.add(legalGuardianObj.title);
                            }
                        }
                else if(dynamicFormWrapperObj.Social_Worker != null && (dynamicFormWrapperObj.Social_Worker).size() > 0 
                        && dynamicFormWrapperObj.Social_Worker[0].innerfield != null && (dynamicFormWrapperObj.Social_Worker[0].innerfield).size() > 0 
                        && dynamicFormWrapperObj.Social_Worker[0].innerfield[0].value != ''){
                            for(DynamicFormWrapper.Social_Worker socialWorkerObj : dynamicFormWrapperObj.Social_Worker){
                                if(socialWorkerObj.innerfield != new List<DynamicFormWrapper.innerfield>()){
                                    DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = DynamicFormRest.saveFieldsDetails(newCaseObj, caseList, socialWorkerObj.innerfield, usedFields);
                                    newCaseObj = innerfieldDataWrapperObj.newCaseObj;
                                    caseList = innerfieldDataWrapperObj.caseList;
                                    usedFields = innerfieldDataWrapperObj.usedFields;
                                }
                                if(socialWorkerObj.saved)
                                    savedScreen.add(socialWorkerObj.title);
                            }
                        }
                else if(dynamicFormWrapperObj.Case_Worker != null && (dynamicFormWrapperObj.Case_Worker).size() > 0 
                        && dynamicFormWrapperObj.Case_Worker[0].innerfield != null && (dynamicFormWrapperObj.Case_Worker[0].innerfield).size() > 0 
                        && dynamicFormWrapperObj.Case_Worker[0].innerfield[0].value != ''){
                            for(DynamicFormWrapper.Case_Worker caseWorkerObj : dynamicFormWrapperObj.Case_Worker){
                                if(caseWorkerObj.innerfield != new List<DynamicFormWrapper.innerfield>()){
                                    DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = DynamicFormRest.saveFieldsDetails(newCaseObj, caseList, caseWorkerObj.innerfield, usedFields);
                                    newCaseObj = innerfieldDataWrapperObj.newCaseObj;
                                    caseList = innerfieldDataWrapperObj.caseList;
                                    usedFields = innerfieldDataWrapperObj.usedFields;
                                }
                                if(caseWorkerObj.saved)
                                    savedScreen.add(caseWorkerObj.title);
                            }
                        }
                else if(dynamicFormWrapperObj.Doctor != null && (dynamicFormWrapperObj.Doctor).size() > 0 && dynamicFormWrapperObj.Doctor[0].innerfield != null 
                        && (dynamicFormWrapperObj.Doctor[0].innerfield).size() > 0 && dynamicFormWrapperObj.Doctor[0].innerfield[0].value != ''){
                            for(DynamicFormWrapper.Doctor doctorObj : dynamicFormWrapperObj.Doctor){
                                if(doctorObj.innerfield != new List<DynamicFormWrapper.innerfield>()){
                                    DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = DynamicFormRest.saveFieldsDetails(newCaseObj, caseList, doctorObj.innerfield, usedFields);
                                    newCaseObj = innerfieldDataWrapperObj.newCaseObj;
                                    caseList = innerfieldDataWrapperObj.caseList;
                                    usedFields = innerfieldDataWrapperObj.usedFields;
                                }
                                if(doctorObj.saved)
                                    savedScreen.add(doctorObj.title);
                            }
                        }
                else if(dynamicFormWrapperObj.Child != null && (dynamicFormWrapperObj.Child).size() > 0 && dynamicFormWrapperObj.Child[0].innerfield != null 
                        && (dynamicFormWrapperObj.Child[0].innerfield).size() > 0 && dynamicFormWrapperObj.Child[0].innerfield[0].value != ''){
                            for(DynamicFormWrapper.Child childObj : dynamicFormWrapperObj.Child){
                                if(childObj.innerfield != new List<DynamicFormWrapper.innerfield>()){
                                    DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = DynamicFormRest.saveFieldsDetails(newCaseObj, caseList, childObj.innerfield, usedFields);
                                    newCaseObj = innerfieldDataWrapperObj.newCaseObj;
                                    caseList = innerfieldDataWrapperObj.caseList;
                                    usedFields = innerfieldDataWrapperObj.usedFields;
                                }
                                if(childObj.saved)
                                    savedScreen.add(childObj.title);
                            }
                            if(newCaseObj != null){
                                newCaseObj.C_First_Name__c = caseList[0].R_First_Name__c;
                                newCaseObj.C_Last_Name__c = caseList[0].R_Surname__c;
                            }
                        }
                else if(dynamicFormWrapperObj.Family_Members != null && (dynamicFormWrapperObj.Family_Members).size() > 0 
                        && dynamicFormWrapperObj.Family_Members[0].innerfield != null && (dynamicFormWrapperObj.Family_Members[0].innerfield).size() > 0 
                        && dynamicFormWrapperObj.Family_Members[0].innerfield[0].value != null && dynamicFormWrapperObj.Family_Members[0].innerfield[0].value != ''){
                            for(DynamicFormWrapper.Family_Members familyMembersObj : dynamicFormWrapperObj.Family_Members){
                                if(familyMembersObj.innerfield != new List<DynamicFormWrapper.innerfield>()){
                                    DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = DynamicFormRest.saveFieldsDetails(newCaseObj, caseList, familyMembersObj.innerfield, usedFields);
                                    newCaseObj = innerfieldDataWrapperObj.newCaseObj;
                                    caseList = innerfieldDataWrapperObj.caseList;
                                    usedFields = innerfieldDataWrapperObj.usedFields;
                                }
                                if(familyMembersObj.saved)
                                    savedScreen.add(familyMembersObj.title);
                            }
                        }
                else{
                    message = 'No relationship is mentioned on the record.';
                }
                
                
                if(dynamicFormWrapperObj.Family != null && (dynamicFormWrapperObj.Family).size() > 0){
                    Integer k = 0;
                    for(DynamicFormWrapper.Family familyObj : dynamicFormWrapperObj.Family){
                        Application_Participant__c applicationParticipantObj = new Application_Participant__c();
                        if(k < applicationParticipantList.size()){
                            applicationParticipantObj.Id = applicationParticipantList[k].Id;
                        }
                        if(familyObj.firstName != null && familyObj.firstName != '' &&  String.isNotEmpty(familyObj.firstName) && String.isNotBlank(familyObj.firstName))
                            applicationParticipantObj.First_Name__c = familyObj.firstName;
                        if(familyObj.lastName != null && familyObj.lastName != '' &&  String.isNotEmpty(familyObj.lastName) && String.isNotBlank(familyObj.lastName))
                            applicationParticipantObj.Surname__c = familyObj.lastName;
                        if(familyObj.gender != null && familyObj.gender != '' &&  String.isNotEmpty(familyObj.gender) && String.isNotBlank(familyObj.gender))
                            applicationParticipantObj.Gender__c = familyObj.gender;
                        if(familyObj.dob != null && familyObj.dob != '' &&  String.isNotEmpty(familyObj.dob) && String.isNotBlank(familyObj.dob))
                            applicationParticipantObj.Birthdate__c = Date.valueOf(familyObj.dob);
                        if(familyObj.relation != null && familyObj.relation != '' &&  String.isNotEmpty(familyObj.relation) && String.isNotBlank(familyObj.relation))
                            applicationParticipantObj.Relationship__c = familyObj.relation;
                        if(applicationParticipantObj.Surname__c != null && applicationParticipantObj.Surname__c != ''){
                            applicationParticipantObj.Case__c = newCaseObj.Id;
                            newApplicationParticipantList.add(applicationParticipantObj);
                        }
                        k++;
                    }
                }
                
                Integer count = 0;
                
                List<Application_Participant__c> applicationParticipantDeleteList = new List<Application_Participant__c>();
                
                for(Application_Participant__c appObj : applicationParticipantList){
                    count = 0;
                    for(Application_Participant__c newAppObj : newApplicationParticipantList){
                        if(newAppObj.Id != null){
                            if(newAppObj.Id == appObj.Id){
                                count++;
                                break;
                            }
                        }
                    }
                    if(count == 0)
                        applicationParticipantDeleteList.add(appObj);
                }
                
                delete applicationParticipantDeleteList;
                
                if(newCaseObj != null){
                    if(newCaseObj.MP_First_Name__c != null)
                        doctorContactObj.FirstName = newCaseObj.MP_First_Name__c;
                    if(newCaseObj.MP_Surname__c != null)
                        doctorContactObj.LastName = newCaseObj.MP_Surname__c;
                    if(newCaseObj.MP_Title__c != null)
                        doctorContactObj.Salutation = newCaseObj.MP_Title__c;
                    if(newCaseObj.MP_Phone__c != null)
                        doctorContactObj.Phone = newCaseObj.MP_Phone__c;
                    if(newCaseObj.MP_Email__c != null)
                        doctorContactObj.Email = newCaseObj.MP_Email__c;
                    if(newCaseObj.MP_Hospital__c != null)
                        doctorContactObj.Hospital__c = newCaseObj.MP_Hospital__c;
                    if(newCaseObj.MP_Department__c != null)
                        doctorContactObj.Hospital_Department__c = newCaseObj.MP_Department__c;
                    doctorContactObj.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId();
                    
                    if(newCaseObj.SW_First_Name__c != null)
                        socialWorkerContactObj.FirstName = newCaseObj.SW_First_Name__c;
                    if(newCaseObj.SW_Surname__c != null)
                        socialWorkerContactObj.LastName = newCaseObj.SW_Surname__c;
                    if(newCaseObj.SW_Title__c != null)
                        socialWorkerContactObj.Salutation = newCaseObj.SW_Title__c;
                    if(newCaseObj.SW_Phone__c != null)
                        socialWorkerContactObj.Phone = newCaseObj.SW_Phone__c;
                    if(newCaseObj.SW_Email__c != null)
                        socialWorkerContactObj.Email = newCaseObj.SW_Email__c;
                    if(newCaseObj.SW_Hospital__c != null)
                        socialWorkerContactObj.Hospital__c = newCaseObj.SW_Hospital__c;
                    socialWorkerContactObj.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId();
                }
                
                if(dynamicFormWrapperObj.AnyMedicalConditionSpecification != null && String.isNotBlank(dynamicFormWrapperObj.AnyMedicalConditionSpecification) && String.isNotEmpty(dynamicFormWrapperObj.AnyMedicalConditionSpecification))
                    newCaseObj.Specification_Related_Medical_Condition__c = dynamicFormWrapperObj.AnyMedicalConditionSpecification;
                if(dynamicFormWrapperObj.AnyWishSpecification != null && String.isNotBlank(dynamicFormWrapperObj.AnyWishSpecification) && String.isNotEmpty(dynamicFormWrapperObj.AnyWishSpecification))
                    newCaseObj.Specification_Related_Wish__c = dynamicFormWrapperObj.AnyWishSpecification;
                if(dynamicFormWrapperObj.ChildsCondition != null && String.isNotBlank(dynamicFormWrapperObj.ChildsCondition) && String.isNotEmpty(dynamicFormWrapperObj.ChildsCondition))
                    newCaseObj.Child_Condition_by_Doctor__c = dynamicFormWrapperObj.ChildsCondition;
                if(dynamicFormWrapperObj.FitForWish != null && String.isNotBlank(dynamicFormWrapperObj.FitForWish) && String.isNotEmpty(dynamicFormWrapperObj.FitForWish)){
                    if(dynamicFormWrapperObj.FitForWish == 'Yes'){
                        newCaseObj.Fit_For_Wish__c = true;
                        usedFields.add('Fit_For_Wish__c');
                        WishClass.convert(caseList[0].Id);
                        SendEmailClass.sendEmailMethod1('Application Form Approved', newCaseObj, newCaseObj.R_Email__c);
                    }
                    else if(dynamicFormWrapperObj.FitForWish == 'No'){
                        newCaseObj.Fit_For_Wish__c = false;
                        newCaseObj.Status = 'Rejected';
                        usedFields.add('Fit_For_Wish__c');
                        SendEmailClass.sendEmailMethod1('Application Form Rejected', newCaseObj, newCaseObj.R_Email__c);
                    }
                }
            }
            
            List<Contact> existingSocialWorkerList = new List<Contact>();
            List<Contact> existingDoctorList = new List<Contact>();
            List<Contact> newContactList = new List<Contact>();
            
            
            if(socialWorkerContactObj != null && socialWorkerContactObj != contactObj){
                if(socialWorkerContactObj.Email != null && String.isNotBlank(socialWorkerContactObj.Email) && String.isNotEmpty(socialWorkerContactObj.Email))
                    existingSocialWorkerList = [SELECT Id, Salutation, FirstName, LastName, Email, Phone, Hospital__c, Hospital_Department__c FROM Contact 
                                                WHERE RecordTypeId =: Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Social Worker').getRecordTypeId() 
                                                AND Email =: socialWorkerContactObj.Email LIMIT 1];
                System.debug(existingSocialWorkerList.size());
                if(existingSocialWorkerList.size() == 0){
                    if(socialWorkerContactObj.Id != null || socialWorkerContactObj.LastName != null){
                        if(socialWorkerContactObj.Id != null && socialWorkerContactObj.LastName == null)
                            delete socialWorkerContactObj;
                        else{
                            newContactList.add(socialWorkerContactObj);
                        }
                    }
                }
                else if(existingSocialWorkerList.size() > 0){
                    socialWorkerCount++;
                    socialWorkerContactObj = new Contact();
                    socialWorkerContactObj.Id = existingSocialWorkerList[0].Id;
                    socialWorkerContactObj.Email = existingSocialWorkerList[0].Email;
                    socialWorkerContactObj.FirstName = existingSocialWorkerList[0].FirstName;
                    socialWorkerContactObj.LastName = existingSocialWorkerList[0].LastName;
                    
                    newCaseObj.SW_First_Name__c = existingSocialWorkerList[0].FirstName;
                    newCaseObj.SW_Surname__c = existingSocialWorkerList[0].LastName;
                    newCaseObj.SW_Title__c = existingSocialWorkerList[0].Salutation;
                    newCaseObj.SW_Phone__c = existingSocialWorkerList[0].Phone;
                    newCaseObj.SW_Email__c = existingSocialWorkerList[0].Email;
                    newCaseObj.SW_Hospital__c = existingSocialWorkerList[0].Hospital__c;
                    newCaseObj.Social_Worker__c = existingSocialWorkerList[0].Id;
                }
            }
            if(doctorContactObj != null && doctorContactObj != contactObj){
                if(doctorContactObj.Email != null && String.isNotBlank(doctorContactObj.Email) && String.isNotEmpty(doctorContactObj.Email))
                    existingDoctorList = [SELECT Id, Salutation, FirstName, LastName, Email, Phone, Hospital__c, Hospital_Department__c FROM Contact 
                                          WHERE RecordTypeId =: Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId() 
                                          AND Email =: doctorContactObj.Email LIMIT 1];
                if(existingDoctorList.size() == 0){
                    if(doctorContactObj.Id != null || doctorContactObj.LastName != null){
                        if(doctorContactObj.Id != null && doctorContactObj.LastName == null)
                            delete doctorContactObj;
                        else
                            newContactList.add(doctorContactObj);
                    }
                }
                
                
                else if(existingDoctorList.size() > 0){
                    doctorCount++;
                    doctorContactObj = new Contact();
                    doctorContactObj.Id = existingDoctorList[0].Id;
                    doctorContactObj.Email = existingDoctorList[0].Email;
                    doctorContactObj.FirstName = existingDoctorList[0].FirstName;
                    doctorContactObj.LastName = existingDoctorList[0].LastName;
                    
                    newCaseObj.MP_First_Name__c = existingDoctorList[0].FirstName;
                    newCaseObj.MP_Surname__c = existingDoctorList[0].LastName;
                    newCaseObj.MP_Title__c = existingDoctorList[0].Salutation;
                    newCaseObj.MP_Phone__c = existingDoctorList[0].Phone;
                    newCaseObj.MP_Email__c = existingDoctorList[0].Email;
                    newCaseObj.MP_Hospital__c = existingDoctorList[0].Hospital__c;
                    newCaseObj.MP_Department__c = existingDoctorList[0].Hospital_Department__c;
                    newCaseObj.Medical_Professional__c = existingDoctorList[0].Id;
                    
                }
            }
            upsert newContactList;
            if(formCompleted != null && formCompleted != '' && String.isNotEmpty(formCompleted) && String.isNotBlank(formCompleted)){
                if(caseList[0].Form_Completed__c == null || caseList[0].Form_Completed__c < Integer.valueOf(formCompleted))
                    newCaseObj.Form_Completed__c = Integer.valueOf(formCompleted);
                if(newCaseObj.Form_Completed__c == 100)
                    newCaseObj.Status = 'Pending';
            }
            String field = '';
            for(String fields : usedFields){
                if(field != '')
                    field = field + ', ' + fields;
                else
                    field = fields;
            }
            newCaseObj.Not_New_Fields__c = '';
            newCaseObj.Not_New_Fields__c = field;
            if(newContactList.size() > 1){
                if(newContactList[0].RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId()){
                    newCaseObj.Medical_Professional__c = newContactList[0].Id;
                    newCaseObj.Social_Worker__c = newContactList[1].Id;
                }
                else{
                    newCaseObj.Medical_Professional__c = newContactList[1].Id;
                    newCaseObj.Social_Worker__c = newContactList[0].Id;
                }
            }
            else if(newContactList.size() == 1){
                if(newContactList[0].RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Specialist').getRecordTypeId()){
                    newCaseObj.Medical_Professional__c = newContactList[0].Id;
                }
                else{
                    newCaseObj.Social_Worker__c = newContactList[0].Id; 
                }
            }
            
            String s = dynamicFormWrapperObj.ReferralSignature;
            List<String> s1 = s.split(',');
            System.debug('s1--->>>>'+s1);
            String base64 = s1[1];
            String s2 = s1[0];
            System.debug('base64----->>>>>'+base64);
            List<String> s3 = s2.split(';');
            System.debug(s3);
            String s4 = s3[0];
            List<String> s5 = s4.split('/');
            String imagetype = s5[1];
            List<Case> caseeList = new List<Case>();
            if(dynamicFormWrapperObj.ReferralSignature != Null && String.isNotBlank(dynamicFormWrapperObj.ReferralSignature) && String.isNotEmpty(dynamicFormWrapperObj.ReferralSignature)){
                if(caseList.size()>0 && caseList[0].Referal_Signature__c == Null ){
                    String path = 'ParentDocument'+'.'+imagetype;
                    System.debug('path12345-->>>'+path);
                    //Create Content Version of base64
                    ContentVersion contentVersionObj = new ContentVersion();
                    contentVersionObj.Title = 'Parent Document';
                    contentVersionObj.VersionData = EncodingUtil.base64Decode(base64);
                    contentVersionObj.PathOnClient = path;
                    contentVersionObj.IsMajorVersion = true;
                    contentVersionObj.ContentLocation = 'S';
                    Insert contentVersionObj;
                    System.debug(contentVersionObj.Id);
                    
                    //Get Content Documents
                    Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionObj.Id].ContentDocumentId;
                    
                    //Create ContentDocumentLink 
                    ContentDocumentLink contentDocumentLinkObj = New ContentDocumentLink();
                    contentDocumentLinkObj.LinkedEntityId = caseList[0].Id; 
                    contentDocumentLinkObj.ContentDocumentId = conDocId;
                    contentDocumentLinkObj.shareType = 'V';
                    Insert contentDocumentLinkObj;
                    Case caseObj = new Case();
                    caseObj.Id = caseList[0].Id;
                    caseObj.ReferalContentDocumetId__c = contentVersionObj.Id;
                    update caseObj;
                    System.debug('caseObj--->>>>'+caseObj);
                }
            } 
            
            if(newCaseObj.PC_First_Name__c == null && newCaseObj.R_Address__c != null ){
                newCaseObj.PC_First_Name__c = caseList[0].R_First_Name__c;
                newCaseObj.PC_Surname__c = caseList[0].R_Surname__c;
                newCaseObj.PC_Phone__c = newCaseObj.R_Phone__c;
                newCaseObj.PC_Email__c = newCaseObj.R_Email__c;
                newCaseObj.PC_Secondary_Phone__c = newCaseObj.R_Secondary_Phone__c;
                newCaseObj.PC_Address__c = newCaseObj.R_Address__c;
                newCaseObj.PC_State__c = newCaseObj.R_State__c;
                newCaseObj.PC_Postcode__c = newCaseObj.R_Postcode__c;
                newCaseObj.Relationship_to_child__c = newCaseObj.Referral_Relationship_to_Child__c;
                
            }
            
            if(savedScreen.size() > 0)
                newCaseObj.Saved_Screen__c = String.join(new List<String>(savedScreen), ',');
            upsert newCaseObj;
            
            upsert newApplicationParticipantList;
            
            if(formCompleted != null && formCompleted != '' && String.isNotEmpty(formCompleted) && String.isNotBlank(formCompleted) && formCompleted == '100'){
                String emailId = newCaseObj.R_Email__c;
                SendEmailClass.sendEmailMethod1('Application Form Completed', caseList[0], emailId);
                if((socialWorkerContactObj != null && socialWorkerContactObj != contactObj && socialWorkerContactObj.Id != null && socialWorkerContactObj.Email != null && socialWorkerContactObj.Email != ''  && String.isNotEmpty(socialWorkerContactObj.Email)  && String.isNotBlank(socialWorkerContactObj.Email)) || (doctorContactObj != null && doctorContactObj != contactObj && doctorContactObj.Id != null && doctorContactObj.Email != null && doctorContactObj.Email != ''  && String.isNotEmpty(doctorContactObj.Email)  && String.isNotBlank(doctorContactObj.Email))){           
                    if(socialWorkerContactObj != null && socialWorkerContactObj != contactObj && socialWorkerContactObj.Id != null && socialWorkerContactObj.Email != null && socialWorkerContactObj.Email != ''){
                        emailId = newCaseObj.SW_Email__c;
                        if(socialWorkerCount == 0)
                            SendEmailClass.sendEmailMethod1('Social Worker Signup Invite', newCaseObj, emailId);
                        SendEmailClass.sendEmailMethod1('Invite Social Worker', newCaseObj, emailId);
                    }
                    if(doctorContactObj != null && doctorContactObj != contactObj && doctorContactObj.Id != null && doctorContactObj.Email != null && doctorContactObj.Email != ''){
                        emailId = newCaseObj.MP_Email__c;
                        if(doctorCount == 0){
                            SendEmailClass.sendEmailMethod1('Medical Professional Signup Invite', newCaseObj, emailId);
                        }
                        SendEmailClass.sendEmailMethod1('Invite Medical Professional', newCaseObj, emailId);
                    }
                }
                if(newCaseObj.Referral_Relationship_to_Child__c != 'Mother' && newCaseObj.Referral_Relationship_to_Child__c != 'Father' && newCaseObj.Referral_Relationship_to_Child__c != 'Legal Guardian'){
                    emailId = newCaseObj.PC_Email__c;
                    SendEmailClass.sendEmailMethod1('Consent Form', newCaseObj, emailId);
                }
            }
            if(newCaseObj != null || newApplicationParticipantList.size() > 0){
                RestContext.response.responseBody = Blob.valueOf('{"Status":"Success", "StatusCode":"200", "Record":"'+newCaseObj+newApplicationParticipantList+'"}');
                RestContext.response.statusCode = 200;
            }
            else{
                if(message != null)
                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "Message": "'+message+'"}');
                else
                    RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400"}');
                RestContext.response.statusCode = 400;
            }
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.addHeader('Access-Control-Allow-Origin','*');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'GET');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'POST');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'PUT');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'DELETE');
            RestContext.response.addHeader('Access-Control-Allow-Methods', 'OPTIONS');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Origin');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Access-Control-Allow-Origin');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Access-Control-Allow-Headers');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Access-Control-Expose-Headers');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Authorization');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Accept');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'Content-Type');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'X-Auth-Token');
            RestContext.response.addHeader('Access-Control-Allow-Headers', 'X-Requested-With');
        }
        catch(Exception e){
            System.debug('Exception: '+e.getMessage() +' At Line: '+e.getLineNumber());
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400", "message ":"'+e.getMessage() +'"}');
        }
    }
}
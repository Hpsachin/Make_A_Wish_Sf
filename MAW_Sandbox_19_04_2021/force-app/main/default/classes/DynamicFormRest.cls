@RestResource(urlMapping='/DynamicFormRestService/*')
global without sharing class DynamicFormRest {
    
    @HttpGet
    global static void DynamicFormCreation() {
        try{
            List<DynamicFormWrapper> DynamicFormWrapperList = new List<DynamicFormWrapper>();
            List<Dynamic_Form__mdt> DynamicFormList = new List<Dynamic_Form__mdt>();
            List<Dynamic_Flow__mdt> dynamicFlowList = new List<Dynamic_Flow__mdt>();
            
            Map<String, List<DynamicFormWrapper.innerfield>> ScreenRelatedDynamicFormListMap = new Map<String, List<DynamicFormWrapper.innerfield>>();
            Map<String,Dynamic_Flow__mdt> FromScreenVSDynamicFlowMap = new Map<String,Dynamic_Flow__mdt>();
            
            dynamicFlowList = [SELECT Id, Save_Details__c, Saved__c, Group__c, From_Screen__c, Relationship__c, Screen_Content__c, Priority__c, Screen_No__c, To_Screen__c, Dynamic__c, Next_Screen_Dependent__c FROM Dynamic_Flow__mdt WHERE From_Screen__c != 'Zero' ORDER BY Screen_No__c ASC LIMIT 50000];
            if(dynamicFlowList.size() > 0){
                for(Dynamic_Flow__mdt dynamicFlow : dynamicFlowList){
                    FromScreenVSDynamicFlowMap.put(dynamicFlow.Relationship__c + dynamicFlow.From_Screen__c, dynamicFlow);
                }
            }
            
            DynamicFormList = [SELECT Screen__c, MasterLabel, Class__c, Disabled__c, Field__c, Object__c, Relationship__c, Required__c, Type__c, Value__c, Label__c, Record_Type__c, Name__c, Placeholder__c, Field_Priority__c, Include_numbers_in_text_fields__c FROM Dynamic_Form__mdt WHERE Screen__c != 'Zero' ORDER BY Field_Priority__c ASC Limit 50000];
            if(DynamicFormList.size() > 0){
                for(Dynamic_Form__mdt dynamicFormObj : DynamicFormList){
                    if(!ScreenRelatedDynamicFormListMap.containsKey(dynamicFormObj.Relationship__c + dynamicFormObj.Screen__c)){
                        ScreenRelatedDynamicFormListMap.put(dynamicFormObj.Relationship__c + dynamicFormObj.Screen__c, new List<DynamicFormWrapper.innerfield>());
                    }
                    DynamicFormWrapper.innerfield innerfieldObj = new DynamicFormWrapper.innerfield();
                    if(dynamicFormObj.Class__c == null){
                        innerfieldObj.cssClass = '';
                    }
                    else{
                        innerfieldObj.cssClass = dynamicFormObj.Class__c;
                    }
                    innerfieldObj.disabled = dynamicFormObj.Disabled__c;
                    innerfieldObj.field = dynamicFormObj.Field__c;
                    if(dynamicFormObj.Label__c == null){
                        innerfieldObj.label = '';
                    }
                    else{
                        innerfieldObj.label = dynamicFormObj.Label__c;
                    }
                    innerfieldObj.required = dynamicFormObj.Required__c;
                    if(dynamicFormObj.Required__c == true){
                        innerfieldObj.errorMessage = 'This is a required field.';
                    }
                    else{
                        innerfieldObj.errorMessage = '';
                    }
                    innerfieldObj.type = dynamicFormObj.Type__c;
                    List<DynamicFormWrapper.options> optionsList = new List<DynamicFormWrapper.options>();
                    if(innerfieldObj.type == 'radio' || innerfieldObj.type == 'picklist'){
                        String tst;
                        if(innerfieldObj.field == 'C_Gender__c' || innerfieldObj.field == 'PC_Gender__c'){
                            tst = Label.Gender_Button_Options;
                        }
                        else if(innerfieldObj.field == 'Can_your_child_communicate_verbally__c'){
                            tst = Label.Radio_Button_Options;
                        }
                        else if(innerfieldObj.field == 'Who_referred_you_to_Make_A_Wish__c'){
                            tst = Label.MAW_Referrer;
                        }
                        else if(innerfieldObj.field == 'Relationship_to_child__c'){
                            tst = Label.Guardian_Options;
                        }
                        else if(innerfieldObj.field == 'MP_Title__c' || innerfieldObj.field == 'SW_Title__c'){
                            tst = 'Mr.,Ms.,Mrs.,Dr.,Prof.';
                        }
                        else{
                            tst = Label.Radio_Button_Options;
                            tst = tst.substring(0, tst.lastIndexOf(','));
                        }
                        String s = '';
                        tst = tst+',';
                        while(tst.length() > 0){
                            s = tst.substringBefore(',');
                            tst= tst.remove(s+',');
                            DynamicFormWrapper.options optionsObj = new DynamicFormWrapper.options();
                            optionsObj.text = s;
                            optionsObj.value = s;
                            optionsList.add(optionsObj);
                        }
                        innerfieldObj.options = optionsList;                              
                    }
                    else{
                        innerfieldObj.options = optionsList;
                    }
                    if(dynamicFormObj.Value__c == null){
                        innerfieldObj.value = '';
                    }
                    else{
                        innerfieldObj.value = dynamicFormObj.Value__c;
                    }
                    if(innerfieldObj.type == 'checkbox' && innerfieldObj.value == ''){
                        innerfieldObj.value = 'false';
                    }
                    innerfieldObj.name = dynamicFormObj.Name__c;
                    innerfieldObj.recordType = dynamicFormObj.Record_Type__c;
                    innerfieldObj.objectName = dynamicFormObj.Object__c;
                    if(dynamicFormObj.Placeholder__c == null){
                        innerfieldObj.placeholder = '';
                    }
                    else{
                        innerfieldObj.placeholder = dynamicFormObj.Placeholder__c;
                    }
                    if(dynamicFormObj.Include_numbers_in_text_fields__c == null || dynamicFormObj.Include_numbers_in_text_fields__c == false)
                        innerfieldObj.includeNumber = false;
                    else
                        innerfieldObj.includeNumber = true;
                    ScreenRelatedDynamicFormListMap.get(dynamicFormObj.Relationship__c + dynamicFormObj.Screen__c).add(innerfieldObj);
                }
            }
            List<DynamicFormWrapper.Mother> MotherObj = new List<DynamicFormWrapper.Mother>();
            List<DynamicFormWrapper.Father> FatherObj = new List<DynamicFormWrapper.Father>();
            List<DynamicFormWrapper.Legal_Guardian> LegalGuardianObj = new List<DynamicFormWrapper.Legal_Guardian>();
            List<DynamicFormWrapper.Social_Worker> SocialWorkerrObj = new List<DynamicFormWrapper.Social_Worker>();
            List<DynamicFormWrapper.Case_Worker> CaseWorkerObj = new List<DynamicFormWrapper.Case_Worker>();
            List<DynamicFormWrapper.Doctor> DoctorObj = new List<DynamicFormWrapper.Doctor>();
            List<DynamicFormWrapper.Child> ChildObj = new List<DynamicFormWrapper.Child>();
            List<DynamicFormWrapper.Family_Members> FamilyMembersObj = new List<DynamicFormWrapper.Family_Members>();
            DynamicFormWrapper DynamicFormWrapperObj = new DynamicFormWrapper();
            if(!FromScreenVSDynamicFlowMap.isEmpty() && !ScreenRelatedDynamicFormListMap.isEmpty()){
                DynamicFormWrapperObj = DynamicFormRest.assignWrapperFields(FromScreenVSDynamicFlowMap, ScreenRelatedDynamicFormListMap, null);
            }
            RestContext.response.responseBody = Blob.valueOf(System.JSON.serialize(DynamicFormWrapperObj));
            RestContext.response.statusCode = 200;
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.addHeader('Access-Control-Allow-Origin','*');
            RestContext.response.addHeader('Access-Control-Allow-Credentials', 'true');
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
    
    @HttpPost
    global static void DynamicFormApplicationNo() {
        try{
            RestRequest request = RestContext.request;
            String xmlString = request.requestBody.toString();
            DynamicFormApplicationWrapper dynamicFormApplicationWrapperObj = (DynamicFormApplicationWrapper) System.JSON.deserialize(xmlString, DynamicFormApplicationWrapper.class);
            List<Case> newCaseList = new List<Case>();
            String applicationNumber;
            Case newCase = new Case();
            
            if(dynamicFormApplicationWrapperObj != null){
                if(dynamicFormApplicationWrapperObj.ApplicationNumber == '' || dynamicFormApplicationWrapperObj.ApplicationNumber == null || 
                   String.isEmpty(dynamicFormApplicationWrapperObj.ApplicationNumber) || String.isBlank(dynamicFormApplicationWrapperObj.ApplicationNumber)){
                       if(dynamicFormApplicationWrapperObj.FirstName != '' && dynamicFormApplicationWrapperObj.FirstName != null && String.isNotEmpty(dynamicFormApplicationWrapperObj.FirstName) && String.isNotBlank(dynamicFormApplicationWrapperObj.FirstName))
                           newCase.R_First_Name__c = dynamicFormApplicationWrapperObj.FirstName;
                       if(dynamicFormApplicationWrapperObj.LastName != '' && dynamicFormApplicationWrapperObj.LastName != null && String.isNotEmpty(dynamicFormApplicationWrapperObj.LastName) && String.isNotBlank(dynamicFormApplicationWrapperObj.LastName))
                           newCase.R_Surname__c = dynamicFormApplicationWrapperObj.LastName;
                       if(dynamicFormApplicationWrapperObj.Email != '' && dynamicFormApplicationWrapperObj.Email != null && String.isNotEmpty(dynamicFormApplicationWrapperObj.Email) && String.isNotBlank(dynamicFormApplicationWrapperObj.Email))
                           newCase.R_Email__c = dynamicFormApplicationWrapperObj.Email;
                       if(dynamicFormApplicationWrapperObj.Phone != '' && dynamicFormApplicationWrapperObj.Phone != null && String.isNotEmpty(dynamicFormApplicationWrapperObj.Phone) && String.isNotBlank(dynamicFormApplicationWrapperObj.Phone))
                           newCase.R_Phone__c = dynamicFormApplicationWrapperObj.Phone;
                       newCase.Origin = 'Web';
                       //newContact.Application_Number__c = AutoGenerateApplicationNumber.assignApplicationNumber();
                       insert newCase;
                   }
                else if(dynamicFormApplicationWrapperObj.ApplicationNumber != '' || dynamicFormApplicationWrapperObj.ApplicationNumber != null || 
                        String.isNotEmpty(dynamicFormApplicationWrapperObj.ApplicationNumber) || String.isNotBlank(dynamicFormApplicationWrapperObj.ApplicationNumber)){
                            applicationNumber = dynamicFormApplicationWrapperObj.ApplicationNumber;
                        }   
                
                if(applicationNumber == null){
                    newCaseList = [SELECT Id, CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, R_Phone__c FROM Case WHERE Id =: newCase.Id LIMIT 1];
                    SendEmailClass.sendEmailMethod1('Send Unique Application Number', newCaseList[0], newCaseList[0].R_Email__c);
                    dynamicFormApplicationWrapperObj.ApplicationNumber = newCaseList[0].CaseNumber;
                    RestContext.response.responseBody = Blob.valueOf('{"Status":"Success", "StatusCode":"200", "Record":'+System.JSON.serialize(dynamicFormApplicationWrapperObj)+'}');
                }
                else{
                    if(dynamicFormApplicationWrapperObj.FirstName != '' && dynamicFormApplicationWrapperObj.FirstName != null && String.isNotEmpty(dynamicFormApplicationWrapperObj.FirstName) && String.isNotBlank(dynamicFormApplicationWrapperObj.FirstName) && dynamicFormApplicationWrapperObj.Email != '' && dynamicFormApplicationWrapperObj.Email != null && String.isNotEmpty(dynamicFormApplicationWrapperObj.Email) && String.isNotBlank(dynamicFormApplicationWrapperObj.Email))
                        newCaseList = [SELECT Id, CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, R_Phone__c, Form_Completed__c, Status FROM Case WHERE CaseNumber =: applicationNumber AND R_Email__c =: dynamicFormApplicationWrapperObj.Email AND R_First_Name__c =: dynamicFormApplicationWrapperObj.FirstName LIMIT 1];
                    else
                        newCaseList = [SELECT Id, CaseNumber, R_First_Name__c, R_Surname__c, R_Email__c, R_Phone__c, Form_Completed__c, Status FROM Case WHERE CaseNumber =: applicationNumber LIMIT 1];
                    if(newCaseList.size() > 0){
                        if(newCaseList[0].Form_Completed__c == null){
                            newCaseList[0].Form_Completed__c = 0;
                        }
                        
                        if(newCaseList[0].Form_Completed__c > 0 && newCaseList[0].Form_Completed__c < 100){
                            DynamicFormWrapper dynamicFormWrapper = DynamicFormRest.DynamicFormExistingDetails(applicationNumber, false);
                            if(dynamicFormWrapper != null){
                                RestContext.response.responseBody = Blob.valueOf('{"Status":"Success", "StatusCode":"200", "primaryContactName": "'+newCaseList[0].R_First_Name__c+'", "Record":'+System.JSON.serialize(dynamicFormWrapper)+'}');
                                RestContext.response.statusCode = 200;
                            }
                            else{
                                RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400"}');
                                RestContext.response.statusCode = 400;                    
                            }
                        }
                        else if(newCaseList[0].Form_Completed__c == 100){
                            if(dynamicFormApplicationWrapperObj.Dashboard == true){
                                DynamicFormWrapper dynamicFormWrapper = DynamicFormRest.DynamicFormExistingDetails(applicationNumber, true);
                                if(dynamicFormWrapper != null){
                                    RestContext.response.responseBody = Blob.valueOf('{"Status":"Success", "StatusCode":"200", "primaryContactFirstName": "'+newCaseList[0].R_First_Name__c+'", "primaryContactLastName": "'+newCaseList[0].R_Surname__c+'", "ApplicationStatus": "'+newCaseList[0].Status+'", "Record":'+System.JSON.serialize(dynamicFormWrapper)+'}');
                                    RestContext.response.statusCode = 200;
                                }
                                else{
                                    RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400"}');
                                    RestContext.response.statusCode = 400;                    
                                }
                            }
                            else if(dynamicFormApplicationWrapperObj.Dashboard == false){
                                RestContext.response.responseBody = Blob.valueOf('{"Status":"Success", "StatusCode":"201", "Message":"You\'ve already filled out the form completely and submitted it successfully."}');
                                RestContext.response.statusCode = 200;                    
                            }
                        }
                        else if(newCaseList[0].Form_Completed__c == 0){
                            RestContext.response.responseBody = Blob.valueOf('{"Status":"Success", "StatusCode":"401", "Message":"Your application form hasn\'t been saved with any details therefore you have no longer access to your form. We suggest you to fill out a new application form."}');
                            RestContext.response.statusCode = 400;                        
                        }
                    }
                    else{
                        RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400", "Message": "No record found with these details."}');
                        RestContext.response.statusCode = 400;                    
                    }
                }
            }
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.addHeader('Access-Control-Allow-Origin','*');
            RestContext.response.addHeader('allowedOriginsPatterns','*');
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
            RestContext.response.responseBody = Blob.valueOf('{"Status":"Error", "StatusCode":"400", "message ":"'+e.getMessage()+e.getLineNumber() +'"}');
        }
    }
    
    public static DynamicFormWrapper DynamicFormExistingDetails(String applicationNumber, Boolean dashboard){
        try{
            if(applicationNumber != null || applicationNumber != ''){
                
                List<Case> caseList = new List<Case>();
                
                Set<Id> appParticipantIdSet = new Set<Id>();
                
                caseList = [SELECT Id, CaseNumber, PC_Address__c, Who_referred_you_to_Make_A_Wish__c,MP_Email__c, Interpreter_Email__c, SK_Postcode__c, R_Postcode__c, Saved_Screen__c, 
                            C_Address__c, C_Condition__c, Language, C_First_Name__c, SK_Address__c, Does_family_require_an_interpreter__c, SW_Surname__c, C_Postcode__c, 
                            School_know_of_the_child_s_illness__c, PC_Gender__c, Relationship_to_child__c, Description, Child_also_has_a_case_worker__c, PC_First_Name__c, 
                            Is_child_aware_condition_is_life_threat__c, Interpreter_Organisation__c, Contact_school_regarding_wish__c, SW_Title__c, SW_Hospital__c, Not_New_Fields__c,
                            Name_of_School_or_Kindergarten__c, Aboriginal_or_Torres_Strait_Islander__c, R_Phone__c, MP_Hospital__c, Referral_Relationship_to_Child__c, 
                            SW_Phone__c, MP_Title__c, Primary_language_spoken_at_home__c, PC_Phone__c, Can_your_child_communicate_verbally__c, R_Address__c, C_DOB__c, 
                            Spoken_to_Parent_Guardian__c, Child_Lives_With_You__c, IO_Phone__c, C_Last_Name__c, R_Secondary_Phone__c, MP_First_Name__c, MP_Department__c, 
                            PC_Secondary_Phone__c, PC_State__c, PC_Surname__c, SK_State__c, Email_Opt_Out__c, R_State__c, SW_First_Name__c, PC_DOB__c, PC_Postcode__c, 
                            SW_Email__c, C_State__c, PC_Email__c, C_Gender__c, MP_Surname__c, Interpreter_Full_Name__c, R_Email__c, MP_Phone__c, Child_Condition_by_Doctor__c
                            FROM Case WHERE CaseNumber =: applicationNumber LIMIT 1];
                
                List<Application_Participant__c> applicationParticipantList = new List<Application_Participant__c>();
                
                if(caseList.size() > 0){
                    applicationParticipantList = [SELECT Id, Birthdate__c, First_Name__c, Gender__c, Relationship__c, Surname__c FROM Application_Participant__c WHERE Case__c =: caseList[0].Id];
                }
                
                if(caseList.size() > 0 && caseList[0].Referral_Relationship_to_Child__c != null){
                    Set<String> usedFields = new Set<String>();
                    Set<String> savedScreens = new Set<String>();
                    
                    if(caseList[0].Not_New_Fields__c != null && caseList[0].Not_New_Fields__c != ''){
                        String fields = caseList[0].Not_New_Fields__c + ', ';
                        while(fields.countMatches(', ') > 0){
                            String field = fields.substringBefore(', ');
                            fields = fields.remove(field+', ');
                            usedFields.add(field);
                        }
                    }
                    
                    if(caseList[0].Saved_Screen__c != null && String.isNotBlank(caseList[0].Saved_Screen__c) && String.isNotEmpty(caseList[0].Saved_Screen__c))
                        savedScreens.addAll(caseList[0].Saved_Screen__c.split(','));
                    
                    for(Application_Participant__c appParticipantObj : applicationParticipantList){
                        appParticipantIdSet.add(appParticipantObj.Id);
                    }
                    
                    List<DynamicFormWrapper> DynamicFormWrapperList = new List<DynamicFormWrapper>();
                    List<Dynamic_Form__mdt> DynamicFormList = new List<Dynamic_Form__mdt>();
                    List<Dynamic_Flow__mdt> dynamicFlowList = new List<Dynamic_Flow__mdt>();
                    
                    Map<String, List<DynamicFormWrapper.innerfield>> ScreenRelatedDynamicFormListMap = new Map<String, List<DynamicFormWrapper.innerfield>>();
                    Map<String,Dynamic_Flow__mdt> FromScreenVSDynamicFlowMap = new Map<String,Dynamic_Flow__mdt>();
                    
                    String primaryRelation;
                    primaryRelation = (caseList[0].Referral_Relationship_to_Child__c).replace(' ','_');
                    
                    dynamicFlowList = [SELECT Id, From_Screen__c, Relationship__c, Screen_Content__c, Screen_No__c, To_Screen__c, Group__c, Priority__c, Save_Details__c, Saved__c, Dynamic__c, Next_Screen_Dependent__c
                                       FROM Dynamic_Flow__mdt WHERE From_Screen__c != 'Zero' AND Relationship__c =: primaryRelation ORDER BY Screen_No__c ASC LIMIT 50000];
                    
                    Map<String, String> screenVsGroupMap = new Map<String, String>();
                    Set<String> groupSet = new Set<String>();
                    if(dynamicFlowList.size() > 0){
                        for(Dynamic_Flow__mdt dynamicFlow : dynamicFlowList){
                            FromScreenVSDynamicFlowMap.put(dynamicFlow.Relationship__c + dynamicFlow.From_Screen__c, dynamicFlow);
                            screenVsGroupMap.put(dynamicFlow.From_Screen__c, dynamicFlow.Group__c);
                            groupSet.add(dynamicFlow.Group__c);
                        }
                    }
                    DynamicFormList = [SELECT Screen__c, MasterLabel, Class__c, Disabled__c, Field__c, Object__c, Relationship__c, Required__c, Type__c, Value__c, Label__c, 
                                       Record_Type__c, Name__c, Placeholder__c, Field_Priority__c, Include_numbers_in_text_fields__c FROM Dynamic_Form__mdt WHERE Screen__c != 'Zero' 
                                       AND Relationship__c =: primaryRelation ORDER BY Field_Priority__c ASC Limit 50000];
                    Map<String, String> recordTypeVsFieldMap = new Map<String, String>();
                    Map<String, List<String>> fieldsNameSets = new Map<String, List<String>>();
                    Set<String> caseFieldsNameSet = new Set<String>();
                    Set<String> fieldsNameSet = new Set<String>();
                    
                    List<Application_Participant__c> familyResult = new List<Application_Participant__c>();
                    List<Case> caseResult = new List<Case>();
                    
                    if(DynamicFormList.size() > 0){
                        for(Dynamic_Form__mdt dynamicFormObj : DynamicFormList){
                            if(dynamicFormObj.Field__c != null || dynamicFormObj.Field__c != ''){
                                if(dynamicFormObj.Object__c == 'Case')
                                    caseFieldsNameSet.add(dynamicFormObj.Field__c);
                                else if(dynamicFormObj.Object__c == 'Application_Participant__c')
                                    fieldsNameSet.add(dynamicFormObj.Field__c);
                                if(!fieldsNameSets.containsKey(dynamicFormObj.Record_Type__c)){
                                    List<String> fieldList = new List<String>();
                                    fieldList.add(dynamicFormObj.Field__c);
                                    fieldsNameSets.put(dynamicFormObj.Record_Type__c, fieldList);
                                }
                                else{
                                    List<String> fieldList = fieldsNameSets.get(dynamicFormObj.Record_Type__c);
                                    if(!fieldList.contains(dynamicFormObj.Field__c))
                                        fieldList.add(dynamicFormObj.Field__c);
                                    fieldsNameSets.put(dynamicFormObj.Record_Type__c, fieldList);
                                }
                            }
                        }
                        
                        String caseFields = '';
                        String applicationParticipantFields = '';
                        
                        for(String each : caseFieldsNameSet){
                            if(caseFields == '')
                                caseFields = each;
                            else
                                caseFields = caseFields + ', ' + each;
                        }
                        
                        for(String each : fieldsNameSet){
                            if(applicationParticipantFields == '')
                                applicationParticipantFields = each;
                            else
                                applicationParticipantFields = applicationParticipantFields + ', ' + each;
                        }
                        
                        for(String key : fieldsNameSets.keySet()){
                            for(String fieldsName : fieldsNameSets.get(key)){
                                if(recordTypeVsFieldMap.containsKey(key)){
                                    recordTypeVsFieldMap.put(key, recordTypeVsFieldMap.get(key) + ', ' + fieldsName);
                                }
                                else
                                {
                                    recordTypeVsFieldMap.put(key, fieldsName);
                                }
                            }
                        }
                        
                        String caseQuery, familyQuery;
                        caseQuery = 'SELECT '+ caseFields + ', Specification_Related_Medical_Condition__c, Specification_Related_Wish__c, Fit_For_Wish__c, Child_Condition_by_Doctor__c FROM Case WHERE Id = \''+ caseList[0].Id +'\' ORDER BY Id ASC LIMIT 1';
                        
                        if(applicationParticipantList.size() > 0)
                            familyQuery = 'SELECT '+ applicationParticipantFields + ' FROM Application_Participant__c WHERE Id IN: appParticipantIdSet LIMIT 5000';
                        
                        caseResult = Database.query(caseQuery);
                        if(familyQuery != null)
                            familyResult = Database.query(familyQuery);
                        
                        Integer i = 0;
                        for(Dynamic_Form__mdt dynamicFormObj : DynamicFormList){
                            if(!ScreenRelatedDynamicFormListMap.containsKey(dynamicFormObj.Relationship__c + dynamicFormObj.Screen__c)){
                                ScreenRelatedDynamicFormListMap.put(dynamicFormObj.Relationship__c + dynamicFormObj.Screen__c, new List<DynamicFormWrapper.innerfield>());
                            }
                            DynamicFormWrapper.innerfield innerfieldObj = new DynamicFormWrapper.innerfield();
                            if(dynamicFormObj.Class__c == null){
                                innerfieldObj.cssClass = '';
                            }
                            else{
                                innerfieldObj.cssClass = dynamicFormObj.Class__c;
                            }
                            innerfieldObj.disabled = dynamicFormObj.Disabled__c;
                            innerfieldObj.field = dynamicFormObj.Field__c;
                            if(dynamicFormObj.Label__c == null){
                                innerfieldObj.label = '';
                            }
                            else{
                                innerfieldObj.label = dynamicFormObj.Label__c;
                            }
                            innerfieldObj.required = dynamicFormObj.Required__c;
                            if(dynamicFormObj.Required__c == true){
                                innerfieldObj.errorMessage = 'This is a required field.';
                            }
                            else{
                                innerfieldObj.errorMessage = '';
                            }
                            innerfieldObj.type = dynamicFormObj.Type__c;
                            List<DynamicFormWrapper.options> optionsList = new List<DynamicFormWrapper.options>();
                            if(innerfieldObj.type == 'radio' || innerfieldObj.type == 'picklist'){
                                String tst;
                                if(innerfieldObj.field == 'C_Gender__c' || innerfieldObj.field == 'PC_Gender__c'){
                                    tst = Label.Gender_Button_Options;
                                }
                                else if(innerfieldObj.field == 'Can_your_child_communicate_verbally__c'){
                                    tst = Label.Radio_Button_Options;
                                }
                                else if(innerfieldObj.field == 'Who_referred_you_to_Make_A_Wish__c'){
                                    tst = Label.MAW_Referrer;
                                }
                                else if(innerfieldObj.field == 'Relationship_to_child__c'){
                                    tst = Label.Guardian_Options;
                                }
                                else if(innerfieldObj.field == 'MP_Title__c' || innerfieldObj.field == 'SW_Title__c'){
                                    tst = 'Mr.,Ms.,Mrs.,Dr.,Prof.';
                                }
                                else{
                                    tst = Label.Radio_Button_Options;
                                    tst = tst.substring(0, tst.lastIndexOf(','));
                                }
                                String s = '';
                                tst = tst+',';
                                while(tst.length() > 0){
                                    s = tst.substringBefore(',');
                                    tst= tst.remove(s+',');
                                    DynamicFormWrapper.options optionsObj = new DynamicFormWrapper.options();
                                    optionsObj.text = s;
                                    optionsObj.value = s;
                                    optionsList.add(optionsObj);
                                }
                                innerfieldObj.options = optionsList;                              
                            }
                            else{
                                innerfieldObj.options = optionsList;
                            }
                            innerfieldObj.recordType = dynamicFormObj.Record_Type__c;
                            if(caseResult.size() > 0 && dynamicFormObj.Object__c == 'Case')
                                innerfieldObj.value = String.valueOf(caseResult[0].get(dynamicFormObj.Field__c));
                            else if(familyResult.size() > 0 && dynamicFormObj.Object__c == 'Application_Participant__c')
                                innerfieldObj.value = String.valueOf(familyResult[0].get(dynamicFormObj.Field__c));
                            if(innerfieldObj.type == 'radio'){
                                if(innerfieldObj.value == 'true')
                                    innerfieldObj.value = 'Yes';
                                else if(innerfieldObj.value == 'false' && usedFields.contains(innerfieldObj.field))
                                    innerfieldObj.value = 'No';
                                else
                                    innerfieldObj.value = '';
                            }
                            if(innerfieldObj.value == null){
                                innerfieldObj.value = '';
                            }
                            if(innerfieldObj.type == 'checkbox' && innerfieldObj.value == ''){
                                innerfieldObj.value = 'false';
                            }
                            
                            innerfieldObj.name = dynamicFormObj.Name__c;
                            innerfieldObj.objectName = dynamicFormObj.Object__c;
                            if(dynamicFormObj.Placeholder__c == null){
                                innerfieldObj.placeholder = '';
                            }
                            else{
                                innerfieldObj.placeholder = dynamicFormObj.Placeholder__c;
                            }
                            if(dynamicFormObj.Include_numbers_in_text_fields__c == null || dynamicFormObj.Include_numbers_in_text_fields__c == false)
                                innerfieldObj.includeNumber = false;
                            else
                                innerfieldObj.includeNumber = true;
                            ScreenRelatedDynamicFormListMap.get(dynamicFormObj.Relationship__c + dynamicFormObj.Screen__c).add(innerfieldObj);
                        }
                    }
                    List<DynamicFormWrapper.Family> FamilyList = new List<DynamicFormWrapper.Family>();
                    DynamicFormWrapper DynamicFormWrapperObj = new DynamicFormWrapper();
                    if(!FromScreenVSDynamicFlowMap.isEmpty() && !ScreenRelatedDynamicFormListMap.isEmpty()){
                        DynamicFormWrapperObj = DynamicFormRest.assignWrapperFields(FromScreenVSDynamicFlowMap, ScreenRelatedDynamicFormListMap, savedScreens);
                    }
                    for(Application_Participant__c familyMemberObj : familyResult){
                        DynamicFormWrapper.Family FamilyObj = new DynamicFormWrapper.Family();
                        FamilyObj.firstName = familyMemberObj.First_Name__c;
                        FamilyObj.lastName = familyMemberObj.Surname__c;
                        FamilyObj.gender = familyMemberObj.Gender__c;
                        FamilyObj.dob = String.valueOf(familyMemberObj.Birthdate__c);
                        FamilyObj.relation =  familyMemberObj.Relationship__c;
                        FamilyList.add(FamilyObj);
                    }
                    
                    if(caseResult != null && caseResult.size() > 0 && dashboard == true){
                        if(caseResult[0].Specification_Related_Medical_Condition__c != null)
                            DynamicFormWrapperObj.AnyMedicalConditionSpecification = caseResult[0].Specification_Related_Medical_Condition__c;
                        if(caseResult[0].Fit_For_Wish__c != null){
                            if(caseResult[0].Fit_For_Wish__c == true)
                                DynamicFormWrapperObj.FitForWish = 'Yes';
                            else if(caseResult[0].Fit_For_Wish__c == false && usedFields.contains('Fit_For_Wish__c'))
                                DynamicFormWrapperObj.FitForWish = 'No';
                        }
                        if(caseResult[0].Specification_Related_Wish__c != null)
                            DynamicFormWrapperObj.AnyWishSpecification = caseResult[0].Specification_Related_Wish__c;
                        if(caseResult[0].Child_Condition_by_Doctor__c != null)
                            DynamicFormWrapperObj.ChildsCondition = caseResult[0].Child_Condition_by_Doctor__c;
                    }
                    DynamicFormWrapperObj.Family = FamilyList;
                    DynamicFormWrapperObj.GroupList = groupSet;
                    return DynamicFormWrapperObj;
                }
            }
        }
        catch(Exception e){
            System.debug('Exception: '+e.getMessage() +' At Line: '+e.getLineNumber());
        }
        return null;
    }
    
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
            caseList = [SELECT Id, Form_Completed__c,Referal_Signature__c, Primary_Contact_Signature__c	 ,Medical_Professional_Signature__c	,R_First_Name__c, R_Surname__c, R_Phone__c, R_Email__c, CaseNumber, C_First_Name__c FROM Case WHERE CaseNumber =: applicationNo LIMIT 1];
            
            
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
            
            if(newCaseObj.Referral_Signature_URL__c != Null && String.isNotBlank(newCaseObj.Referral_Signature_URL__c) && String.isNotEmpty(newCaseObj.Referral_Signature_URL__c)){
                List<String> s1 = newCaseObj.Referral_Signature_URL__c.split(',');
                String base64 = s1[1];
                String s2 = s1[0];
                List<String> s3 = s2.split(';');
                String s4 = s3[0];
                List<String> s5 = s4.split('/');
                String imagetype = s5[1];
                if(caseList.size()>0){
                    String path = 'ParentDocument'+'.'+imagetype;
                    //Create Content Version of base64
                    ContentVersion contentVersionObj = new ContentVersion();
                    contentVersionObj.Title = 'Parent Document';
                    contentVersionObj.VersionData = EncodingUtil.base64Decode(base64);
                    contentVersionObj.PathOnClient = path;
                    contentVersionObj.IsMajorVersion = true;
                    contentVersionObj.ContentLocation = 'S';
                    insert contentVersionObj;
                    
                    //Get Content Documents
                    Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionObj.Id].ContentDocumentId;
                    
                    //Create ContentDocumentLink 
                    ContentDocumentLink contentDocumentLinkObj = New ContentDocumentLink();
                    contentDocumentLinkObj.LinkedEntityId = caseList[0].Id; 
                    contentDocumentLinkObj.ContentDocumentId = conDocId;
                    contentDocumentLinkObj.shareType = 'V';
                    insert contentDocumentLinkObj;
                    newCaseObj.ReferalContentDocumetId__c = contentVersionObj.Id;
                }
            }
            
            if(newCaseObj.Parent_Signature_URL__c != Null && String.isNotBlank(newCaseObj.Parent_Signature_URL__c) && String.isNotEmpty(newCaseObj.Parent_Signature_URL__c)){
                List<String> s1 = newCaseObj.Parent_Signature_URL__c.split(',');
                String base64 = s1[1];
                String s2 = s1[0];
                List<String> s3 = s2.split(';');
                String s4 = s3[0];
                List<String> s5 = s4.split('/');
                String imagetype = s5[1];
                if(caseList.size() > 0){
                    String path = 'DoctorSignature'+'.'+imagetype;
                    //Create Content Version of base64
                    ContentVersion contentVersionObj = new ContentVersion();
                    contentVersionObj.Title = 'Doctor Signature';
                    contentVersionObj.VersionData = EncodingUtil.base64Decode(base64);
                    contentVersionObj.PathOnClient = path;
                    contentVersionObj.IsMajorVersion = true;
                    contentVersionObj.ContentLocation = 'S';
                    insert contentVersionObj;
                    
                    //Get Content Documents
                    Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionObj.Id].ContentDocumentId;
                    
                    //Create ContentDocumentLink 
                    ContentDocumentLink contentDocumentLinkObj = New ContentDocumentLink();
                    contentDocumentLinkObj.LinkedEntityId = caseList[0].Id; 
                    contentDocumentLinkObj.ContentDocumentId = conDocId;
                    contentDocumentLinkObj.shareType = 'V';
                    insert contentDocumentLinkObj;
                    newCaseObj.DoctorContentDocumentId__c = contentVersionObj.Id;
                }
            }
            
            if(newCaseObj.Doctor_Signature_URL__c != Null && String.isNotBlank(newCaseObj.Doctor_Signature_URL__c) && String.isNotEmpty(newCaseObj.Doctor_Signature_URL__c)){
                List<String> s1 = newCaseObj.Doctor_Signature_URL__c.split(',');
                String base64 = s1[1];
                String s2 = s1[0];
                List<String> s3 = s2.split(';');
                String s4 = s3[0];
                List<String> s5 = s4.split('/');
                String imagetype = s5[1];
                if(caseList.size()>0){
                    String path = 'PrimaryContactSignature'+'.'+imagetype;
                    //Create Content Version of base64
                    ContentVersion contentVersionObj = new ContentVersion();
                    contentVersionObj.Title = 'PrimaryContact Signature';
                    contentVersionObj.VersionData = EncodingUtil.base64Decode(base64);
                    contentVersionObj.PathOnClient = path;
                    contentVersionObj.IsMajorVersion = true;
                    contentVersionObj.ContentLocation = 'S';
                    insert contentVersionObj;
                    
                    //Get Content Documents
                    Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionObj.Id].ContentDocumentId;
                    
                    //Create ContentDocumentLink 
                    ContentDocumentLink contentDocumentLinkObj = New ContentDocumentLink();
                    contentDocumentLinkObj.LinkedEntityId = caseList[0].Id; 
                    contentDocumentLinkObj.ContentDocumentId = conDocId;
                    contentDocumentLinkObj.shareType = 'V';
                    insert contentDocumentLinkObj;
                    newCaseObj.ParentContentDocumentId__c = contentVersionObj.Id;
                }
            }
            
            if(newCaseObj.PC_First_Name__c == null && newCaseObj.R_Address__c != null){
                
                newCaseObj.PC_First_Name__c = caseList[0].R_First_Name__c;
                newCaseObj.PC_Surname__c = caseList[0].R_Surname__c;
                newCaseObj.PC_Phone__c = newCaseObj.R_Phone__c;
                newCaseObj.PC_Email__c = newCaseObj.R_Email__c;
                newCaseObj.PC_Secondary_Phone__c = newCaseObj.R_Secondary_Phone__c;
                newCaseObj.PC_Address__c = newCaseObj.R_Address__c;
                newCaseObj.PC_State__c = newCaseObj.R_State__c;
                newCaseObj.PC_Postcode__c = newCaseObj.R_Postcode__c;
                newCaseObj.Relationship_to_child__c = newCaseObj.Referral_Relationship_to_Child__c;
                //if(dynamicFormWrapperObj.ParentSignature == Null && String.isBlank(dynamicFormWrapperObj.ParentSignature) && String.isEmpty(dynamicFormWrapperObj.ParentSignature) && 
                //dynamicFormWrapperObj.ReferralSignature != Null && String.isNotBlank(dynamicFormWrapperObj.ReferralSignature) && String.isNotEmpty(dynamicFormWrapperObj.ReferralSignature))
                newCaseObj.ParentContentDocumentId__c = newCaseObj.ReferalContentDocumetId__c;
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
                System.debug('else condition');
                if(message != null)
                    RestContext.response.responseBody = Blob.valueOf('{"Status": "Failure", "StatusCode": "400", "message": "'+message+'"}');
                else
                    RestContext.response.responseBody = Blob.valueOf('{"Status":"Failure", "StatusCode":"400"}');
                RestContext.response.statusCode = 400;
            }
            System.debug(RestContext.response.responseBody);
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
    
    public static DynamicFormWrapper assignWrapperFields(Map<String,Dynamic_Flow__mdt> FromScreenVSDynamicFlowMap, Map<String, List<DynamicFormWrapper.innerfield>> ScreenRelatedDynamicFormListMap, Set<String> savedScreens){
        List<DynamicFormWrapper.Mother> MotherObj = new List<DynamicFormWrapper.Mother>();
        List<DynamicFormWrapper.Father> FatherObj = new List<DynamicFormWrapper.Father>();
        List<DynamicFormWrapper.Legal_Guardian> LegalGuardianObj = new List<DynamicFormWrapper.Legal_Guardian>();
        List<DynamicFormWrapper.Social_Worker> SocialWorkerrObj = new List<DynamicFormWrapper.Social_Worker>();
        List<DynamicFormWrapper.Case_Worker> CaseWorkerObj = new List<DynamicFormWrapper.Case_Worker>();
        List<DynamicFormWrapper.Doctor> DoctorObj = new List<DynamicFormWrapper.Doctor>();
        List<DynamicFormWrapper.Child> ChildObj = new List<DynamicFormWrapper.Child>();
        List<DynamicFormWrapper.Family_Members> FamilyMembersObj = new List<DynamicFormWrapper.Family_Members>();
        DynamicFormWrapper DynamicFormWrapperObj = new DynamicFormWrapper();
        for(String screenString : FromScreenVSDynamicFlowMap.keySet()){
            if(FromScreenVSDynamicFlowMap.containsKey(screenString)){
                if(FromScreenVSDynamicFlowMap.get(screenString) != null){
                    if(FromScreenVSDynamicFlowMap.get(screenString).Relationship__c == 'Mother'){
                        DynamicFormWrapper.Mother wrapperObj = new DynamicFormWrapper.Mother();
                        wrapperObj.title = FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c;
                        wrapperObj.content = FromScreenVSDynamicFlowMap.get(screenString).Screen_Content__c;
                        wrapperObj.ToScreen = FromScreenVSDynamicFlowMap.get(screenString).To_Screen__c;
                        wrapperObj.saveDetails = FromScreenVSDynamicFlowMap.get(screenString).Save_Details__c;
                        if(savedScreens != null && savedScreens.contains(FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c))
                            wrapperObj.saved = true;
                        else
                            wrapperObj.saved = FromScreenVSDynamicFlowMap.get(screenString).Saved__c;
                        wrapperObj.groups = FromScreenVSDynamicFlowMap.get(screenString).Group__c;
                        wrapperObj.priority = Integer.valueOf(FromScreenVSDynamicFlowMap.get(screenString).Priority__c);
                        wrapperObj.dynamic = FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c;
                        wrapperObj.nextScreenDependent = FromScreenVSDynamicFlowMap.get(screenString).Next_Screen_Dependent__c;
                        if(ScreenRelatedDynamicFormListMap.get(screenString) ==  null || FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c == true){
                            List<DynamicFormWrapper.innerfield> innerfieldObj = new List<DynamicFormWrapper.innerfield>();
                            wrapperObj.innerfield = innerfieldObj;
                        }
                        else{
                            wrapperObj.innerfield = ScreenRelatedDynamicFormListMap.get(screenString);
                        }
                        if(wrapperObj != null){
                            MotherObj.add(wrapperObj);
                        } 
                    }
                    else if(FromScreenVSDynamicFlowMap.get(screenString).Relationship__c == 'Father'){
                        DynamicFormWrapper.Father wrapperObj = new DynamicFormWrapper.Father();
                        wrapperObj.title = FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c;
                        wrapperObj.content = FromScreenVSDynamicFlowMap.get(screenString).Screen_Content__c;
                        wrapperObj.ToScreen = FromScreenVSDynamicFlowMap.get(screenString).To_Screen__c;
                        wrapperObj.saveDetails = FromScreenVSDynamicFlowMap.get(screenString).Save_Details__c;
                        if(savedScreens != null && savedScreens.contains(FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c))
                            wrapperObj.saved = true;
                        else
                            wrapperObj.saved = FromScreenVSDynamicFlowMap.get(screenString).Saved__c;
                        wrapperObj.groups = FromScreenVSDynamicFlowMap.get(screenString).Group__c;
                        wrapperObj.priority = Integer.valueOf(FromScreenVSDynamicFlowMap.get(screenString).Priority__c);
                        wrapperObj.dynamic = FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c;
                        wrapperObj.nextScreenDependent = FromScreenVSDynamicFlowMap.get(screenString).Next_Screen_Dependent__c;
                        if(ScreenRelatedDynamicFormListMap.get(screenString) ==  null || FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c == true){
                            List<DynamicFormWrapper.innerfield> innerfieldObj = new List<DynamicFormWrapper.innerfield>();
                            wrapperObj.innerfield = innerfieldObj;
                        }
                        else{
                            wrapperObj.innerfield = ScreenRelatedDynamicFormListMap.get(screenString);
                        }
                        if(wrapperObj != null){
                            FatherObj.add(wrapperObj);
                        }
                    }
                    else if(FromScreenVSDynamicFlowMap.get(screenString).Relationship__c == 'Legal_Guardian'){
                        DynamicFormWrapper.Legal_Guardian wrapperObj = new DynamicFormWrapper.Legal_Guardian();
                        wrapperObj.title = FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c;
                        wrapperObj.content = FromScreenVSDynamicFlowMap.get(screenString).Screen_Content__c;
                        wrapperObj.ToScreen = FromScreenVSDynamicFlowMap.get(screenString).To_Screen__c;
                        wrapperObj.saveDetails = FromScreenVSDynamicFlowMap.get(screenString).Save_Details__c;
                        if(savedScreens != null && savedScreens.contains(FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c))
                            wrapperObj.saved = true;
                        else
                            wrapperObj.saved = FromScreenVSDynamicFlowMap.get(screenString).Saved__c;
                        wrapperObj.groups = FromScreenVSDynamicFlowMap.get(screenString).Group__c;
                        wrapperObj.priority = Integer.valueOf(FromScreenVSDynamicFlowMap.get(screenString).Priority__c);
                        wrapperObj.dynamic = FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c;
                        wrapperObj.nextScreenDependent = FromScreenVSDynamicFlowMap.get(screenString).Next_Screen_Dependent__c;
                        if(ScreenRelatedDynamicFormListMap.get(screenString) ==  null || FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c == true){
                            List<DynamicFormWrapper.innerfield> innerfieldObj = new List<DynamicFormWrapper.innerfield>();
                            wrapperObj.innerfield = innerfieldObj;
                        }
                        else{
                            wrapperObj.innerfield = ScreenRelatedDynamicFormListMap.get(screenString);
                        }
                        if(wrapperObj != null){
                            LegalGuardianObj.add(wrapperObj);
                        }
                    }
                    else if(FromScreenVSDynamicFlowMap.get(screenString).Relationship__c == 'Social_Worker'){
                        DynamicFormWrapper.Social_Worker wrapperObj = new DynamicFormWrapper.Social_Worker();
                        wrapperObj.title = FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c;
                        wrapperObj.content = FromScreenVSDynamicFlowMap.get(screenString).Screen_Content__c;
                        wrapperObj.ToScreen = FromScreenVSDynamicFlowMap.get(screenString).To_Screen__c;
                        wrapperObj.saveDetails = FromScreenVSDynamicFlowMap.get(screenString).Save_Details__c;
                        if(savedScreens != null && savedScreens.contains(FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c))
                            wrapperObj.saved = true;
                        else
                            wrapperObj.saved = FromScreenVSDynamicFlowMap.get(screenString).Saved__c;
                        wrapperObj.groups = FromScreenVSDynamicFlowMap.get(screenString).Group__c;
                        wrapperObj.priority = Integer.valueOf(FromScreenVSDynamicFlowMap.get(screenString).Priority__c);
                        wrapperObj.dynamic = FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c;
                        wrapperObj.nextScreenDependent = FromScreenVSDynamicFlowMap.get(screenString).Next_Screen_Dependent__c;
                        if(ScreenRelatedDynamicFormListMap.get(screenString) ==  null || FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c == true){
                            List<DynamicFormWrapper.innerfield> innerfieldObj = new List<DynamicFormWrapper.innerfield>();
                            wrapperObj.innerfield = innerfieldObj;
                        }
                        else{
                            wrapperObj.innerfield = ScreenRelatedDynamicFormListMap.get(screenString);
                        }
                        if(wrapperObj != null){
                            SocialWorkerrObj.add(wrapperObj);
                        }
                    }
                    else  if(FromScreenVSDynamicFlowMap.get(screenString).Relationship__c == 'Case_Worker'){
                        DynamicFormWrapper.Case_Worker wrapperObj = new DynamicFormWrapper.Case_Worker();
                        wrapperObj.title = FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c;
                        wrapperObj.content = FromScreenVSDynamicFlowMap.get(screenString).Screen_Content__c;
                        wrapperObj.ToScreen = FromScreenVSDynamicFlowMap.get(screenString).To_Screen__c;
                        wrapperObj.saveDetails = FromScreenVSDynamicFlowMap.get(screenString).Save_Details__c;
                        if(savedScreens != null && savedScreens.contains(FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c))
                            wrapperObj.saved = true;
                        else
                            wrapperObj.saved = FromScreenVSDynamicFlowMap.get(screenString).Saved__c;
                        wrapperObj.groups = FromScreenVSDynamicFlowMap.get(screenString).Group__c;
                        wrapperObj.priority = Integer.valueOf(FromScreenVSDynamicFlowMap.get(screenString).Priority__c);
                        wrapperObj.dynamic = FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c;
                        wrapperObj.nextScreenDependent = FromScreenVSDynamicFlowMap.get(screenString).Next_Screen_Dependent__c;
                        if(ScreenRelatedDynamicFormListMap.get(screenString) ==  null || FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c == true){
                            List<DynamicFormWrapper.innerfield> innerfieldObj = new List<DynamicFormWrapper.innerfield>();
                            wrapperObj.innerfield = innerfieldObj;
                        }
                        else{
                            wrapperObj.innerfield = ScreenRelatedDynamicFormListMap.get(screenString);
                        }
                        if(wrapperObj != null){
                            CaseWorkerObj.add(wrapperObj);
                        }
                    }
                    else if(FromScreenVSDynamicFlowMap.get(screenString).Relationship__c == 'Doctor'){
                        DynamicFormWrapper.Doctor wrapperObj = new DynamicFormWrapper.Doctor();
                        wrapperObj.title = FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c;
                        wrapperObj.content = FromScreenVSDynamicFlowMap.get(screenString).Screen_Content__c;
                        wrapperObj.ToScreen = FromScreenVSDynamicFlowMap.get(screenString).To_Screen__c;
                        wrapperObj.saveDetails = FromScreenVSDynamicFlowMap.get(screenString).Save_Details__c;
                        if(savedScreens != null && savedScreens.contains(FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c))
                            wrapperObj.saved = true;
                        else
                            wrapperObj.saved = FromScreenVSDynamicFlowMap.get(screenString).Saved__c;
                        wrapperObj.groups = FromScreenVSDynamicFlowMap.get(screenString).Group__c;
                        wrapperObj.priority = Integer.valueOf(FromScreenVSDynamicFlowMap.get(screenString).Priority__c);
                        wrapperObj.dynamic = FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c;
                        wrapperObj.nextScreenDependent = FromScreenVSDynamicFlowMap.get(screenString).Next_Screen_Dependent__c;
                        if(ScreenRelatedDynamicFormListMap.get(screenString) ==  null || FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c == true){
                            List<DynamicFormWrapper.innerfield> innerfieldObj = new List<DynamicFormWrapper.innerfield>();
                            wrapperObj.innerfield = innerfieldObj;
                        }
                        else{
                            wrapperObj.innerfield = ScreenRelatedDynamicFormListMap.get(screenString);
                        }
                        if(wrapperObj != null){
                            DoctorObj.add(wrapperObj);
                        }
                    }
                    else if(FromScreenVSDynamicFlowMap.get(screenString).Relationship__c == 'Child'){
                        DynamicFormWrapper.Child wrapperObj = new DynamicFormWrapper.Child();
                        wrapperObj.title = FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c;
                        wrapperObj.content = FromScreenVSDynamicFlowMap.get(screenString).Screen_Content__c;
                        wrapperObj.ToScreen = FromScreenVSDynamicFlowMap.get(screenString).To_Screen__c;
                        wrapperObj.saveDetails = FromScreenVSDynamicFlowMap.get(screenString).Save_Details__c;
                        if(savedScreens != null && savedScreens.contains(FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c))
                            wrapperObj.saved = true;
                        else
                            wrapperObj.saved = FromScreenVSDynamicFlowMap.get(screenString).Saved__c;
                        wrapperObj.groups = FromScreenVSDynamicFlowMap.get(screenString).Group__c;
                        wrapperObj.priority = Integer.valueOf(FromScreenVSDynamicFlowMap.get(screenString).Priority__c);
                        wrapperObj.dynamic = FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c;
                        wrapperObj.nextScreenDependent = FromScreenVSDynamicFlowMap.get(screenString).Next_Screen_Dependent__c;
                        if(ScreenRelatedDynamicFormListMap.get(screenString) ==  null || FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c == true){
                            List<DynamicFormWrapper.innerfield> innerfieldObj = new List<DynamicFormWrapper.innerfield>();
                            wrapperObj.innerfield = innerfieldObj;
                        }
                        else{
                            wrapperObj.innerfield = ScreenRelatedDynamicFormListMap.get(screenString);
                        }
                        if(wrapperObj != null){
                            ChildObj.add(wrapperObj);
                        }
                    }
                    else if(FromScreenVSDynamicFlowMap.get(screenString).Relationship__c == 'Family_Members'){
                        DynamicFormWrapper.Family_Members wrapperObj = new DynamicFormWrapper.Family_Members();
                        wrapperObj.title = FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c;
                        wrapperObj.content = FromScreenVSDynamicFlowMap.get(screenString).Screen_Content__c;
                        wrapperObj.ToScreen = FromScreenVSDynamicFlowMap.get(screenString).To_Screen__c;
                        wrapperObj.saveDetails = FromScreenVSDynamicFlowMap.get(screenString).Save_Details__c;
                        if(savedScreens != null && savedScreens.contains(FromScreenVSDynamicFlowMap.get(screenString).From_Screen__c))
                            wrapperObj.saved = true;
                        else
                            wrapperObj.saved = FromScreenVSDynamicFlowMap.get(screenString).Saved__c;
                        wrapperObj.groups = FromScreenVSDynamicFlowMap.get(screenString).Group__c;
                        wrapperObj.priority = Integer.valueOf(FromScreenVSDynamicFlowMap.get(screenString).Priority__c);
                        wrapperObj.dynamic = FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c;
                        wrapperObj.nextScreenDependent = FromScreenVSDynamicFlowMap.get(screenString).Next_Screen_Dependent__c;
                        if(ScreenRelatedDynamicFormListMap.get(screenString) ==  null || FromScreenVSDynamicFlowMap.get(screenString).Dynamic__c == true){
                            List<DynamicFormWrapper.innerfield> innerfieldObj = new List<DynamicFormWrapper.innerfield>();
                            wrapperObj.innerfield = innerfieldObj;
                        }
                        else{
                            wrapperObj.innerfield = ScreenRelatedDynamicFormListMap.get(screenString);
                        }                                
                        if(wrapperObj != null){
                            FamilyMembersObj.add(wrapperObj);
                        }
                    }
                    DynamicFormWrapperObj.Mother = MotherObj;
                    DynamicFormWrapperObj.Father = FatherObj;
                    DynamicFormWrapperObj.Legal_Guardian = LegalGuardianObj;
                    DynamicFormWrapperObj.Social_Worker = SocialWorkerrObj;
                    DynamicFormWrapperObj.Case_Worker = CaseWorkerObj;
                    DynamicFormWrapperObj.Doctor = DoctorObj;
                    DynamicFormWrapperObj.Child = ChildObj;
                    DynamicFormWrapperObj.Family_Members = FamilyMembersObj;
                }
            }
        }
        return DynamicFormWrapperObj;
    }
    
    public static DynamicFormRest.InnerfieldDataWrapper saveFieldsDetails(Case newCaseObj, List<Case> caseList, List<DynamicFormWrapper.innerfield> innerfieldList, Set<String> usedFields){
        for(DynamicFormWrapper.innerfield innerfieldObj : innerfieldList){
            if((innerfieldObj.value !=  '' && innerfieldObj.value !=  null && String.isNotEmpty(innerfieldObj.value) && String.isNotBlank(innerfieldObj.value))  || innerfieldObj.required == false){
                if(innerfieldObj.required == false && innerfieldObj.value ==  '')
                    innerfieldObj.value = null;
                newCaseObj.Id = caseList[0].Id;
                if(innerfieldObj.type == 'checkbox' || innerfieldObj.type == 'radio'){
                    if(innerfieldObj.value == 'Yes' || innerfieldObj.value == 'true'){
                        System.debug(innerfieldObj.field);
                        newCaseObj.put(innerfieldObj.field, true);
                        usedFields.add(innerfieldObj.field);
                    }
                    else if(innerfieldObj.value == 'No' || innerfieldObj.value == 'false'){
                        newCaseObj.put(innerfieldObj.field, false);
                        usedFields.add(innerfieldObj.field);
                    }
                }
                else if(innerfieldObj.type == 'date'){
                    if(innerfieldObj.value == null || innerfieldObj.value == '')
                        newCaseObj.put(innerfieldObj.field, innerfieldObj.value);
                    else
                        newCaseObj.put(innerfieldObj.field, Date.valueOf(innerfieldObj.value));
                }
                else
                    newCaseObj.put(innerfieldObj.field, innerfieldObj.value);
            }
        }
        
        DynamicFormRest.InnerfieldDataWrapper innerfieldDataWrapperObj = new DynamicFormRest.InnerfieldDataWrapper();
        innerfieldDataWrapperObj.newCaseObj = newCaseObj;
        innerfieldDataWrapperObj.caseList = caseList;
        innerfieldDataWrapperObj.usedFields = usedFields;
        return innerfieldDataWrapperObj;
    }
    
    public class InnerfieldDataWrapper{
        public Case newCaseObj {get;set;}
        public List<Case> caseList {get;set;}
        public Set<String> usedFields {get;set;}
    }
    
}
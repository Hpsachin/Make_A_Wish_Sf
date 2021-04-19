public class ApproveSuperAdmin_Handler {
    
    @AuraEnabled
    public static FormWrapper getFormDetails(String caseId){
        try {
            FormWrapper formWrapperObj = new FormWrapper();
            if(caseId != null && String.isNotEmpty(caseId) && String.isNotBlank(caseId)){
                List<Case> caseList = new List<Case>();
                caseList = [SELECT Form_Completed__c, CaseNumber, R_First_Name__c, R_Surname__c, Status, Fit_For_Wish__c, Specification_Related_Medical_Condition__c, Specification_Related_Wish__c FROM Case WHERE Id =: caseId LIMIT 1];
                System.debug(caseList[0].Status);
                if(caseList.size() > 0 && caseList[0].Form_Completed__c != null && caseList[0].Form_Completed__c == 100){
                    if(caseList[0].Fit_For_Wish__c != null && caseList[0].Specification_Related_Wish__c!= null && caseList[0].Specification_Related_Medical_Condition__c!= null){
                        if(caseList[0].Fit_For_Wish__c == true){
                            formWrapperObj.FitforWish = 'Yes';
                        }
                        else{
                            formWrapperObj.FitforWish = 'No';
                        }
                        
                        formWrapperObj.AnySpecificationRelatedtowish = caseList[0].Specification_Related_Wish__c;
                        formWrapperObj.AnyspecificationRelatedtoMrdical = caseList[0].Specification_Related_Medical_Condition__c;
                    }
                    if(caseList.size() > 0){
                        DynamicFormWrapper dynamicFormWrapperObj = DynamicFormRest.DynamicFormExistingDetails(caseList[0].CaseNumber, false);
                        if(dynamicFormWrapperObj != null){
                            System.debug(dynamicFormWrapperObj);
                            formWrapperObj.DynamicFormWrapperObj = dynamicFormWrapperObj;
                            if(caseList[0].R_First_Name__c != null)
                                formWrapperObj.FirstName = caseList[0].R_First_Name__c;
                            if(caseList[0].R_Surname__c != null)
                                formWrapperObj.LastName = caseList[0].R_Surname__c;
                            if(caseList[0].Status != null)
                                formWrapperObj.Status = caseList[0].Status;
                        }
                    }
                }
                else{
                    return null;
                }
            }
            if(formWrapperObj != null)
                return formWrapperObj;
        } 
        catch (Exception e) {
            System.debug('Exception: '+e.getMessage() +' At Line: '+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public static String saveForm(String caseId, String specificationRelatedToMedicalCondition, String fitForWish, String specificationRelatedToWish){
        try {
            if(caseId != null){
                List<Case> caseList = new List<Case>();
                caseList = [SELECT Id, R_First_Name__c, R_Email__c, Not_New_Fields__c FROM Case WHERE Id =: caseId LIMIT 1];
                Case caseObj = new Case();
                caseObj.Id = caseId;
                if(fitForWish == 'Yes'){
                    caseObj.Fit_For_Wish__c = true;
                    caseObj.Status = 'Approved';
                    caseObj.Not_New_Fields__c = caseList[0].Not_New_Fields__c + ', ' + 'Fit_For_Wish__c';
                    WishClass.convert(caseList[0].Id);
                    SendEmailClass.sendEmailMethod1('Application Form Approved', caseList[0], caseList[0].R_Email__c);
                }
                else if(fitForWish == 'No'){
                    caseObj.Fit_For_Wish__c = false;
                    caseObj.Status = 'Rejected';
                    caseObj.Not_New_Fields__c = caseList[0].Not_New_Fields__c + ', ' + 'Fit_For_Wish__c';
                    SendEmailClass.sendEmailMethod1('Application Form Rejected', caseList[0], caseList[0].R_Email__c);
                }
                caseObj.Specification_Related_Wish__c = specificationRelatedToWish;
                caseObj.Specification_Related_Medical_Condition__c = specificationRelatedToMedicalCondition;
                if(caseObj.Id != null){
                    update caseObj;
                    return 'Success';
                }
            }
        } catch (Exception e) {
            System.debug('Exception: '+e.getMessage() +' At Line: '+e.getLineNumber());
        }
        return null;
    }
    
    public class FormWrapper{
        @AuraEnabled public DynamicFormWrapper DynamicFormWrapperObj{get;set;}
        @AuraEnabled public String FirstName{get;set;}
        @AuraEnabled public String LastName{get;set;}
        @AuraEnabled public String Status{get;set;}
        @AuraEnabled public String FitforWish{get;set;}
        @AuraEnabled public String AnySpecificationRelatedtowish{get;set;}
        @AuraEnabled public String AnyspecificationRelatedtoMrdical{get;set;}
    }
    
}
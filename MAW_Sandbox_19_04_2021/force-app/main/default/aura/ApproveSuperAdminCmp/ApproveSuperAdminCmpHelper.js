({
    doInitHelper : function(c, e, h) {
        var action = c.get('c.getFormDetails');
        action.setParams({
            caseId : c.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var getValues = response.getReturnValue();
                if(!$A.util.isEmpty(getValues) && getValues !=null){
                    if(getValues.FirstName != null)
                        c.set('v.firstName', getValues.FirstName);
                    if(getValues.LastName != null)
                        c.set('v.lastName', getValues.LastName);
                    if(!$A.util.isEmpty(getValues.Status) && getValues.Status != null && getValues.Status != 'Pending'){
                        c.set('v.status',getValues.Status);
                        c.set('v.isUpdated', true);
                    }
                    if(!$A.util.isEmpty(getValues.FitforWish) && !$A.util.isEmpty(getValues.AnySpecificationRelatedtowish) && !$A.util.isEmpty(getValues.AnyspecificationRelatedtoMrdical)){
                        c.set('v.fitForWish', getValues.FitforWish);
                        c.set('v.specificationRelatedToWish', getValues.AnySpecificationRelatedtowish);
                        c.set('v.specificationRelatedToMedicalCondition', getValues.AnyspecificationRelatedtoMrdical);
                    }
                    if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj) && getValues.DynamicFormWrapperObj != null){
                        if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Mother) && getValues.DynamicFormWrapperObj.Mother != null){
                            c.set('v.formDetails', getValues.DynamicFormWrapperObj.Mother);
                            var group = [];
                            for(var each of getValues.DynamicFormWrapperObj.Mother){
                                if(!group.includes(each.groups) && each.groups != 'None'){
                                    group.push(each.groups);
                                }
                                
                            }
                            c.set('v.group',group);
                            c.set('v.relationshipToChild', 'Mother');
                        }
                        else if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Father) && getValues.DynamicFormWrapperObj.Father != null){
                            c.set('v.formDetails', getValues.DynamicFormWrapperObj.Father);
                            var group = [];
                            for(var each of getValues.DynamicFormWrapperObj.Father){
                                if(!group.includes(each.groups) && each.groups != 'None'){
                                    group.push(each.groups);
                                }
                                
                            }
                            c.set('v.group',group);
                            c.set('v.relationshipToChild', 'Father');
                        }
                            else if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Legal_Guardian) && getValues.DynamicFormWrapperObj.Legal_Guardian != null){
                                c.set('v.formDetails', getValues.DynamicFormWrapperObj.Legal_Guardian);
                                var group = [];
                                for(var each of getValues.DynamicFormWrapperObj.Legal_Guardian){
                                    if(!group.includes(each.groups) && each.groups != 'None'){
                                        group.push(each.groups);
                                    }
                                    
                                }
                                c.set('v.group',group);
                                c.set('v.relationshipToChild', 'Legal Guardian');
                            }
                                else if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Social_Worker) && getValues.DynamicFormWrapperObj.Social_Worker != null){
                                    c.set('v.formDetails', getValues.DynamicFormWrapperObj.Social_Worker);
                                    var group = [];
                                    for(var each of getValues.DynamicFormWrapperObj.Social_Worker){
                                        if(!group.includes(each.groups) && each.groups != 'None'){
                                            group.push(each.groups);
                                        }
                                        
                                    }
                                    c.set('v.group',group);
                                    c.set('v.relationshipToChild', 'Social Worker');
                                }
                                    else if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Case_Worker) && getValues.DynamicFormWrapperObj.Case_Worker != null){
                                        c.set('v.formDetails', getValues.DynamicFormWrapperObj.Case_Worker);
                                        var group = [];
                                        for(var each of getValues.DynamicFormWrapperObj.Case_Worker){
                                            if(!group.includes(each.groups) && each.groups != 'None'){
                                                group.push(each.groups);
                                            }
                                            
                                        }
                                        c.set('v.group',group);
                                        c.set('v.relationshipToChild', 'Case Worker');
                                    }
                                        else if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Doctor) && getValues.DynamicFormWrapperObj.Doctor != null){
                                            c.set('v.formDetails', getValues.DynamicFormWrapperObj.Doctor);
                                            var group = [];
                                            for(var each of getValues.DynamicFormWrapperObj.Doctor){
                                                if(!group.includes(each.groups) && each.groups != 'None'){
                                                    group.push(each.groups);
                                                }
                                                
                                            }
                                            c.set('v.group',group);
                                            c.set('v.relationshipToChild', 'Doctor');
                                        }
                                            else if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Child) && getValues.DynamicFormWrapperObj.Child != null){
                                                c.set('v.formDetails', getValues.DynamicFormWrapperObj.Child);
                                                var group = [];
                                                for(var each of getValues.DynamicFormWrapperObj.Child){
                                                    if(!group.includes(each.groups) && each.groups != 'None'){
                                                        group.push(each.groups);
                                                    }
                                                    
                                                }
                                                c.set('v.group',group);
                                                c.set('v.relationshipToChild', 'Child');
                                            }
                                                else if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Family_Members) && getValues.DynamicFormWrapperObj.Family_Members != null){
                                                    c.set('v.formDetails', getValues.DynamicFormWrapperObj.Family_Members);
                                                    var group = [];
                                                    for(var each of getValues.DynamicFormWrapperObj.Family_Members){
                                                        if(!group.includes(each.groups) && each.groups != 'None'){
                                                            group.push(each.groups);
                                                        }
                                                        
                                                    }
                                                    c.set('v.group',group);
                                                    c.set('v.relationshipToChild', 'Family Members');
                                                }
                        if(!$A.util.isEmpty(getValues.DynamicFormWrapperObj.Family) && getValues.DynamicFormWrapperObj.Family != null)
                            c.set('v.familyDetails', getValues.DynamicFormWrapperObj.Family);
                    }
                }
                else{
                    console.log('getValues ::: '+JSON.stringify(getValues));
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    h.showToastMessage(c, e, h, 'Application form is incomplete.', 'Error', 'error');
                }
            }
            else{
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
                h.showToastMessage(c, e, h, 'Something went wrong.', 'Error', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    clickHelper : function(c, e, h){
        var action = c.get('c.saveForm');
        action.setParams({
            caseId : c.get('v.recordId'),
            specificationRelatedToMedicalCondition : c.get('v.specificationRelatedToMedicalCondition'),
            fitForWish : c.get('v.fitForWish'),
            specificationRelatedToWish : c.get('v.specificationRelatedToWish')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var getValues = response.getReturnValue();
                if(!$A.util.isEmpty(getValues) && getValues !=null && getValues == 'Success'){
                    c.set('v.isUpdated', true);
                    h.showToastMessage(c, e, h, 'Form has been successfully updated.', 'Success', 'success');
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    h.showToastMessage(c, e, h, 'Sommething went wrong.', 'Error', 'error');
                }
            }
            else{
                h.showToastMessage(c, e, h, 'Sommething went wrong..', 'Error', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    showToastMessage : function(c, e, h, message, title, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
})
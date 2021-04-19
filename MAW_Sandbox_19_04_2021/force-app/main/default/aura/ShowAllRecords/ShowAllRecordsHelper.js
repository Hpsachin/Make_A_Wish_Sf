({
    onChange_h : function(c, e, h) {
        c.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Email', fieldName: 'Email', type: 'email'}
        ]);
        var value = c.find('select').get('v.value');
        var action = c.get("c.showAllRecordApex");
        action.setParams({
            selectedRecordType : value,
            caseId : c.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var responseValue = response.getReturnValue();
                c.set('v.data', responseValue.ContactList);
                c.set('v.selectedRows', responseValue.IdSet);
                c.set('v.lookupName', responseValue.LookupName);
            }
        });
        $A.enqueueAction(action);
    },    
    onSave_h : function(c, e, h) {
        var idstring = c.get("v.stringOfIds");
        var value = c.find('select').get('v.value');
        var action = c.get("c.saveApex");
        action.setParams({
            stringOfIds : idstring,
            selectedValue : value,
            caseId : c.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                c.set("v.showTable",false);
                c.find('select').set('v.value','');
                h.showToastMessage(c, e, h, 'The selected ' + c.get('v.role') + 's are associated successfully with this application.', 'Success', 'success');
            }
            else
                h.showToastMessage(c, e, h, 'Something went wrong.', 'Error', 'error');
        });
        $A.enqueueAction(action);
    },
    showToastMessage : function(c, e, h, message, title, type){
        var toast = $A.get("e.force:showToast");
        toast.setParams({
            title : title,
            message: message,
            type: type
        });
        toast.fire();
    }
})
({
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
    },
    doInit : function(c, e, h){
        h.doInitHelper(c, e, h);
    },
    handleClick : function(c, e, h){
        var allValid = c.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(!allValid){
            h.showToastMessage(c, e, h, 'Please fill the valid entries in required fields and try again.', 'Error', 'error');
        }
        else{
            if(c.get('v.isUpdated') == false){
                var val = e.getSource().get('v.value');
                if(c.get('v.fitForWish') == 'Yes')
                    c.set('v.status', 'Approved');
                else if(c.get('v.fitForWish') == 'No')
                    c.set('v.status', 'Rejected');
                h.clickHelper(c, e, h);
                
            }else{
                var val = c.get('v.status');
                h.showToastMessage(c, e, h, 'Status has been already '+val, 'Error', 'error');
            }
        }
    },
    handleInput : function(c, e, h){
        var val = e.getSource().get('v.value');
        e.getSource().set('v.value', val.trim());
    }
})
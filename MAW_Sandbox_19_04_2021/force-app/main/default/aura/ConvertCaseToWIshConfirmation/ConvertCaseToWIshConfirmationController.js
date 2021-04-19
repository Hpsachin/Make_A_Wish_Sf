({
    closeModal: function (component, event, helper) {
        
        component.destroy();

    },

    navigateToRecord : function(component, event, helper) {

        var wishRecordId = component.get("v.wishRecordId");
        var navEvent = $A.get("e.force:navigateToSObject");
        if(navEvent){
            navEvent.setParams({
                  recordId: wishRecordId,
                  slideDevName: "detail"
            });
            navEvent.fire(); 
        }
        else{
            window.location.href = '/one/one.app#/sObject/'+wishRecordId+'/view'
        }
    }
})
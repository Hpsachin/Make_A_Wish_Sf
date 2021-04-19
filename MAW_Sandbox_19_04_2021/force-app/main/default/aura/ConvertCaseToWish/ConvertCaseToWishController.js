({

    startProcess: function (component, event, helper) {

        component.set('v.renderModalDialogue', true);

    },

    closeModal: function (component, event, helper) {

        component.set('v.renderModalDialogue', false);
        component.set('v.renderConfirmation', false);
        component.set('v.renderError', false);

        //Refresh the detail view
        $A.get('e.force:refreshView').fire();

    },

    yesResponse: function (component, event, helper) {

        //Render Spinner
        component.set("v.renderSpinner", true);

        //Convert Case
        helper.convertCase(component);

    },

})
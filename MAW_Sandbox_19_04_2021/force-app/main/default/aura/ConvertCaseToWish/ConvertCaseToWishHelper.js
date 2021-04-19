({
	convertCase: function (component) {

		// create a one-time use instance of the serverEcho action
		// in the server-side controller
		var action = component.get("c.caseToWish");
		action.setParams({ "caseId": component.get("v.recordId") });

		// Create a callback that is executed after 
		// the server-side action returns
		action.setCallback(this, function (response) {

			//Hide the Spinner
			component.set("v.renderSpinner", false);

			var state = response.getState();
			if (state === "SUCCESS") {

				// Alert the user with the value returned 
				// from the server
				component.set("v.wishRecordId", response.getReturnValue());
				component.set("v.renderConfirmation", true);
				
				// You would typically fire a event here to trigger 
				// client-side notification that the server-side 
				// action is complete

			}
			else if (state === "INCOMPLETE") {
				// do something
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.renderError", true);
						component.set("v.errorMessage", errors[0].message);
					}
					
				} else {
					component.set("v.renderError", true);
					component.set("v.errorMessage", "Unknown error");
				}
			}

		});

		// optionally set storable, abortable, background flag here

		// A client-side action could cause multiple events, 
		// which could trigger other events and 
		// other server-side action calls.
		// $A.enqueueAction adds the server-side action to the queue.
		$A.enqueueAction(action);

	}
})
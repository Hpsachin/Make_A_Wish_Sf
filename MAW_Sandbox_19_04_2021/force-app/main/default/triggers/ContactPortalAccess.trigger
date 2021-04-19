trigger ContactPortalAccess on Contact (after insert, after update) {
  /*Set<Id> updateContactIds = new Set<Id>();

  for (Contact c : Trigger.new) {
    if (c.Volunteer_Status__c != null && (c.Volunteer_Status__c == 'Activate' || c.Volunteer_Status__c == 'Deactivate'))
      updateContactIds.add(c.Id);
  }

  if (!updateContactIds.isEmpty()) {
    List<Contact> updateContacts = new List<Contact>([SELECT Id, Volunteer_Status__c, Volunteer_Status_Error__c, Community_User_Id__c FROM Contact WHERE Id IN :updateContactIds]);

    if (!updateContacts.isEmpty())
      System.enqueueJob(new ContactPortalToggle(updateContacts));

  }*/
}
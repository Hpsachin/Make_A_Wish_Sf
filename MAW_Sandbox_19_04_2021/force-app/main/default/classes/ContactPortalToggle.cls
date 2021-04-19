public class ContactPortalToggle implements Queueable {
  private List<Contact> portalToggleContacts;

  public ContactPortalToggle(List<Contact> contacts) {
    this.portalToggleContacts = contacts;
  }

  public void execute(QueueableContext qc) {
    List<Contact> portalStatusContacts = new List<Contact>();

    for (Contact c : portalToggleContacts) {
      try {
        // 'Active' added to run EnablePortalContact for assigning new PermissionSet for Portal
        if (c.Volunteer_Status__c == 'Activate') {
          User u = PortalContactUtility.EnablePortalContact(c.Id);
          c.Volunteer_Status__c = 'Active';
          c.Volunteer_Status_Error__c  = null;
          c.Community_User_Id__c = u.Id;
        } else if (c.Volunteer_Status__c == 'Deactivate' && PortalContactUtility.DisablePortalContact(c.Id)) {
          c.Volunteer_Status__c = 'Inactive';
          c.Volunteer_Status_Error__c  = null;
        }
      } catch (Exception e) {
        c.Volunteer_Status__c = 'Error';
        c.Volunteer_Status_Error__c  = e.getMessage() + e.getLineNumber() + e.getStackTraceString();

        if (c.Volunteer_Status_Error__c.length() > 3000)
          c.Volunteer_Status_Error__c  = c.Volunteer_Status_Error__c .substring(0, 3000);
      } finally {
        System.debug('ContactPortalToggle: contact: ' + c);
          portalStatusContacts.add(c);
      }
    }

    if (!portalStatusContacts.isEmpty() && !Test.isRunningTest())
      System.enqueueJob(new ContactPortalStatus(portalStatusContacts));
  }
}
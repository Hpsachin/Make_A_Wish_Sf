@isTest
private class PortalContactUtilityTest {
    
  public static testMethod void testContactPortalAccessTrigger() {
    Portal_Settings__c sets = createSettings();

    Account a = new Account(Name='Johnny Boys');
    insert a;

    Contact c = new Contact(FirstName='Johnny', LastName='Doey', Email='johnny@doey.org', Volunteer_Status__c='Activate', AccountId=a.Id);
    c.External_ID__c = c.FirstName.substring(0, 1) + c.LastName + c.Email;

    Test.startTest();

    insert c;

    Test.stopTest();
  }

  public static testMethod void testContactPortalStatusQueueable() {
    Portal_Settings__c sets = createSettings();

    List<Contact> cons = new List<Contact>{
      new Contact(FirstName='A', LastName='B', Email='a@b.org'),
      new Contact(FirstName='C', LastName='D', Email='c@d.org')
    };

    insert cons;

    Set<Id> conIds = new Set<Id>{cons[0].Id, cons[1].Id};

    //for (Contact c : cons)
    //  c.Anemia__c = true;

    Test.startTest();

    System.enqueueJob(new ContactPortalStatus(cons));

    Test.stopTest();
  }

  public static testMethod void testContactPortalToggle() {
    Portal_Settings__c sets = createSettings();

    User runningUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];

    User existingActive;
    User existingDisabled;

    Account a = new Account(Name='No User Yet');
    
    try {
      User noRoleUser = [SELECT Id FROM User WHERE UserRoleId = '' AND IsActive = true AND UserType = 'Standard' LIMIT 1];
      if (noRoleUser != null)
        a.OwnerId = noRoleUser.Id;
    } catch (Exception e) { }
    insert a;

    System.debug('a (norole?): ' + a);

    Contact noUserYet = new Contact(FirstName='No', LastName='User', Email='No@User.org', AccountId=a.Id);
    insert noUserYet;

    System.runAs(runningUser) {
      existingActive = createUser(true, sets.Profile_Id__c);
      existingDisabled = createUser(false, sets.Profile_Id__c);

      Contact existingAc = [SELECT Id, Volunteer_Status__c FROM Contact WHERE Id =: existingActive.ContactId];
      Contact existingDis = [SELECT Id, Volunteer_Status__c FROM Contact WHERE Id =: existingDisabled.ContactId];

      existingAc.Volunteer_Status__c = 'Deactivate';
      existingDis.Volunteer_Status__c = 'Activate';
      noUserYet.Volunteer_Status__c = 'Activate';

      Test.startTest();

      System.enqueueJob(new ContactPortalToggle(new List<Contact>{existingAc, existingDis, noUserYet}));

      Test.stopTest();
    }
  }

  public static testMethod void testContactPortalToggleError() {
    Portal_Settings__c sets = createSettings();
    Contact c = new Contact(LastName='BOOM'); // will fail PortalContactUtility.ValidateContact
    insert c;

    Test.startTest();

    c.Volunteer_Status__c = 'Activate';
    System.enqueueJob(new ContactPortalToggle(new List<Contact>{c}));

    Test.stopTest();
  }

  public static testMethod void testNoSettings() {
    Test.startTest();

    try {
      Portal_Settings__c sets = PortalContactUtility.PortalSettings;
    } catch (Exception e) { }

    Test.stopTest();
  }

  public static testMethod void testBadSettings() {
    Portal_Settings__c sets = new Portal_Settings__c(Profile_Id__c='a', User_Id_with_Role_Id__c='b');
    insert sets;

    Test.startTest();

    try {
      sets = PortalContactUtility.PortalSettings;
    } catch (Exception e) {}

    Test.stopTest();
  }

  public static testMethod void testContactErrors() {
    Portal_Settings__c sets = createSettings();
    Contact isDeleted = new Contact(LastName='Delete Me');
    Contact isInvalid = new Contact(LastName='Lasty');
    insert new List<Contact>{isDeleted, isInvalid};
    Id delId = isDeleted.Id;
    delete isDeleted;

    Test.startTest();

    try {
      PortalContactUtility.DisablePortalContact(null);
    } catch (Exception e) { }

    try {
      PortalContactUtility.DisablePortalContact(delId);
    } catch (Exception e) { }

    try {
      PortalContactUtility.DisablePortalContact(isInvalid.Id);
    } catch (Exception e) { }

    try {
      PortalContactUtility.EnablePortalContact(null);
    } catch (Exception e) { }

    try {
      PortalContactUtility.EnablePortalContact(delId);
    } catch (Exception e) { }

    try {
      PortalContactUtility.EnablePortalContact(isInvalid.Id);
    } catch (Exception e) { }

    Test.stopTest();
  }

  private static Portal_Settings__c createSettings() {
    Profile CommunityProfile = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' LIMIT 1];
    User u = [SELECT Id FROM User WHERE UserRoleId != '' AND IsActive = TRUE LIMIT 1];

    Portal_Settings__c sets = new Portal_Settings__c(Profile_Id__c=CommunityProfile.Id, User_Id_with_Role_Id__c=u.Id);
    insert sets;

    return sets;
  }

  private static User createUser(Boolean userActive, Id profileId) {
    Account a = new Account(Name=EncodingUtil.convertToHex(Crypto.generateAesKey(128)));
    insert a;

    Contact c = new Contact(FirstName='Bob', LastName=EncodingUtil.convertToHex(Crypto.generateAesKey(128)), Email=EncodingUtil.convertToHex(Crypto.generateAesKey(128)) + '@c.org', AccountId=a.Id);
    insert c;

    User u = new User(
      IsActive=userActive,
      ContactId=c.Id,
      ProfileId=profileId,
      EmailEncodingKey='UTF-8',
      LocaleSidKey='en_AU',
      LanguageLocaleKey='en_US',
      TimeZoneSidKey='Australia/Sydney',
      Email=c.Email,
      UserName=c.Email,
      Alias=c.Email.subString(0, 8),
      FirstName=c.FirstName,
      LastName=c.LastName
    );

    insert u;

    return u;

  }

}
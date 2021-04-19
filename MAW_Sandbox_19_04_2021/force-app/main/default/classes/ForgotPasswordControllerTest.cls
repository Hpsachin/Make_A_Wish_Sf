/**
 * An apex page controller that exposes the site forgot password functionality
 */
@IsTest public with sharing class ForgotPasswordControllerTest {
     @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        
        Id portalProfile = [SELECT Id FROM Profile WHERE Name = 'Volunteer Community'].Id; 

        Id roleId = [SELECT Id FROM UserRole WHERE Name = 'System Administrator' limit 1].Id;
        Contact u = new Contact(LastName = 'PotalUser', Email = 'test@wish.com.testwish');
        insert u;
        
        Test.startTest();
        User pUser = new User( UserRoleId = roleId, LastName = 'User', ContactId = u.Id, UserName = 'test@wish.com.testwish', Alias = 'vol', ProfileId = portalProfile, Email = 'test@wish.com', TimeZoneSidKey='Australia/Sydney', LocaleSidKey='en_AU', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US' );
        
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = 'test@wish.com.testwish';        
    	Test.stopTest();
        System.assert(controller.forgotPassword() != NULL); 
    }
}
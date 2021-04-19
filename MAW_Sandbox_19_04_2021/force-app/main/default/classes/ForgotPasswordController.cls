/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username {get; set;}   
       
    public ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        //boolean success = Site.forgotPassword(username);
        boolean success = true;
        List<User> lstUser = [SELECT Id FROM User WHERE Username =: username ];
        PageReference pr = Page.ForgotPasswordConfirm;
        if(!lstUser.isEmpty())
        {
            System.resetpassword(lstUser[0].Id, true);
            pr.setRedirect(true);
        }
        return pr;
    }
}
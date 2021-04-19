@isTest
public class agreementCase_Test {

    static testMethod void testTrigger() {
        
        Case c = new Case( Status = 'Awaiting Consent' );
        insert c;
        
        echosign_dev1__SIGN_Agreement__c e = new echosign_dev1__SIGN_Agreement__c();
        e.Case__c = c.Id;
        e.echosign_dev1__Status__c = 'Signed';
        
        insert e;
        
    }
    
}
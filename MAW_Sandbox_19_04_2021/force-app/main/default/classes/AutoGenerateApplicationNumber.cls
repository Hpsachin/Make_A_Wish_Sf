public class AutoGenerateApplicationNumber {
    public Static String applicationNumberIncrement(String applicationNo){
        
        Integer index = applicationNo.lastIndexOf('-');
        String text = applicationNo.substring(index+1);
        Integer textToNumber= Integer.valueOf(text);
        textToNumber++;
        String numberToText = String.ValueOf(textToNumber);
        String newapplicationNo = 'MAW-'+ numberToText.leftPad(8,'0');
        System.debug(newapplicationNo);
        
        return newapplicationNo;
    }
    public Static String assignApplicationNumber(){
        try{
            Autogenerate_Application__c applicationNumberObj = Autogenerate_Application__c.getValues('MAW Generator');
            String addignedNumber = applicationNumberObj.Application_Number__c;
            String numberToUpdate = applicationNumberIncrement(applicationNumberObj.Application_Number__c);
            Autogenerate_Application__c updateApplicationNumber = Autogenerate_Application__c.getValues('MAW Generator');
            updateApplicationNumber.Application_Number__c = numberToUpdate;
            update updateApplicationNumber;
            return addignedNumber;
        }
        catch(exception e){
            System.debug(e.getMessage()+' at Line Number : '+e.getLineNumber());
            return null;
        }
    }
    public static String uniqueCode(){
        String code;
        try{
            code = (String.valueof(Math.abs(Crypto.getRandomLong()))).substring(0, 6);
        }
        catch(Exception e){
            System.debug('The error is '+e.getMessage()+' in line no. '+e.getLineNumber());
        }
        return code;
    }
    
}
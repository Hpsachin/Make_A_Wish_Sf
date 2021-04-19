public class statusDisplayController {

    public Case c {get;set;}
    public String statusValues {get;set;}
    
    public statusDisplayController(ApexPages.StandardController sc) {
        
        if(!Test.isRunningTest())
            sc.addFields(new List<String> {'Status'});
        
        c = (Case)sc.getRecord();
    }
    
    public List<String> getStatus() {

        return statusValues != null ? statusValues.split(',') : null;
    }
}
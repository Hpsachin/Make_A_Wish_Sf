public class wishStatusDisplayController {

    public Wish__c w {get;set;}
    public String statusValues {get;set;}
    
    public wishStatusDisplayController(ApexPages.StandardController sc) {
        
        if(!Test.isRunningTest())
            sc.addFields(new List<String> {'Stage__c','Days_in_Stage__c', 'Status__c'});
        
        w = (Wish__c)sc.getRecord();
        
        loadStatusMap();
    }
    
    public class status {
        
        public String name {get;set;}
        public Date startDate {get;set;}
        public Date endDate {get;set;}
        public Integer daysInStage { 
            get { 
                //calc days
                if(this.startdate == null) {
                    return 0;
                } else if(this.endDate == null) {
                    return this.startdate.daysBetween(System.today());
                } else {
                	return this.startdate.daysBetween(this.endDate); 
                }
            } set;}
        
        public status(Wish_Stage_Tracking__c t) {
            
            this.name = t.Stage__c;
            this.startDate = t.Stage_Status_Start_Date__c;
            this.endDate = t.Stage_Status_End_Date__c;
        }
    }
    
    public String mapKey {get;set;}
    public Map<String, status> statusMap {get;set;}
    
    public void loadStatusMap() {

        statusMap = new Map<String, status>();
        
        for(Wish_Stage_Tracking__c wst : [SELECT Id, Stage__c, Stage_Status_Start_Date__c, Stage_Status_End_Date__c FROM Wish_Stage_Tracking__c WHERE Wish__c = :w.Id]) {
            
            if(statusMap.get(wst.Stage__c) == null) {
            //put first stage in
            
                statusMap.put(wst.Stage__c, new Status(wst));
            
            } else {
            //compare dates   
            
                statusMap.get(wst.Stage__c).startDate = statusMap.get(wst.Stage__c).startDate > wst.Stage_Status_Start_Date__c ? wst.Stage_Status_Start_Date__c : statusMap.get(wst.Stage__c).startDate;
                statusMap.get(wst.Stage__c).endDate = statusMap.get(wst.Stage__c).endDate < wst.Stage_Status_End_Date__c ? wst.Stage_Status_End_Date__c : statusMap.get(wst.Stage__c).endDate;
            }
            
        }
        
        mapKey = '';
        
        for(String key : statusMap.keySet())
            mapKey += key;

    }
    
    public List<String> getStatus() {

        List<String> result = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Wish__c.Stage__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry f : ple)
        	result.add(f.getValue());
        
        return result;
    }
}
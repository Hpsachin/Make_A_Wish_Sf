public class wishStarlightController {
    
    public String pagePassword = 'makeawish';
    
    public String passwordInput {get;set;}
    public String errorMessage {get;set;}
    
    public Boolean passwordValid {get { return passwordValid == null ? false : passwordValid; } set;}
    
    public wishStarlightController() {
        
        
    }
    
    public void checkPassword() {
        
        errorMessage = null;
        
        if(pagePassword == passwordInput) {
            passwordValid = true;
            loadData();
        } else {
            errorMessage = 'Password Invalid';
        }
    }
    
    

    public List<Case> caseList {get;set;}
    
    public void loadData() {

        caseList = new List<Case>();
        
        for(Case c : [SELECT Id, C_First_Name__c, C_Last_Name__c, C_DOB__c, C_State__c, Starlight_Response__c, Starlight_Check_Request_Date_Time__c, Starlight_Check_Received_Date_Time__c, External_Id__c FROM Case WHERE Status = 'Awaiting Starlight' AND Starlight_Response__c = NULL ORDER BY Application_Received_Date_Time__c ])
            caseList.add(c.clone());
        
    }
    
    public void saveCaseList() {
        
        System.Debug('saveCaseList: ' + caseList);
        
        List<Case> saveList = new List<Case>();
        
        for(Case c : caseList) {
            
            if(c.Starlight_Response__c != null) {
                c.Starlight_Check_Received_Date_Time__c = System.Today();
             	c.Status = 'Starlight Complete';
                saveList.add(c);
            }
        }
        
        try {
            
            if(!saveList.isEmpty())
                upsert saveList External_Id__c;
            
        } catch(Exception e) {
            
            System.Debug(e);
        }
        
        loadData();
        
    }

    
}
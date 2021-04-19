public class DynamicFormWrapper{
    
    @AuraEnabled public List<Mother> Mother {get;set;}
    @AuraEnabled public List<Father> Father {get;set;}
    @AuraEnabled public List<Legal_Guardian> Legal_Guardian {get;set;}
    @AuraEnabled public List<Social_Worker> Social_Worker {get;set;}
    @AuraEnabled public List<Case_Worker> Case_Worker {get;set;}
    @AuraEnabled public List<Doctor> Doctor {get;set;}
    @AuraEnabled public List<Child> Child {get;set;}
    @AuraEnabled public List<Family_Members> Family_Members {get;set;}
    @AuraEnabled public List<Family> Family {get;set;}
    @AuraEnabled public Set<String> GroupList {get;set;}
    @AuraEnabled public String AnyMedicalConditionSpecification{get;set;}
    @AuraEnabled public String FitForWish{get;set;}
    @AuraEnabled public String AnyWishSpecification{get;set;}
    @AuraEnabled public String ChildsCondition{get;set;}
    @AuraEnabled public String ReferralSignature{get;set;}
    @AuraEnabled public String ParentSignature{get;set;}
    @AuraEnabled public String DoctorSignature{get;set;}
    
    public class Mother {
        @AuraEnabled public String ToScreen {get;set;} 
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String content{get;set;}
        @AuraEnabled public Boolean saveDetails{get;set;}
        @AuraEnabled public Boolean saved{get;set;}
        @AuraEnabled public String groups{get;set;}
        @AuraEnabled public Integer priority{get;set;}
        @AuraEnabled public Boolean dynamic{get;set;}
        @AuraEnabled public Boolean nextScreenDependent{get;set;}
        @AuraEnabled public list<innerfield> innerfield{get;set;}
    }
    
    public class Father {
        @AuraEnabled public String ToScreen {get;set;}
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String content{get;set;}
        @AuraEnabled public Boolean saveDetails{get;set;}
        @AuraEnabled public Boolean saved{get;set;}
        @AuraEnabled public String groups{get;set;}
        @AuraEnabled public Integer priority{get;set;}
        @AuraEnabled public Boolean dynamic{get;set;}
        @AuraEnabled public Boolean nextScreenDependent{get;set;}
        @AuraEnabled public list<innerfield> innerfield{get;set;}
    }
    
    public class Legal_Guardian {
        @AuraEnabled public String ToScreen {get;set;}
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String content{get;set;}
        @AuraEnabled public Boolean saveDetails{get;set;}
        @AuraEnabled public Boolean saved{get;set;}
        @AuraEnabled public String groups{get;set;}
        @AuraEnabled public Integer priority{get;set;}
        @AuraEnabled public Boolean dynamic{get;set;}
        @AuraEnabled public Boolean nextScreenDependent{get;set;}
        @AuraEnabled public list<innerfield> innerfield{get;set;}
    }
    
    public class Social_Worker {
        @AuraEnabled public String ToScreen {get;set;}
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String content{get;set;}
        @AuraEnabled public Boolean saveDetails{get;set;}
        @AuraEnabled public Boolean saved{get;set;}
        @AuraEnabled public String groups{get;set;}
        @AuraEnabled public Integer priority{get;set;}
        @AuraEnabled public Boolean dynamic{get;set;}
        @AuraEnabled public Boolean nextScreenDependent{get;set;}
        @AuraEnabled public list<innerfield> innerfield{get;set;}
    }
    
    public class Case_Worker {
        @AuraEnabled public String ToScreen {get;set;}
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String content{get;set;}
        @AuraEnabled public Boolean saveDetails{get;set;}
        @AuraEnabled public Boolean saved{get;set;}
        @AuraEnabled public String groups{get;set;}
        @AuraEnabled public Integer priority{get;set;}
        @AuraEnabled public Boolean dynamic{get;set;}
        @AuraEnabled public Boolean nextScreenDependent{get;set;}
        @AuraEnabled public list<innerfield> innerfield{get;set;}
    }
    
    public class Doctor {
        @AuraEnabled public String ToScreen {get;set;}
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String content{get;set;}
        @AuraEnabled public Boolean saveDetails{get;set;}
        @AuraEnabled public Boolean saved{get;set;}
        @AuraEnabled public String groups{get;set;}
        @AuraEnabled public Integer priority{get;set;}
        @AuraEnabled public Boolean dynamic{get;set;}
        @AuraEnabled public Boolean nextScreenDependent{get;set;}
        @AuraEnabled public list<innerfield> innerfield{get;set;}
    }
    
    public class Child {
        @AuraEnabled public String ToScreen {get;set;} 
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String content{get;set;}
        @AuraEnabled public Boolean saveDetails{get;set;}
        @AuraEnabled public Boolean saved{get;set;}
        @AuraEnabled public String groups{get;set;}
        @AuraEnabled public Integer priority{get;set;}
        @AuraEnabled public Boolean dynamic{get;set;}
        @AuraEnabled public Boolean nextScreenDependent{get;set;}
        @AuraEnabled public list<innerfield> innerfield{get;set;}
    }
    
    public class Family_Members {
        @AuraEnabled public String ToScreen {get;set;} 
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String content{get;set;}
        @AuraEnabled public Boolean saveDetails{get;set;}
        @AuraEnabled public Boolean saved{get;set;}
        @AuraEnabled public String groups{get;set;}
        @AuraEnabled public Integer priority{get;set;}
        @AuraEnabled public Boolean dynamic{get;set;}
        @AuraEnabled public Boolean nextScreenDependent{get;set;}
        @AuraEnabled public list<innerfield> innerfield{get;set;}
    }
    
    public class innerfield{
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String cssClass{get;set;}
        @AuraEnabled public Boolean required{get;set;}
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public Boolean disabled{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String field{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public String recordType{get;set;}
        @AuraEnabled public String objectName{get;set;}
        @AuraEnabled public String placeholder{get;set;}
        @AuraEnabled public List<options> options{get;set;}
        @AuraEnabled public String errorMessage{get;set;}
        @AuraEnabled public Boolean includeNumber{get;set;}
    }
    
    public class options{
        @AuraEnabled public String text{get;set;}
        @AuraEnabled public String value{get;set;}
    }
    
    public class Family{
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String gender{get;set;}
        @AuraEnabled public String dob{get;set;}
        @AuraEnabled public String relation{get;set;}
    }
    
}
public class wishTaskController {
    
    public Wish__c wish {get;set;}
    
    
    public wishTaskController(ApexPages.StandardController sc) {
        
        wish = (Wish__c)sc.getRecord();

    }
    
    public class taskPlan implements Comparable {
        
        public String Name {get;set;}
        public Id Id {get;set;}

        public Boolean equals(Object obj) {
            taskPlan other = (taskPlan)obj;

            return (this.Name == other.Name && this.Id == other.Id);
        }

        public Integer hashCode() {
            Integer ret = 0;
            for (Integer i : String.valueOf(this.Id + this.Name).getChars())
                ret += i;

            return ret;
        }

        public Integer compareTo(Object cmp) {
            Integer otherHash = ((taskPlan)cmp).hashCode();
            Integer thisHash = this.hashCode();
            if (thisHash == otherHash)
                return 0;
            else if (thisHash > otherHash)
                return 1;
            else
                return -1;
        }
        
    }
    
    public String completedKeys {get;set;}
    
    public Map<taskPlan, List<Task>> getTaskPlanList() {
        
        Map<taskPlan, List<Task>> result = new  Map<taskPlan, List<Task>>();

        Map<Id, APTaskTemplate__c> aptMap = new Map<Id, APTaskTemplate__c>([SELECT Id, Name, Action_Plan__c, Action_Plan__r.Name FROM APTaskTemplate__c]);
        
        List<Task> tList = new List<Task>([SELECT Id, Subject, TaskTemplateId__c, Type, ActivityDate, Owner.Name, Status, Description FROM Task WHERE WhatId = :wish.Id ORDER BY Subject, ActivityDate]);
        
        for(Task t : tList) {
            
            taskPlan tp = new TaskPLan();
            tp.Name = 'Other';

            
            if(aptMap.get(t.TaskTemplateId__c) != null) {
                tp.Name = aptMap.get(t.TaskTemplateId__c).Action_Plan__r.Name;
                tp.Id = aptMap.get(t.TaskTemplateId__c).Action_Plan__c;
            }
            
            if(result.get(tp) == null) {
                result.put(tp, new List<Task>());
            }
            
            result.get(tp).add(t);
        }

        completedKeys = '';
        
        for(taskPlan tp : result.keySet()) {
            
            Boolean uncompleted = false;
            
            System.debug('result.get('+ tp +'): ' + result.get(tp));
            
            for(Task t : result.get(tp)) {
                if(t.Status != 'Completed')
                    uncompleted = true;
            }
            
            System.Debug('uncompleted: ' + uncompleted);
            
            if(!uncompleted)
                completedKeys += tp.Id;
            
            System.debug('completedKeys: ' + completedKeys);
            
        }
        
        
        return result;
        
       //return new List<Task>([SELECT Id, Subject, Type, ActivityDate, Owner.Name, Status, Description FROM Task WHERE WhatId = :campaign.Id ORDER BY Subject]);
    }
    
    public Id completeTaskId {get;set;}
    
    public void completeTask() {
        
        if(completeTaskId != null) {
            
            Task t = new Task( Id = completeTaskId, Status = 'Completed');
            update t;
        }
    }

}
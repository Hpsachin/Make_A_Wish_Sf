public class SyncUserAndContactEmail implements Database.Batchable<sObject>, Schedulable {
   public String query;

   public Database.QueryLocator start(Database.BatchableContext BC){
       if(String.isBlank(query))
           query = 'SELECT Id, ContactId, Email FROM User WHERE ContactId != null AND LastModifiedDate = Today';
       
       return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext BC, List<User> scope){
      
       Map<Id, User> mapUser = new Map<Id, User>();
       for(User oUser: scope)
       {
            mapUser.put(oUser.ContactId, oUser);    
       }
        
       List<Contact> lstCon = new List<Contact>();
       User oUserRef;
       for(Contact oCon: [SELECT Id, Email FROM Contact WHERE Id IN: mapUser.keySet()])
       {
           if(mapUser.containsKey(oCon.Id))
           {
               oUserRef = mapUser.get(oCon.Id);
               if(oUserRef.Email != oCon.Email)
               {
                   oCon.Email = oUserRef.Email;
                   lstCon.add(oCon);
               }
           }
       }
       
       update lstCon;
   }

   public void finish(Database.BatchableContext BC){
   }
    
   public void execute(SchedulableContext sc) {
      SyncUserAndContactEmail oSyncUserAndContactEmail = new SyncUserAndContactEmail();
        Database.executeBatch(new SyncUserAndContactEmail(), 2000);
   }
}
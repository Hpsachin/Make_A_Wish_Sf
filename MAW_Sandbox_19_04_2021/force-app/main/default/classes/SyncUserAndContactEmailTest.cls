@isTest
public class SyncUserAndContactEmailTest {
    
    @isTest
    static void testBatchUpdate() {
        
        Test.startTest();
        DataBase.executeBatch(new SyncUserAndContactEmail());
        String sch = '0 0 12 * * ?';
        system.schedule('One Time Pro', sch, new SyncUserAndContactEmail());
        Test.stopTest();
        
        
    }
}
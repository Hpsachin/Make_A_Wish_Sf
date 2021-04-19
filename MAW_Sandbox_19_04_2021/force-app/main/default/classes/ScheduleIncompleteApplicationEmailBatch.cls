global class ScheduleIncompleteApplicationEmailBatch implements Schedulable{
    global void execute(SchedulableContext ctx) {
        IncompleteApplicationEmailBatch IncompleteApplicationEmailBatchObj = new IncompleteApplicationEmailBatch();
        Database.executeBatch(IncompleteApplicationEmailBatchObj);
    }
    global static void scheduableJob(){
        String CRON_EXP = '0 0 9 1/1 * ? *';
        ScheduleIncompleteApplicationEmailBatch ScheduleIncompleteApplicationEmailBatchObj = new ScheduleIncompleteApplicationEmailBatch();
        String job = System.schedule('IncompleteApplicationEmailBatch Scheduler',CRON_EXP,ScheduleIncompleteApplicationEmailBatchObj);
        
    }
}
public class CallIncompleteApplicationEmailBatch {
public  static void callBatch(){

    IncompleteApplicationEmailBatch bcn = new IncompleteApplicationEmailBatch() ;
    ID batchprocessid = Database.executeBatch(bcn);

}
}
public class DashboardDetailRestWrapper {
    
    public List<Data> Data{get;set;}
    
    public class Data{
        public Date dateValue{get;set;}
        public String month{get;set;}
        public Integer pending{get;set;}
        public Integer approved{get;set;}
        public Integer applied{get;set;}
    }
    
}
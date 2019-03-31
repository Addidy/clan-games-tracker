public class Utilities {
    public static DateTime now {
        get {
            return (now==null) ? DateTime.now() : now;
        } set;
    }
    
    public static DateTime today {
        get {
            return (today==null) ? Date.today() : today;
        } set;
    }
    
    public static Date currentDate {
        get {
            return Date.newInstance(now.Year(), now.Month(), now.Day());
        }
    }
}
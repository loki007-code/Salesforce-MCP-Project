public class MapDemo {

    public static void sobjDemo(){
        List<Account> accList = new List<Account>();
        accList = [SELECT Id, Name FROM Account LIMIT 5];
        Map<Id, Account> accMap = new Map<Id, Account>();
        //accMap.putAll(accList);
        for(Account acc : accList){
            accMap.put(acc.id, acc);
        }
        System.debug('Map Contains...' + accMap);
        System.debug('Map Keys...' + accMap.keySet());
        System.debug('Map Values...' + accMap.values());
    }
    
    public static void demo(){
        Map<Integer, String> colors = new Map<Integer,String> ();
        Map<Integer, String> moreColors = new Map<Integer,String> ();
        Map<Integer, String> clonedMap = new Map<Integer,String> ();
        
        Set<Integer> intSet = new Set<Integer>();
        List<String> strList = new List<String>();
        
        colors.put(1,'Green');
        colors.put(2,'Blue');
        colors.put(3,'Red');
        colors.put(4,'Blue');
        System.debug('Map Contains...' + colors);
        colors.put(2,'Yellow');
        System.debug('Map Contains...' + colors);
        
        moreColors.put(10,'Black');
        moreColors.put(20,'White');
        colors.putAll(moreColors);
        System.debug('Map Contains...' + colors);
        
        colors.remove(1);
        System.debug('Map Contains...' + colors);
        System.debug('Map Size...' + colors.size());
        System.debug('Map Values...' + colors.values());
        
        clonedMap = colors.clone();
        System.debug('Cloned Map Contains...' + clonedMap);
        
        System.debug('Map Contains Key...' + clonedMap.containsKey(10));
        
        System.debug('Map Equals...' + clonedMap.equals(colors));
        
        System.debug('Map Equals...' + clonedMap.get(10));
        
        System.debug('Map Empty...' + clonedMap.isEmpty());
         
        System.debug('Map Keys...' + clonedMap.keySet());
        
        intSet = clonedMap.keySet();
        strList = clonedMap.values();
        System.debug('Set Contains...' + intSet);
        System.debug('List Contains...' + strList);
    }
}
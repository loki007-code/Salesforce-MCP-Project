public class ListDemo {
    
    public static void sObjectListDemo() {
        List <Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Acc1201', Active__c='Yes');
        accList.add(acc);
        insert accList; 
        
    }
    
    public static List<String> returnDemo(){
        List<String> colors = new List<String>();
        colors.add('Red');
        colors.add('Green');
        colors.add('Blue');
        
        return colors;
    }
    
    public static void listDemoMethod(){
        List<String> returnedValues = new List<String>();
        returnedValues = returnDemo();
        System.debug('Return Color List Contains = ' +  returnedValues );
        
        List<String> colors = new List<String>();
        colors.add('Red');
        colors.add('Green');
        colors.add('Blue');
        System.debug('Color List Contains = ' + colors);
        
        colors.add(1,'Black');
        System.debug('Color List Contains = ' + colors);
        
        List<String> colorsList = new List<String>();
        colorsList.add('White');
        colorsList.add('Purple');
        
        colors.addAll(colorsList);
        System.debug('Color Contains = ' + colors);
        System.debug('Color List Contains = ' + colorsList);
        colorsList.clear();
        System.debug('ColorsList Contains = ' + colorsList);
        
        List<String> clonedList = new List<String>();
        clonedList = colors.clone();
        System.debug('Cloned List Contains = ' + clonedList);
        
        System.debug('Color List Contains = ' + colors.contains('Pink'));
        System.debug('Color List Contains = ' + colors.equals(colorsList));
        System.debug('Color List Contains = ' + colors.get(3));
        System.debug('Color List Contains = ' + colors.indexOf('Green'));
        System.debug('Empty = ' + colors.isEmpty());
        colors.remove(3);
        System.debug('Colors Contains = ' + colors);
        System.debug('Size = ' + colors.size());
        colors.sort();
        System.debug('Sorted Values = ' + colors);
    }
}
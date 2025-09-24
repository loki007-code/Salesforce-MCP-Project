public class LoopDemo {
    
    public static void showList(){
        List<Account> accList = new List<Account>();
        Set<Id> accIds = new Set<Id>();
        Map<Id, Account> accMap = new Map<Id, Account>();
        
        accList = [SELECT Id, Name FROM Account LIMIT 5];
        
        //Iteration on account list to display data and create set of account ids and map
        System.debug('Display data through lists');
        if(!accList.isEmpty()){
            for (Account acc: accList){
                System.debug(acc.Id + '-' + acc.Name);
                accIds.add(acc.Id); //set is created
                accMap.put(acc.Id, acc); //map is having data
            }    
        }else{
            System.debug('Empty List');
        }
        
        //Display accids through set
        System.debug('Display data through set');
        if(!accIds.isEmpty()){
            for (Id accId : accIds){
                System.debug(accId);
            }
        }
        
        //Iterate map based on keys
        System.debug('Display data through map keys');
        if(!accMap.isEmpty()){
            for(Id accId : accMap.keySet()){
                System.debug(accId);
            }
        } 
        
        //Iterate map based on values
        System.debug('Display data through map values');
        if(!accMap.isEmpty()){
            for(Account acc : accMap.values()){
                System.debug(acc);
            }
        } 
    }
    
    public static void forDemo(){
        for(Integer i=1; i<=10; i++){
            System.debug(i);
        }
    }
    
    public static void sumOfNaturalNums(Integer n){
        Integer i, sum = 0;
        for(i=1; i <= n; i++){
            sum += i;
        }
        System.debug('Sum = '+sum);
    }
    
    public static void evenNum(Integer n){
        for(Integer i = 1; i <= n; i++){
            if(Math.mod(i,2) == 0){
                System.debug(i);
            }
        }
    }
    
    public static void tableWithWhile(Integer n){
        Integer i = 1;
        while(i <=10){
            System.debug(n + '*' + i + '=' +  n * i );
            i++;
        }
    }
    
    public static void table(Integer n){
        for(Integer i = 1; i <= 10; i++){
            System.debug(n + '*' + i + '=' +  n * i );
        }
    }
}
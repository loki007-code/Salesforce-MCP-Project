public class ConditionStmtDemo {
    
    public static void nullCheckDemo(){
        List<Account> accList = new List<Account>();
        accList = [SELECT Id FROM Account LIMIT 5];
        if(!accList.isEmpty()){ //accList.size>0
            System.debug('List Contains... ' + accList);
        }else{
            System.debug('Unable to fetch data');
        }
    }
    
    public static void logicalOperatorsDemo(){
        Integer num1 = 10, num2 = 30;
        
        if(num1 > 50 && num2 > 100){
            System.debug('true');
        }else{
            System.debug('false');
        }
    }
    
    public static void elseIfLadderDemo(Integer num){
        if(num > 0){
            System.debug('Num is positive');
        }else if(num ==0){
            System.debug('Num is zero');
         }else{
            System.debug('Num is negative');
        }
    }
    
    public static void nestedIfDemo(Integer num){
        if(num >= 0){
            if(num > 0){
                System.debug('Number is positive');
            }else{
                System.debug('Number is zero');
            }
        }else{
            System.debug('Number is negative');
        }
    }
    
    public static void max(Integer num1, Integer num2){
        //Integer num1 = 20, num2 = 40;
        // result = num1>num2? num1: num2;
        if(num1 > num2){
            System.debug('Num1 is max as compared to Num2');
            
        }else{
            System.debug('Num2 is max as compared to Num1');
        }
    }
    
    public static void checkEligibility(Integer age){
        if(age >= 18){
            System.debug('You are eligible to vote');
        }else{
            System.debug('You are eligible to vote');
        }
    }
    
    public static void checkEvenOdd(Integer num){
        if(Math.mod(num,2) == 0){
            System.debug('Given number is even');
        }else{
            System.debug('Given number is odd');
        }
    }
}
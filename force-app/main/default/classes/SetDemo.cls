public class SetDemo {

    public static void demoSObjectWithSet() {
        Set<Id> accIds = new Set<Id>();
        List<Account> accList = new List<Account>();
        
        accList = [SELECT Id, Name FROM Account LIMIT 5];
        
        for(Account acc : accList) {
            accIds.add(acc.Id);
        }
        
        System.debug('Set Contains = ' + accIds);
    }
    
    public static void demo(){
        Set<Integer> intSet = new Set<Integer>();
        List<Integer> intList = new List<Integer>();
        Set<Integer> clonedSet = new Set<Integer>();
        intSet.add(10);
        intSet.add(20);
        intSet.add(30);
        intSet.add(20);
        
        intList.add(50);
        intList.add(60);
        intList.add(30);
        
        intSet.addAll(intList);
        System.debug('Set Contains = '+ intSet);
        
        clonedSet = intSet.clone();
        System.debug('Cloned Set Contains = ' +clonedSet);
        
        System.debug('Element is Available = ' + intSet.contains(30));
        System.debug('Element is Available = ' + intSet.containsAll(intList));
        System.debug('Equals = ' + intSet.equals(clonedSet));
        System.debug('Empty = ' + intSet.isEmpty());
        
        intSet.remove(20);
        System.debug('Set Contains = '+ intSet);
        
        //intSet.removeAll(intList);
        //System.debug('Set Contains = '+ intSet);
        
        intSet.retainAll(intList);
        System.debug('Set Contains = '+ intSet);
        
        System.debug('Size = ' + intSet.size());

    }
}
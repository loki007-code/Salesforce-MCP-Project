public class CusObjHW {
    public static void sobjcetMap(){
        Map<Id,Student__c> stdMap = new Map<Id,Student__c>();
        List <Student__c> stdList = [SELECT Id,Name__c,Phone__c FROM Student__c LIMIT 5];
        stdMap.putAll(stdList);
        System.debug('Student Map '+stdMap);
    }
}
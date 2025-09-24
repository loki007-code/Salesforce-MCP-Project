public with sharing class OrderInventoryHandler {
    public static void updateInventory(List<Soft_Drink_Order__c> orders) {
        Set<Id> softDrinkIds = new Set<Id>();
        for (Soft_Drink_Order__c order : orders) {
            if (order.Soft_Drink__c != null && order.Quantity__c != null) {
                softDrinkIds.add(order.Soft_Drink__c);
            }
        }
        if (softDrinkIds.isEmpty()) return;

        Map<Id, Soft_Drink__c> softDrinkMap = new Map<Id, Soft_Drink__c>([
            SELECT Id, Total_Quantity__c, Quantity_Used__c, Quantity_Left__c
            FROM Soft_Drink__c WHERE Id IN :softDrinkIds
        ]);

        List<Soft_Drink__c> updates = new List<Soft_Drink__c>();
        for (Soft_Drink_Order__c order : orders) {
            if (order.Soft_Drink__c != null && order.Quantity__c != null) {
                Soft_Drink__c sd = softDrinkMap.get(order.Soft_Drink__c);
                Decimal newUsed = order.Quantity__c;
                Decimal newLeft = (sd.Total_Quantity__c == null ? 0 : sd.Total_Quantity__c) - newUsed;
                sd.Quantity_Used__c = newUsed;
                sd.Quantity_Left__c = newLeft;
                updates.add(sd);
            }
        }
        if (!updates.isEmpty()) {
            update updates;
        }
    }
}

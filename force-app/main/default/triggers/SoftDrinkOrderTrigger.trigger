trigger SoftDrinkOrderTrigger on Soft_Drink_Order__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        OrderInventoryHandler.updateInventory(Trigger.new);
    }
}

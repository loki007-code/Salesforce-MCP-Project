@isTest
public class OrderInventoryHandlerTest {
    @isTest
    static void testInventoryUpdate() {
        // Create a Soft_Drink__c record
        Soft_Drink__c drink = new Soft_Drink__c(
            Name = 'Cola',
            Total_Quantity__c = 10,
            Quantity_Used__c = 0,
            Quantity_Left__c = 10
        );
        insert drink;

        // Create a Soft_Drink_Order__c record for 5 units
        Soft_Drink_Order__c order = new Soft_Drink_Order__c(
            Soft_Drink__c = drink.Id,
            Quantity__c = 5
        );
        insert order;

        // Query updated Soft_Drink__c
        Soft_Drink__c updatedDrink = [SELECT Quantity_Used__c, Quantity_Left__c FROM Soft_Drink__c WHERE Id = :drink.Id];
        System.assertEquals(5, updatedDrink.Quantity_Used__c, 'Quantity Used should be 5');
        System.assertEquals(5, updatedDrink.Quantity_Left__c, 'Quantity Left should be 5');
    }
}

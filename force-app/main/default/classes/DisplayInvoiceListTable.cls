public class DisplayInvoiceListTable {
    @AuraEnabled(Cacheable=true)
    public static List<Invoice__c> getInvoiceList(){
        List<Invoice__c> invList = [SELECT Id, Name, Invoice_Date__c, Pending_Amount__c,
                                    Buyer_Name__c, Invoice_Status__c,Buyer_Name__r.Name,Buyer_Name__r.Id , Seller_Name__r.Name,Seller_Name__r.Id
                                    FROM Invoice__c WHERE Invoice_Status__c IN ('New','Payment Pending')];
        return invList;
    }
    
    @AuraEnabled(cacheable=false)
    public static List<Invoice_Line__c> getInvoiceLineById(Id invoiceId) {
        return [
            SELECT Id, Product_Name__c, Product_Name__r.Name, Quantity__c, Price__c,
            Product_Total__c, Taxes__c, Grand_Total__c
            FROM Invoice_Line__c
            WHERE InvoiceM__c = :invoiceId
        ];
    }
    
    
    @AuraEnabled(Cacheable=true)
    public static List<Product2> getAllProducts(){
        return [SELECT Id, Name FROM Product2];
    }
    
    @AuraEnabled(Cacheable=false)
    public static void saveInvoiceLine(List<Invoice_Line__c> invoiceLineList){
        try{
            insert invoiceLineList;
        } catch(Exception e){
            String errorMessage = e.getMessage();
            System.debug('errorMessage '+errorMessage);
        }
    }
}
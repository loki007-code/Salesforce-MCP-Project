@isTest
private class XeroInvoiceServiceTest {
    
    // Mock class to simulate Xero HTTP response
    private class MockXeroResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{ "Invoices": [{ "InvoiceID": "abc-123-xero", "Status": "AUTHORISED" }] }');
            return res;
        }
    }
    
    @isTest
    static void testSendInvoiceToXero_Success() {
        // Insert dummy Custom Metadata using Test.loadData or sObject injection
        // For demo, assuming Tenant_ID__c is already available via metadata
        
        // Create dummy Invoice
        Invoice__c invoice = new Invoice__c(
            X_Status__c = 'Synced',
            Invoice_Date__c = Date.today(),
            Due_Date__c = Date.today().addDays(5)
        );
        insert invoice;
        
        // Create dummy Invoice
        Invoice_Line__c line = new Invoice_Line__c(
            InvoiceM__c = invoice.Id,
            X_Description__c = 'Test Item',
            Quantity__c = 2,
            X_Unit_Amount__c = 100.00
        );
        insert line;
        
        // Register mock
        Test.setMock(HttpCalloutMock.class, new MockXeroResponse());
        
        Test.startTest();
        XeroInvoiceService.sendInvoiceToXero(invoice.Id);
        Test.stopTest();
        
        Invoice__c updatedInv = [SELECT Xero_Invoice_ID__c, X_Status__c, Xero_Status__c, Xero_Response__c FROM Invoice__c WHERE Id = :invoice.Id];
        
        System.assertEquals('abc-123-xero', updatedInv.Xero_Invoice_ID__c);
        System.assertEquals('Synced', updatedInv.X_Status__c);
        System.assertEquals('AUTHORISED', updatedInv.Xero_Status__c);
        System.assertEquals('Invoice sent successfully.', updatedInv.Xero_Response__c);
    }
    
    @isTest
    static void testSendInvoiceToXero_NoLineItems() {
        Invoice__c invoice = new Invoice__c(
            //Name = 'Test Invoice No Lines',
            X_Status__c = 'Synced',
            Invoice_Date__c = Date.today(),
            Due_Date__c = Date.today().addDays(5)
        );
        insert invoice;
        
        Test.startTest();
        XeroInvoiceService.sendInvoiceToXero(invoice.Id);
        Test.stopTest();
        
        Invoice__c updatedInv = [SELECT Xero_Status__c, Xero_Response__c FROM Invoice__c WHERE Id = :invoice.Id];
        System.assertEquals('Error', updatedInv.Xero_Status__c);
        System.assert(updatedInv.Xero_Response__c.contains('No Invoice Line Items'));
    }
    
    @isTest
    static void testSendInvoiceToXero_InvalidStatus() {
        Invoice__c invoice = new Invoice__c(
            //Name = 'Wrong Status',
            X_Status__c = 'Draft',
            Invoice_Date__c = Date.today(),
            Due_Date__c = Date.today().addDays(5)
        );
        insert invoice;
        
        Test.startTest();
        XeroInvoiceService.sendInvoiceToXero(invoice.Id);
        Test.stopTest();
        
        Invoice__c check = [SELECT Xero_Status__c, Xero_Response__c FROM Invoice__c WHERE Id = :invoice.Id];
        System.assertEquals(null, check.Xero_Status__c);
        System.assertEquals(null, check.Xero_Response__c);
    }
}
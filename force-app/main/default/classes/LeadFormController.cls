public with sharing class LeadFormController {
    @AuraEnabled
    public static String createLead(String firstName, String lastName, String company, String email, String phone) {
        try {
            Lead newLead = new Lead();
            newLead.FirstName = firstName;
            newLead.LastName = lastName;
            newLead.Company = company;
            newLead.Email = email;
            newLead.Phone = phone;
            insert newLead;
            return 'Success';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}

/*
**********************************************************************************************************************
Apex Test Class Name : SelfCertificationController
Created Date         : 11-07-2025
@author              : Logesh Aravindh
Modification Log:
Ver    Date         Author            Modification
1.0    14-07-2025   Logesh Aravindh   Modifying SelfCertificationController
**********************************************************************************************************************
Description          :
    This Apex controller is exposed to Lightning components (LWC/Aura) to handle
    operations related to Self Certification. It acts as a thin layer that delegates
    actual processing to the SelfCertificationHandler class.

    Exposed methods include:
      - Fetching user details for pre-filling forms.
      - Fetching pricing data from custom metadata based on country.
      - Creating new self certification records.
      - Retrieving certifications for the logged-in user.
      - Uploading signed PDF files and linking them to certifications.
      - Retrieving all certifications (for admin views).

    Most methods are marked cacheable=true for optimized Lightning data loading.
*/
public class SelfCertificationController {
    
    /**
     * @description
     *   Retrieves details of a single User by Id.
     *   Useful to populate form data for the logged-in user in LWC/Aura components.
     *
     * @param userId  The Id of the user whose details are to be fetched.
     * @return        User record matching the given Id.
     */
    @AuraEnabled(cacheable=true)
    public static User getUserDetails(Id userId) {
        return SelfCertificationHandler.getUserDetails(userId);
    }
    
    /**
     * @description
     *   Retrieves pricing data from Country_Pricing__mdt custom metadata
     *   for the specified country. Used to display fees or pricing on the certification form.
     *
     * @param country  The country to filter the pricing metadata.
     * @return         List of Country_Pricing__mdt records for that country.
     */
    @AuraEnabled(cacheable=true)
    public static List<Country_Pricing__mdt> getPricingData(String country) {
        return SelfCertificationHandler.getPricingData(country);
    }
    
     /**
     * @description
     *   Creates a new Self Certification record in Salesforce.
     *   Populates fields like country, certification period, comments, user, and email,
     *   then inserts the record and returns its Id.
     *
     * @param country  The country for which the certification is submitted.
     * @param period   Certification period in years as a string.
     * @param comments Any comments entered by the user.
     * @param userId   The Id of the submitting user.
     * @param email    The email associated with the certification.
     *
     * @return         The Id of the newly created Self_Certification__c record.
     */
    @AuraEnabled
    public static Id createSelfCertification(String country, String period, String comments, Id userId, String email) {
        return SelfCertificationHandler.createSelfCertification(country, period, comments, userId, email);
    }
    
    /**
     * @description
     *   Retrieves all Self Certification records that were submitted by the specified user.
     *   Typically used to show a "My Certifications" list on the user's dashboard.
     *
     * @param userId  The Id of the user whose certifications to retrieve.
     * @return        List of Self_Certification__c records submitted by the user.
     */
    @AuraEnabled(cacheable=true)
    public static List<Self_Certification__c> getMyCertifications(Id userId) {
        return SelfCertificationHandler.getCertifications(userId);
    }
    
    /**
     * @description
     *   Uploads a signed PDF file as a ContentVersion and links it to a Self Certification record
     *   using ContentDocumentLink. This enables attaching signed documents directly to certifications.
     *
     * @param selfCertId  The Id of the Self Certification record to link the file to.
     * @param base64Data  The base64-encoded binary content of the PDF file.
     * @param fileName    The file name to store as ContentVersion Title.
     */
    @AuraEnabled
    public static void uploadSignedPDF(String selfCertId, String base64Data, String fileName) {
    	SelfCertificationHandler.uploadSignedPDF(selfCertId, base64Data, fileName);
    }
    
    /**
     * @description
     *   Retrieves all Self Certification records in the system.
     *   Typically used for admin dashboards or audit screens.
     *
     * @return List of all Self_Certification__c records.
     */
    @AuraEnabled(cacheable=true)
    public static List<Self_Certification__c> getAllCertifications() {
        return SelfCertificationHandler.getCertifications();
    }
}




/**

* @description: Getting current user login details
* @param Id - to query the details of a user
* @return current user details.
* 
@AuraEnabled(cacheable=true)
public Static User getUserDetails(Id userId){
return [SELECT Id, Name, Country, email FROM User WHERE Id = :userId LIMIT 1];
}

/**
* @description: Getting current user's price, currency format from custom metadata
* @param Country 
* @return price, currency.

@AuraEnabled(cacheable=true)
public Static List<Country_Pricing__mdt> getPricingData(String country){
return[ SELECT Country__c, Price__c, Currency__C FROM Country_Pricing__mdt WHERE Country__c = :country ];
}

/**
* @description: Getting current user login details
* @param Id - to query the details of a user
* @return current user details.

@AuraEnabled
public Static Id createSelfCertification(String country, String period, String comments, Id userId, String email){
Self_Certification__c sc = new Self_Certification__c();
try{

User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];

sc.Certified_By__c = adminUser.Id;
sc.Country__c = country;
sc.Certification_Period__c = Integer.valueOf(period);
sc.Comments__c = comments;
sc.E_signature__c = true;
sc.Submitted_By__c = userId;
sc.Status__c = 'Submitted';
sc.Email__c = email;
sc.Certification_Date__c = Date.today();
sc.Next_Due_Date__c =  Date.today().addYears(1);
insert sc;

}catch (Exception e){
System.debug('Error inserting self certification: ' + e.getMessage());
throw new AuraHandledException('Error inserting Self Certification: ' + e.getMessage());
}
return sc.Id != null ? sc.Id : null;
}
**/
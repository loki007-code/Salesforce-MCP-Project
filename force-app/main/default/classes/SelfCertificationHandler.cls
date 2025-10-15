/*
**********************************************************************************************************************
Apex Test Class Name : SelfCertificationHandler
Created Date         : 11-07-2025
@author              : Logesh Aravindh
Modification Log:
Ver    Date         Author            Modification
1.0    14-07-2025   Logesh Aravindh   Modifying SelfCertificationHandler
**********************************************************************************************************************
Description          :
    This Apex class provides server-side logic for handling Self Certification functionality in Salesforce.
    It includes methods to:
      - Retrieve user details
      - Fetch pricing data from custom metadata
      - Create self certification records
      - Retrieve certification records (all or by user)
      - Upload signed PDF files as ContentVersion and link to certification
*/
public class SelfCertificationHandler {

	 /**
     * @description
     *   Retrieves details of a single User by Id.
     *   Typically used to prefill user-related fields on the UI.
     * @param userId  The Id of the user to fetch.
     * @return        The User record if found, otherwise null.
     */
    public static User getUserDetails(Id userId){
        if(userId == null){
            //throw new AuraHandledException('User Id is required');
            return null;
        }
        
        List <User> users = [SELECT Id, Name, Country, Email FROM User WHERE Id = :userId LIMIT 1];
        //if (users.isEmpty()){
          //  throw new AuraHandledException('User not found');
        //}
        
        return users[0];
    }
    
 	/**
     * @description
     *   Retrieves pricing data from the Country_Pricing__mdt custom metadata type
     *   based on the provided country. Useful for showing fees or pricing based on country.
     *
     * @param country  The country name to filter the pricing metadata.
     * @return         List of Country_Pricing__mdt records matching the country.
     */
    public static List<Country_Pricing__mdt> getPricingData(String country){
        
        if(country == null){
            //throw new AuraHandledException('country is required');
            return null;
        }
        
        List <Country_Pricing__mdt> pricingData =  [ SELECT Country__c, Price__c, Currency__C FROM Country_Pricing__mdt WHERE Country__c = :country ];
        //if(pricingData == null){
          //  throw new AuraHandledException('Unable to get pricing data');
        //}
        
        return pricingData;    
    }
    
    /**
     * @description
     *   Creates a Self Certification record in Salesforce.
     *   Validates required fields, associates the certification with the submitting user
     *   or an active system administrator, sets default values for certification fields,
     *   and inserts the record.
     *
     * @param country  The country for which the certification is being submitted. (Required)
     * @param period   The certification period in years as a string (converted to Integer). (Required)
     * @param comments Any comments provided by the user. (Optional)
     * @param userId   The Id of the user submitting the certification. (Required)
     * @param email    The email associated with the certification. (Required)
     *
     * @return         The Id of the newly created Self_Certification__c record.
     */
    public static Id createSelfCertification(String country, String period, String comments, Id userId, String email){
        
        if (String.isBlank(country) || String.isBlank(period) || userId == null || String.isBlank(email) ) {
            //throw new AuraHandledException('country is required.');
            return null;
        }
        
        List<User> users = [SELECT Id, Profile.Name FROM User WHERE Id = :userId OR (Profile.Name = 'System Administrator' AND IsActive = true)LIMIT 1];
        
        //if (users.isEmpty()) {
        //    throw new AuraHandledException('No matching user or admin found.');
       //	}
        
        /**
        Id adminId;
        for (User u : users) {
            if (u.Profile.Name == 'System Administrator') {
                adminId = u.Id;
            }
        }
        
        if (adminId == null) {
            throw new AuraHandledException('No active System Administrator found.');
        }
		**/
        
        Self_Certification__c sc = new Self_Certification__c(
            Certified_By__c = users[0].Id,
            Country__c = country,
            Certification_Period__c = Integer.valueOf(period),
            Comments__c = comments,
            E_signature__c = true,
            Submitted_By__c = userId,
            Status__c = 'Submitted',
            Email__c = email,
            Certification_Date__c = Date.today(),
            Next_Due_Date__c = Date.today().addYears(1)
        );
        
        try {
            insert sc;
        } catch (DmlException e) {
            throw new AuraHandledException('Failed to insert Self Certification: ' + e.getDmlMessage(0));
        }
        
        return sc.Id;
    }
    
    /**
     * @description
     *   Retrieves all Self Certification records in the system.
     *   Useful for admin views or listing all certifications for compliance.
     *
     * @return  A list of Self_Certification__c records.
     */
    public static List<Self_Certification__c> getCertifications() {
        List <Self_Certification__c> certifications = [SELECT Id, Country__c, Certification_Date__c, 
                                                      Certified_By__r.Name, Certified_By__r.Id, 
                                                      Status__c, Next_Due_Date__c, Email__c
                                                      FROM Self_Certification__c
                                                     ];
        //if(certifications.isEmpty()){
          //  throw new AuraHandledException('Data Not Found.');
        //}
        return certifications;
    }
    
    /**
     * @description
     *   Retrieves Self Certification records submitted by a specific user.
     *   Typically used for user-specific dashboards or history views.
     *
     * @param userId  The Id of the user whose certifications are to be fetched.
     * @return        A list of Self_Certification__c records submitted by the user.
     */
    public static List<Self_Certification__c> getCertifications(Id userId) {
        if (userId == null) {
            //throw new AuraHandledException('userId is required.');
            return null;
        }
        
        List <Self_Certification__c> certifications = [SELECT Id, Country__c, Certification_Date__c, 
                                                      Certified_By__r.Name, Certified_By__r.Id, 
                                                      Status__c, Next_Due_Date__c, Email__c
                                                      FROM Self_Certification__c WHERE Submitted_By__c = :userId
                                                     ];
        //if(certifications.isEmpty()){
          //  throw new AuraHandledException('Data Not Found.');
        //}
        return certifications;
    }
    
    /**
     * @description
     *   Uploads a signed PDF file as a ContentVersion in Salesforce and links it to the given
     *   Self Certification record using ContentDocumentLink. This allows storing digital signatures
     *   or supporting documents.
     *
     * @param selfCertId  The Id of the Self_Certification__c record to link the file to.
     * @param base64Data  The base64 encoded content of the PDF file.
     * @param fileName    The name of the file to be stored.
     *
     * @throws AuraHandledException if upload or linking fails.
     */
    public static void uploadSignedPDF(String selfCertId, String base64Data, String fileName) {
        if (String.isEmpty(selfCertId) || String.isEmpty(base64Data) || String.isEmpty(fileName)) {
            //throw new AuraHandledException('Missing data for file upload.');
            return;
        }
        
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        
        try{
            insert cv;
        }catch(Exception e){
            throw new AuraHandledException('Unable to create Content Version');
        }
 
        ContentDocument cd = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id LIMIT 1];
        if(cd == null){
            throw new AuraHandledException('ContentDocument not found for uploaded file.');
        }
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = selfCertId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        try{
            insert cdl;
        }catch(Exception e){
            throw new AuraHandledException('Unexpected error during file upload: ' + e.getMessage());
        }
    }
    
}
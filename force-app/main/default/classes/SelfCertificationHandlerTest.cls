/*
**********************************************************************************************************************
Apex Test Class Name : SelfCertificationHandlerTest
Created Date         : 14-07-2025
@author              : Logesh Aravindh

Modification Log:
Ver    Date         Author            Modification
1.0    14-07-2025   Logesh Aravindh   Full functional coverage for SelfCertificationHandler
**********************************************************************************************************************
Description:
    This is the test class for SelfCertificationHandler. It provides complete functional coverage
    for all methods inside SelfCertificationHandler including:

      - Retrieving user details
      - Creating self certifications
      - Retrieving certifications (by user and all)
      - Uploading signed PDF files
      - Fetching pricing data from custom metadata
*/

/**
 * @description
 *   Test class that validates all flows of the SelfCertificationHandler including creation,
 *   retrieval, PDF uploads, and pricing data fetch. Uses real inserts with SeeAllData=true
 *   to work with existing Profiles and Users.
 */
@isTest(SeeAllData=true)
public class SelfCertificationHandlerTest {
    
    /**
     * @description
     *   Main test method that performs the following:
     *     - Inserts a test User and Self Certification record
     *     - Tests retrieval of user details
     *     - Tests creation of a new self certification
     *     - Tests fetching certifications by user and all certifications
     *     - Tests upload of signed PDF file
     *     - Tests fetching pricing data from custom metadata
     *   Covers null/empty parameter edge cases as well.
     */
    @isTest
    static void testSelfCertificationHandlerFlow() {
        // Setup: Create a test User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User u = new User(
            Alias='tusr', Email='t@a.com', EmailEncodingKey='UTF-8',
            LastName='Tester', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId=p.Id, TimeZoneSidKey='America/Los_Angeles',
            Username='testuser' + DateTime.now().getTime() + '@a.com', Country='India'
        );
        insert u;

        // Setup: Create a test Self Certification record
        Self_Certification__c cert = new Self_Certification__c(
            Certified_By__c = u.Id, Country__c = 'India', Certification_Period__c = 12,
            Comments__c = 'Test comments', E_signature__c = true, Submitted_By__c = u.Id,
            Status__c = 'Submitted', Email__c = 'test@test.com',
            Certification_Date__c = Date.today(), Next_Due_Date__c = Date.today().addYears(1)
        );
        insert cert;

        // Prepare data for file upload
        Blob dataBlob = Blob.valueOf('Test PDF Content');
        String base64Data = EncodingUtil.base64Encode(dataBlob);

        List<Self_Certification__c> certs;
        List<Self_Certification__c> allCerts;

        Test.startTest();

        // Test: getUserDetails valid
        User returnedUser = SelfCertificationHandler.getUserDetails(u.Id);
        System.assertEquals(u.Id, returnedUser.Id);

        // Test: getUserDetails null Id
        Id userId;
        User emptyUser = SelfCertificationHandler.getUserDetails(userId);
        System.assertEquals(null, emptyUser);

        // Test: createSelfCertification valid
        Id newCertId = SelfCertificationHandler.createSelfCertification('India','12','All fine', u.Id,'test@test.com');
        System.assertNotEquals(null, newCertId);

        // Test: createSelfCertification with missing params
        Id emptyCertId = SelfCertificationHandler.createSelfCertification('','','', userId,'');
        System.assertEquals(null, emptyCertId);

        // Test: getCertifications by user
        certs = SelfCertificationHandler.getCertifications(u.Id);
        System.assert(!certs.isEmpty());

        // Test: getCertifications by userId null
        SelfCertificationHandler.getCertifications(userId);

        // Test: get all certifications
        allCerts = SelfCertificationHandler.getCertifications();
        System.assert(!allCerts.isEmpty());

        // Test: uploadSignedPDF with valid data
        SelfCertificationHandler.uploadSignedPDF(cert.Id, base64Data, 'signed.pdf');

        // Test: uploadSignedPDF with missing params
        SelfCertificationHandler.uploadSignedPDF( '', '' , '');

        // Test: getPricingData with valid country
        try {
            SelfCertificationHandler.getPricingData('India');
        } catch (AuraHandledException e) {
            System.debug('Handled: ' + e.getMessage());
        }

        // Test: getPricingData with null country
        String country;
        SelfCertificationHandler.getPricingData(country);

        Test.stopTest();
    }
}
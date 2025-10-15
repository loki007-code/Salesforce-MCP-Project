public with sharing class SelfCertificationFileService {
    @AuraEnabled
    public static void uploadSignedPDF(String selfCertId, String base64Data, String fileName) {
        if (String.isEmpty(selfCertId) || String.isEmpty(base64Data) || String.isEmpty(fileName)) {
            throw new AuraHandledException('Missing data for file upload.');
        }
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        insert cv;
        ContentDocument cd = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = selfCertId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }
}
@RestResource(urlMapping='/cases/*')
global with sharing class CaseRestService {
  // Wrapper returned as JSON for all responses
  global class RestResponseWrapper {
    public Boolean success;
    public String message;
    public Object data;
  }

  @HttpGet
  global static void getCases() {
    RestResponseWrapper resp = new RestResponseWrapper();
    try {
      // Return open cases (not closed). Limit to 200 for safety.
      List<Case> cases = [
        SELECT Id, Subject, Status
        FROM Case
        WHERE IsClosed = FALSE
        ORDER BY CreatedDate DESC
        LIMIT 200
      ];

      List<Object> out = new List<Object>();
      for (Case c : cases) {
        Map<String, Object> m = new Map<String, Object>{
          'Id' => c.Id,
          'Subject' => c.Subject,
          'Status' => c.Status
        };
        out.add(m);
      }

      resp.success = true;
      resp.message = 'Fetched open cases';
      resp.data = out;
      RestContext.response.statusCode = 200;
    } catch (Exception e) {
      resp.success = false;
      resp.message = 'Error fetching cases: ' + e.getMessage();
      resp.data = null;
      RestContext.response.statusCode = 500;
    }
    // serialize wrapper to response body
    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
  }

  @HttpPost
  global static void createCase() {
    RestResponseWrapper resp = new RestResponseWrapper();
    try {
      String body = '';
      if (
        RestContext.request != null &&
        RestContext.request.requestBody != null
      ) {
        body = RestContext.request.requestBody.toString();
      }

      Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(
        String.isBlank(body) ? '{}' : body
      );

      String subject = null;
      String description = null;

      if (payload.containsKey('Subject') && payload.get('Subject') != null) {
        subject = String.valueOf(payload.get('Subject'));
      }
      if (
        payload.containsKey('Description') && payload.get('Description') != null
      ) {
        description = String.valueOf(payload.get('Description'));
      }

      if (String.isBlank(subject)) {
        resp.success = false;
        resp.message = 'Subject is required.';
        resp.data = null;
        RestContext.response.statusCode = 400;
        // serialize wrapper to response body and return from void method
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
        return;
      }

      Case c = new Case(
        Subject = subject,
        Description = description,
        Status = 'New'
      );
      insert c;

      Map<String, Object> out = new Map<String, Object>{
        'Id' => c.Id,
        'Subject' => c.Subject,
        'Status' => c.Status
      };

      resp.success = true;
      resp.message = 'Case created';
      resp.data = out;
      RestContext.response.statusCode = 201;
    } catch (DmlException de) {
      resp.success = false;
      resp.message = 'DML error creating case: ' + de.getMessage();
      resp.data = null;
      RestContext.response.statusCode = 500;
    } catch (Exception e) {
      resp.success = false;
      resp.message = 'Error creating case: ' + e.getMessage();
      resp.data = null;
      RestContext.response.statusCode = 500;
    }
    // serialize wrapper to response body
    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
  }
}

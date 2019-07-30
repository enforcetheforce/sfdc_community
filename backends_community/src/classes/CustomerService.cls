@RestResource(urlMapping='/backends/*/customer/*')
global with sharing class CustomerService  {

    @HttpGet
    global static void doGet() {
        String version = RestContext.request.requestURI.substringBetween( '/backends/', '/customer' );

        if( String.isBlank( version ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'A versão da API deve ser informada.' );
        } else {
            List<Service_Version__c> versions = [Select Id, Handler__c from Service_Version__c where Service__r.Name = 'CustomerService' and Service__r.Is_Active__c = true and Name = :version and Released__c = true LIMIT 1];
            if( versions.isEmpty() ) {
                ServiceError.throwServiceError( 404, 'Not Found', 'A versão da API não está disponível.' );
            } else {
                ServiceInterface instance =  (ServiceInterface) Type.forName(versions[0].Handler__c).newInstance();
                instance.doGet();
            }
        }        
    }

}
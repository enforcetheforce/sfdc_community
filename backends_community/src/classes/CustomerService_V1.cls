public class CustomerService_V1 implements ServiceInterface {

    public void doGet() {
        String customerId = RestContext.request.requestURI.substringAfter( '/customer/' );

        if( String.isBlank( customerId ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'Você deve informar o ID do cliente' );
        } else {
            List<Account> accounts = [Select Id, Customer_ID__c, Name, Email__c, Country__c from Account where Customer_ID__c = :customerId];
            if( accounts.size() == 0 ) {
                ServiceError.throwServiceError( 404, 'Not Found', 'Cliente não encontrado' );
            } else {
                RestContext.response.statusCode = 200;
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( getResponse( accounts[0] ) ) );
            }
        }
    }

    public void doPost() {}

    public void doPatch() {}

    public void doPut() {}

    public void doDelete() {}

    private CustomerResponse getResponse( Account account ) {
        CustomerResponse response = new CustomerResponse();
        response.name = account.Name;
        response.customer_id = account.Customer_ID__c;
        response.country = account.Country__c;
        return response;
    }

    public class CustomerResponse {
        public String customer_id;
        public String name;
        public String country;
    }
}
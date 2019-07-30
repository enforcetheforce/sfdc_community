public class ProductService_V1 implements ServiceInterface {

    public void doGet() {
        String countryCode = RestContext.request.params.get('country');

        if( String.isBlank( countryCode ) ) {
            ServiceError.throwServiceError( 400, 'Bad Request', 'Você deve informar o código do país' );
        } else {
            List<Country_By_Product__c> countriesByProduct = [Select Id, Product__r.Name, Product__r.Description, Product__r.IsActive, Product__r.External_ID__c, Product__r.Family from Country_By_Product__c where Country__r.Code__c = :countryCode];
            if( countriesByProduct.size() == 0 ) {
                ServiceError.throwServiceError( 404, 'Not Found', 'Nenhum produto encontrado para o país ' + countryCode );
            } else {
                RestContext.response.statusCode = 200;
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( getResponse( countriesByProduct ) ) );
            }
        }
    }

    public void doPost() {}

    public void doPatch() {}

    public void doPut() {}

    public void doDelete() {}

    private List<ProductResponse> getResponse( List<Country_By_Product__c> countriesByProduct ) {
        List<ProductResponse> response = new List<ProductResponse>();

        for( Country_By_Product__c countryByProduct : countriesByProduct ) {
            ProductResponse product = new ProductResponse();
            product.name = countryByProduct.Product__r.Name;
            product.description = countryByProduct.Product__r.Description;
            product.external_id = countryByProduct.Product__r.External_ID__c;
            product.isActive = countryByProduct.Product__r.IsActive;
            product.family = countryByProduct.Product__r.Family;
            response.add(product);
        }

        return response;    
    }

    public class ProductResponse {
        public String name;
        public String description;
        public Boolean isActive;
        public String family;
        public String external_id;
    }
}
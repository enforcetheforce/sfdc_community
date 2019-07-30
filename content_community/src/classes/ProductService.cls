@RestResource(urlMapping='/content/products/*')
global class ProductService  {

    @HttpGet
    global static void doGet() {
        String productId = RestContext.request.requestURI.substringAfter( '/products/' );

        if( String.isBlank( productId ) ) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('ID do produto não informado');
        } else {
            List<Product2> products = [Select Id, Name, Description_Content__c, External_ID__c, Icon_URL__c, Image_URL__c from Product2 where External_ID__c = :productId];
            if( products.size() == 0 ) {
                RestContext.response.statusCode = 404;
                RestContext.response.responseBody = Blob.valueOf('Produto não encontrado');
            } else {
                Product2 product = products[0];
                List<PricebookEntry> entries = [Select Id, UnitPrice from PricebookEntry where Product2Id = :product.Id LIMIT 1];
                PricebookEntry entry;
                if( entries.size() > 0  ) {
                    entry = entries[0];
                }

                RestContext.response.statusCode = 200;
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( getResponse( product, entry ) ) );

            }
        }
    }

    private static ProductResponse getResponse( Product2 product, PricebookEntry entry ) {
        ProductResponse response = new ProductResponse();
        response.name = product.Name;
        response.description = product.Description_Content__c;
        response.external_id = product.External_ID__c;
        response.link = new Link();
        response.link.icon = product.Icon_URL__c;
        response.link.image = product.Image_URL__c;
        response.amount = new Amount();
        if( entry != null ) {
            response.amount.currencyISOCode = 'BRL';
            response.amount.value = entry.UnitPrice;
        }
        return response;
    }

    public class ProductResponse {
        public String name;
        public String description;
        public String external_id;
        public Link link;
        public Amount amount;
    }

    public class Link {
        public String icon;
        public String image;
    }

    public class Amount {
        public String currencyISOCode;
        public Double value;
    }
}
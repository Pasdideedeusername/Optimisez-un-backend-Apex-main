@isTest
public  class TestDataFactory {
    public static Product2 createProduct(String productName, Boolean insertData){
        Product2 product = new Product2(Name = productName);
        if (insertData){
            insert product;    
        }
        return product;
    }
    public static OrderItem createOrderItem (Id productId, Id orderId, Id pricebookEntryId, Boolean insertData){
        OrderItem orderItem = new OrderItem (UnitPrice = 50, Product2Id = productId, OrderId = orderId, Quantity = 1, PricebookEntryId = pricebookEntryId);
        if (insertData){
            insert orderItem;    
        }
        return orderItem;
    }

    public static Pricebook2 createPriceBook (String priceBookName, Boolean isInsert){
        Pricebook2 pricebook = new Pricebook2 (Name=priceBookName, IsActive=true);
        if (isInsert){
            insert pricebook;
        }
        
        return pricebook;
    }
/*
    public static PricebookEntry createPriceBookEntry (Id productId, Id pricebookId, Double unitPrice, Boolean insertData){
        PricebookEntry pricebookEntry = new PricebookEntry(Product2Id = productId, Pricebook2Id = pricebookId, IsActive=true, UnitPrice=unitPrice);
        if (insertData){
            insert pricebookEntry;    
        }
        return pricebookEntry;
    }
*/
    public static PricebookEntry createStandardPricebookEntry(Id productId, Double unitPrice, Boolean insertData) {
        String standardPricebookId = Test.getStandardPricebookId(); 
        PricebookEntry standardPriceEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = productId,
            UnitPrice = unitPrice,
            IsActive = true,
            UseStandardPrice = false 
        );

        if (insertData) {
            insert standardPriceEntry;
        }
        return standardPriceEntry;
    }


    public static Order createOrder (Id accountId, Boolean insertData){ 
        Order order = new Order(
                        AccountId = accountId, 
                        EffectiveDate= date.today(), 
                        Status='Draft', 
                        ShipmentCost__c= 5, 
                        Pricebook2Id=Test.getStandardPricebookId()); 

        if (insertData){
            insert order;
        }
        return order;
    }

    public static Account createAccount (String accountName, Boolean insertData){
        Account account = new Account (Name = accountName);
        if (insertData){
            insert account;
        }
        return account;
    }
    

    //Create an account with an order (thus using all the methods above)
    public static Account createAccountWithAnOrder (String accountName){

        Product2 testProduct = createProduct('testProduct', true);
        PricebookEntry pricebookEntry= createStandardPricebookEntry(testProduct.Id, 50, true);
        Account account = createAccount (accountName, true);
        Order order = createOrder(account.Id, true);
        createOrderItem(testProduct.Id, order.Id, pricebookEntry.Id, true);
        order.Status = 'Activated';
        update order;
        return account;
     }

     // Creation a user with a OrderTriggerBypass (true)
     public static user createUser (Boolean orderTriggerBypass){

        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User user = new User(Alias = 'testA', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', UserName=uniqueUserName, LastName= 'TestUser', Email='test@test.com',OrderTriggerBypass__c= orderTriggerBypass, ProfileId=UserInfo.getProfileId());
        insert user;
        return user;
     }

 }
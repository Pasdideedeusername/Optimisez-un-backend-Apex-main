@isTest
private class OrderServiceTest {
    
    @TestSetup
    static void makeData(){
        // Crée un nouvel utilisateur qui bypasse les déclencheurs sur les commandes
        User user = TestDataFactory.createUser(true);
        System.runAs(user){

        // créé un set de données pour le test (une commande et un compte associé, avec tous les objets annexes nécéssaires à leur création)
        TestDataFactory.createAccountWithAnOrder('test Account');
        }
    }
    
    @isTest
    private static void updateAccountCATest() {
        
        List<Order> newOrders = [SELECT Id, NetAmount__c, TotalAmount ,ShipmentCost__c , AccountId, Status FROM Order];
        
        Test.startTest();
        OrderService.updateAccountCA(newOrders);
        Test.stopTest();

        // make assertion
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        for (Account acc : updatedAccounts) {
            // Le chiffre d'affaires doit être augmenté de 50 (totalAmount) pour la commande
            System.assertEquals(50, acc.Chiffre_d_affaire__c, 'le chiffre d affaire du compte est incorrect, doit être 50');
        }
    } 

    @isTest
    private static void netAmountCalculationTest() {
        
        List<Order> newOrders = [SELECT Id, NetAmount__c, TotalAmount ,ShipmentCost__c , AccountId, Status FROM Order];
        
        Test.startTest();
        OrderService.netAmountCalculation(newOrders);
        update newOrders;
        Test.stopTest();

        List<Order> updatedOrders = [SELECT Id, NetAmount__c FROM Order];

        for (Order ord : updatedOrders) {
            // Le Net amount doit être de 45 sur la commande 
            System.assertEquals(45, ord.NetAmount__c, 'Le net amount de la commande est incorrect' );
        }
    }
}

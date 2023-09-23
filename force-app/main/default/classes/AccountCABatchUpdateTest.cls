@isTest
private class AccountCABatchUpdateTest {
    
    @TestSetup
    static void makeData(){
        // Crée un nouvel utilisateur qui bypasse les déclencheurs sur les commandes
        User user = TestDataFactory.createUser(true);
        System.runAs(user){

        // créé 2 set de données pour le test (une commande et un compte associé, avec tous les objets annexes nécéssaires à leur création)
        TestDataFactory.createAccountWithAnOrder('test Account 1');
        TestDataFactory.createAccountWithAnOrder('test Account 2');
        }
    }

    @isTest
    static void test(){
    AccountCABatchUpdate uca = new AccountCABatchUpdate();
    Test.startTest();
    uca.launchAccountCABatchUpdate();
    //Id batchId = Database.executeBatch(uca);
    Test.stopTest();
    
    //after the testing stops, assert records were updated properly
    System.assertEquals(2, [SELECT COUNT() FROM Account WHERE Chiffre_d_affaire__c = 50], 'The count of updated accounts is incorrect.');

    }
}

    

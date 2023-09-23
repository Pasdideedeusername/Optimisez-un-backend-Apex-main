@isTest
public with sharing class MyTeamOrdersControllerTest {
    
    @isTest
    static void testSumOrders() {
        //Crée des données
        TestDataFactory.createAccountWithAnOrder('AccountTest 1');
        TestDataFactory.createAccountWithAnOrder('AccountTest 2');

        // Instancie le contrôleur
        MyTeamOrdersController controller = new MyTeamOrdersController();

        // Appelle la méthode SumOders du contrôleur
        Test.startTest();
        Decimal totalAmount = controller.SumOders;
        Test.stopTest();

        // Vérifie que la somme des montants est correcte
        Decimal expectedTotal = 2 * 50; // Il y a 2 commandes avec un montant de 50 chacune
        System.assertEquals(expectedTotal, totalAmount, 'La somme des montants des commandes est incorrecte.');
    }
}

@isTest
private class OrderTriggersTest {


    @isTest
    static void testAfterUpdateAccountCAWithTriggerBypass() {
        User user = TestDataFactory.createUser(true);
        System.runAs(user){
            Test.startTest();
            TestDataFactory.createAccountWithAnOrder('Test Account');
            Test.stopTest();
     
            List <Account> testAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];

            for (Account acc : testAccounts) {
                System.assertEquals(0, acc.Chiffre_d_affaire__c);
            }
        }
    }

    @isTest
    static void testAfterUpdateAccountCAWithoutTriggerBypass() {
        User user = TestDataFactory.createUser(false);
        System.runAs(user){
            Test.startTest();
            TestDataFactory.createAccountWithAnOrder('Test Account');
            Test.stopTest();
     
            List <Account> testAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];

            for (Account acc : testAccounts) {
                System.assertEquals(50, acc.Chiffre_d_affaire__c);
            }
        }
    }

    @isTest
    static void testBeforeUpdateNetAmountCalculation() {
                
        List <Order> testOrders = [SELECT Id, NetAmount__c FROM Order];

        for (Order ord : testOrders) {
            System.assertEquals(45, ord.NetAmount__c);
        }
    }
}

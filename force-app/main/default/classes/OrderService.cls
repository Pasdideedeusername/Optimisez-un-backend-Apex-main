// nouveau fichier créé par Carine
// contient la logique des 2 triggers sur Order

public class OrderService {

    public static void netAmountCalculation(List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
        }
    }

    public static void updateAccountCA(List<Order> newOrders) {
        // Crée un ensemble pour stocker les IDs de compte uniques
        Set<Id> accountIds = new Set<Id>();

        // Remplit l'ensemble avec les IDs de compte à partir des nouvelles commandes
        for (Order newOrder : newOrders) {
            if (newOrder.AccountId != null && newOrder.Status == 'Activated') {
                accountIds.add(newOrder.AccountId);
            }
        }

        // Récupère les comptes associés aux IDs de compte uniques
        List<Account> accountsToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds];

        // Crée une carte pour stocker les mises à jour de chiffre d'affaires par ID de compte
        Map<Id, Decimal> accountIdToTotalAmount = new Map<Id, Decimal>();

        for (Order newOrder : newOrders) {
            if (newOrder.AccountId != null && newOrder.Status == 'Activated') {
                if (!accountIdToTotalAmount.containsKey(newOrder.AccountId)) {
                    // insère la valeur de totalAmount et l'Id du compte si la commande est nouvelle
                    accountIdToTotalAmount.put(newOrder.AccountId, newOrder.TotalAmount);
                } else {
                    // Sinon ajoute le montant total au montant existant, s'il y a déjà une valeur dans dans TotalAmount
                    accountIdToTotalAmount.put(newOrder.AccountId, accountIdToTotalAmount.get(newOrder.AccountId) + newOrder.TotalAmount);
                }
            }
        }

        // Met à jour les montants de chiffre d'affaires dans la liste de comptes à mettre à jour
        for (Account acc : accountsToUpdate) {
            if (acc != null && accountIdToTotalAmount.containsKey(acc.Id)) {
                acc.Chiffre_d_affaire__c += accountIdToTotalAmount.get(acc.Id);
            }
        }
        // Effectue la mise à jour groupée des comptes
        update accountsToUpdate;
    }
}

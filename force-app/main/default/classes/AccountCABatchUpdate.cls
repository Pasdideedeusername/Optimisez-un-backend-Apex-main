// fichier créé par Carine pour le P9
// nouvelle classe de batch pour mettre à jour le chiffre d'affaires des comptes

public class AccountCABatchUpdate implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext context) {
        
        // Définition de la requête pour sélectionner les enregistrements d'ordres à traiter
        String query = 'SELECT Id, TotalAmount, AccountId, Status ' +
                       'FROM Order ' +
                       'WHERE Status = \'Activated\' AND AccountId != null';

        // Retourne un QueryLocator basé sur la requête définie
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<SObject> scope) {

        // Conversion de la liste générique en une liste spécifique d'objets "Order"
        List<Order> ordersToUpdate = (List<Order>)scope;
        
        // Appel de la méthode de service pour mettre à jour les comptes associés aux commandes
        OrderService.updateAccountCA(ordersToUpdate);
    }

    public void finish(Database.BatchableContext context) {
        // Traitement à effectuer lorsque le lot est terminé
    }

    public void launchAccountCABatchUpdate() {
        // Exécution du lot en utilisant cette classe avec une taille de lot de 200
        Database.executeBatch(this, 200);
    }
}

// nouveau fichier vs Fasha original, contenant 2 trigger. 
//Remplace les 2 fichiers existants calculMontant et updateAccountCA
// logique déplacée dans une classe de service

trigger OrderTriggers on Order (before update, after update) {
   User currentUser= [SELECT Id, OrderTriggerBypass__c FROM User WHERE Id=: UserInfo.getUserId()];
   if (!currentUser.OrderTriggerBypass__c == true){
   
        if (Trigger.isBefore && Trigger.isUpdate) {  
            for (Order newOrder : Trigger.new) {
                OrderService.netAmountCalculation(Trigger.new);
            }
        }

        if (Trigger.isAfter && Trigger.isUpdate) {
            List<Order> ordersToUpdate = new List<Order>();
        
            for (Order newOrder : Trigger.new) {
                Order oldOrder = Trigger.oldMap.get(newOrder.Id);
        
                if (newOrder.Status != oldOrder.Status) {
                    ordersToUpdate.add(newOrder);
                }
            }

            if (!ordersToUpdate.isEmpty()) {
                OrderService.updateAccountCA(ordersToUpdate);
            }
        }
    }
}
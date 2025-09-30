extends Node

var payment

func _ready():
	print(JSON.parse("""{"orderId":"GPA.3356-9736-5047-71308","packageName":"com.williamqm.mmorelam","productId":"1000_gold","purchaseTime":1727888638965,"purchaseState":0,"purchaseToken":"eampimjbngjbjgnlmfcpbhcb.AO-J1OysAgYN5RSOwLHlcRZelknYo9G1I0wBKoObELm_UTbhKisUzM9-o0s79-dXP18KFi5vKmizqtiSJ3s9-7c48sdvJgwOIlHvtyHpcvdSRfnlbTM7WtI","quantity":2,"acknowledged":false}, packageName:com.williamqm.mmorelam, productId:1000_gold, purchaseState:1, purchaseTime:1727888638965, purchaseToken:eampimjbngjbjgnlmfcpbhcb.AO-J1OysAgYN5RSOwLHlcRZelknYo9G1I0wBKoObELm_UTbhKisUzM9-o0s79-dXP18KFi5vKmizqtiSJ3s9-7c48sdvJgwOIlHvtyHpcvdSRfnlbTM7WtI, signature:L1UwVgobJ5TjFZmTB/JtF+nJEVJbFSvjtGJktDTj8k1MrnudiJd7gxB1vHNz+Ps/AY/HC+CvMPOoJY6cW42ZnPTwlMdGYgdgZ/c0ei5fE3sI/9QXkZKzLrO3MqFwuyd+HA3W2ij5azJF1FYLXrrd+O8HhaC2x+nPquaLVcUca4+Aq7Ezo9N0GX33xscKEO3A6N/pvS5DH6n7VQNXgPSxVkN+oVhr/mDrlG7NKJnOeozbAGh3VdXQDQD/lYeDSDzXs5WZ9dQKyfs4BIt/uzs2kWS4ACGBw63XoCVASijYxJNQPnRD/PkNv5H6l1GIRdPP35Jt66zrlxY+12NPf/1r9A==}
{"orderId":"GPA.3356-9736-5047-71308","packageName":"com.williamqm.mmorelam","productId":"1000_gold","purchaseTime":1727888638965,"purchaseState":0,"purchaseToken":"eampimjbngjbjgnlmfcpbhcb.AO-J1OysAgYN5RSOwLHlcRZelknYo9G1I0wBKoObELm_UTbhKisUzM9-o0s79-dXP18KFi5vKmizqtiSJ3s9-7c48sdvJgwOIlHvtyHpcvdSRfnlbTM7WtI","quantity":2,"acknowledged":false}
""").get_result())
	print("Ready")
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("disconnected", self, "_on_disconnected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("product_details_query_completed", self, "_on_product_details_query_completed") # SKUs (Dictionary[])
		payment.connect("product_details_query_error", self, "_on_product_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("query_purchases_response", self, "_on_query_purchases_response")
		
		payment.startConnection()
	else:
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")

func _on_connected():
	payment.queryProductDetails(["1000_gold", "300_gold", "5500_gold"], "inapp")
	payment.queryPurchases("inapp")


var purchased_items = {}
func _on_purchases_updated(purchases):
	for purchase in purchases:
		if purchase.purchaseState == 1:
			if not purchase.isAcknowledged:
				payment.consumePurchase(purchase.purchaseToken)
				
				print(purchase)
				print(purchase.originalJson)
				print(JSON.parse(purchase.originalJson).get_result())
				
				var id_data = purchase.productId.split("_")
				purchased_items[purchase.purchaseToken] = {
					"type" : id_data[1],
					"value" : JSON.parse(purchase.originalJson).get_result().quantity*int(id_data[0])
				}

func _on_query_purchases_response(result):
	for purchase in result.purchases:
		payment.consumePurchase(purchase.purchaseToken)

func _on_purchase_consumed(token):
	var data = purchased_items[token]
	var type = data.type
	var value = data.value
	var username = GameUI.account_data.username
	
	Gateway.VerifyPurchase(token,type,value,username)

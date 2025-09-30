extends PanelContainer

var shop_node

onready var title_node = get_node("Container/HBoxContainer/Title")
onready var description_node = get_node("Container/Description")
onready var buy_node = get_node("Container/Buy")
onready var icon_node = get_node("Container/HBoxContainer/TextureRect")

func SetOffer(offer):
	title_node.text = offer.title
	description_node.text = offer.description
	
	buy_node.connect("pressed", self, "OpenOffer", [offer.link, offer.gplay_id])
	buy_node.text = "$%s" % [str(offer.price)]
	
	icon_node.texture = icon_node.texture.duplicate()
	icon_node.texture.region = offer.icon

func OpenOffer(link, gplay_id):
	Gateway.requesting_node = shop_node
	
	if PlayBilling.payment:
		PlayBilling.payment.purchase(gplay_id,"inapp","","")
	else:
		OS.shell_open(link)

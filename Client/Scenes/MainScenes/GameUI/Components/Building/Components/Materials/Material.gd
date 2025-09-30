extends TextureRect

var disabled = Color("848484")
var enabled = Color("ffffff")

func Has(has):
	modulate = enabled if has else disabled

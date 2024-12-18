extends Control
class_name Card

@export var card_name := ""

@export var card_description := ""

## Does the card attack all enemies?
@export var is_barrage := false


var times_used := 0
var upgrade_level := 0
var has_focused := false


func is_focused():
    # TODO: ask focus system if we're focused?
    return has_focused

func load_card():
    pass

func play(target):
    pass

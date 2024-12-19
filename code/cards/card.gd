extends Control
class_name Card

@export var card_name := ""

@export var card_description := ""

## Does the card attack all enemies?
@export var is_barrage := false

@onready var barrel_root := $card_root/barrel_root
@onready var click_area := $card_root/ClickArea


var times_used := 0
var upgrade_level := 0


func _ready():
    click_area.pressed.connect(_on_pressed)


func _on_pressed():
    InputFocus.set_focus(self)


func is_focused():
    return InputFocus.is_focused(self)


func load_card():
    pass


func play(target):
    pass


func next_chamber():
    upgrade_level += 1
    barrel_root.rotation += TAU/3

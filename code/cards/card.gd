extends Control
class_name Card

@onready var barrel_root := $card_root/barrel_root
@onready var click_area := $card_root/ClickArea
@onready var actions_root := $"%card_actions"


var def : CardDef
var times_used := 0
var upgrade_level := 0
var chamber_values : Array[int] = []


func _ready():
    click_area.pressed.connect(_on_pressed)
    load_card(def)


func _on_pressed():
    InputFocus.set_focus(self)


func is_focused():
    return InputFocus.is_focused(self)


func load_card(card_def: CardDef):
    chamber_values = card_def.chamber_values
    for item in card_def.actions:
        add_action(item)


func add_action(action):
    var a = action.instantiate()
    actions_root.add_child(a)


func play(target):
    var power = chamber_values[upgrade_level]
    for action in actions_root.get_children():
        action.apply(target, power)


func next_chamber():
    upgrade_level += 1
    barrel_root.rotation += TAU/3

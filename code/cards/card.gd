extends Control
class_name Card

@export var chamber_labels: Array[Control] = []

@onready var card_front: Control = $card_root
@onready var card_back: Control = $card_back

@onready var barrel_root := $card_root/barrel_root
@onready var click_area := $card_root/ClickArea
@onready var actions_root := $"%card_actions"
@onready var art: TextureRect = $"%card_art"

var def: CardDef
var times_used := 0
var upgrade_level := 0
var chamber_values: Array[int] = []


func _ready():
    click_area.pressed.connect(_on_pressed)
    load_card(def)
    set_is_face_up(false)


func set_is_face_up(want_face_up):
    card_front.visible = want_face_up
    card_back.visible = not want_face_up


func is_face_up():
    return card_front.visible


func requires_target():
    return def.requires_target(actions_root)


func _on_pressed():
    if InputFocus.lock_input:
        return

    InputFocus.set_focus(self)


func is_focused():
    return InputFocus.is_focused(self)


func load_card(card_def: CardDef):
    var numbers = load("res://scenes/numbers.tres")
    chamber_values = card_def.chamber_values
    for i in chamber_values.size():
        var v = chamber_values[i]
        var label = chamber_labels[i]
        label.texture = numbers.get_number(v)

    art.texture = card_def.get_art()
    card_def.add_actions(actions_root)

func play(actor, target):
    var power = chamber_values[upgrade_level]
    for action in actions_root.get_children():
        await action.apply(actor, target, power)


func next_chamber():
    upgrade_level += 1
    var start = barrel_root.rotation
    var dest = barrel_root.rotation + TAU / 3

    # simple animation.
    var anim_frames := 10
    for i in range(anim_frames):
        var r = lerp(start, dest, float(i) / anim_frames)
        barrel_root.rotation = r
        await get_tree().process_frame
    barrel_root.rotation = dest

    if upgrade_level == chamber_values.size():
        upgrade()


func upgrade():
    # TODO: replace card with upgrade?
    # maybe call load_card with the upgrade card.
    upgrade_level = 0

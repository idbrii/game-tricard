extends Control
class_name Card

@export var chambers: Array[Control] = []

@onready var card_front: Control = $card_root
@onready var card_back: Control = $card_back

@onready var barrel_root := $card_root/barrel_root
@onready var click_area := $card_root/ClickArea
@onready var actions_root := $"%card_actions"
@onready var art: TextureRect = $"%card_art"

var def: CardDef
var times_used := 0
var upgrade_level := 0
var active_chamber := 0
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
    chamber_values = card_def.chamber_values.duplicate()
    for i in chamber_values.size():
        var chamber = chambers[i]
        var v = chamber_values[i]
        chamber.reload_bullet(v)

    art.texture = card_def.get_art()
    card_def.add_actions(actions_root)

func play(actor, target):
    var power = chamber_values[active_chamber]
    for action in actions_root.get_children():
        await action.apply(actor, target, power)


func next_chamber():
    var chamber = chambers[active_chamber]
    chamber.fire_bullet()
    await get_tree().create_timer(0.9).timeout

    active_chamber += 1
    var start = barrel_root.rotation
    var dest = barrel_root.rotation + TAU / 3

    # simple animation.
    var anim_frames := 10
    for i in range(anim_frames):
        var r = lerp(start, dest, float(i) / anim_frames)
        barrel_root.rotation = r
        await get_tree().process_frame
    barrel_root.rotation = dest

    if active_chamber == chamber_values.size():
        upgrade()


func upgrade():
    upgrade_level += 1
    for i in range(chamber_values.size()):
        chamber_values[i] += upgrade_level
        var chamber = chambers[i]
        chamber.reload_bullet(chamber_values[i])
        await get_tree().create_timer(0.1).timeout
    active_chamber = 0

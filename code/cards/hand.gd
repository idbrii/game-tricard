extends Node3D

## Width of the visible card (for layout calculations).
@export_range(0.1, 10000.0) var card_width := 1.0
## Spacing between cards.
@export_range(0.0, 10000.0) var card_padding := 0.1
## The fraction of a circle used for the card fan. 0 would make them a flat line.
@export_range(0.0, 1.0) var card_fan_angle_turns := 0.25


func _ready():
    layout()

func add_card(card):
    layout()

func layout():
    var count = get_child_count()

    var total_angle = card_fan_angle_turns * TAU
    var angle_delta = total_angle / count
    var angle_offset = -total_angle / 2.0

    var pos_delta = card_width / 2 + card_padding
    var width = count * pos_delta
    var half_width = width / 2.0
    var pos_offset = -half_width

    for card in get_children():
        card.position = Vector3.RIGHT * pos_offset
        printt(card, card.position)
        card.rotation = Vector3.ZERO
        card.rotate_z(TAU - angle_offset)
        pos_offset += pos_delta
        angle_offset += angle_delta

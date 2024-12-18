extends Node3D

## Width of the visible card (for layout calculations).
@export_range(0.1, 10000.0) var card_width := 1.0
## Spacing between cards.
@export_range(0.0, 10000.0) var card_padding := 0.1
## The fraction of a circle used for the card fan. 0 would make them a flat line.
@export_range(0.0, 1.0) var card_fan_angle_turns := 0.25

@export_range(0.0, 10000.0) var dist_from_root := 5.0


func _ready():
    layout()

func add_card(card):
    layout()

func layout():
    var count = get_child_count() - 1

    var total_angle = card_fan_angle_turns * TAU
    var angle_delta = total_angle / count
    var angle_offset = -total_angle / 2.0

    var pos_offset = dist_from_root + card_width

    var point = Vector3.UP * pos_offset
    point = point.rotated(Vector3.FORWARD, angle_offset)

    for card in get_children():
        card.position = point + Vector3.DOWN * pos_offset + Vector3.FORWARD * 0.5
        card.rotation = Vector3.ZERO
        card.rotate_z(point.signed_angle_to(Vector3.UP, Vector3.FORWARD))
        point = point.rotated(Vector3.FORWARD, angle_delta)
        angle_offset += angle_delta

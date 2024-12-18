extends Control

## Width of the visible card (for layout calculations).
@export_range(10.0, 10000.0) var card_width := 510.0
## Extra distance from card arc pivot to card (plus card width).
@export_range(10.0, 10000.0) var dist_from_root := 50.0
## The fraction of a circle used for the card fan. 0 would make them a flat line.
@export_range(0.0, 1.0) var card_fan_angle_turns := 0.25

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

    var point = Vector2.UP * pos_offset
    point = point.rotated(angle_offset)

    for card in get_children():
        card.position = point + Vector2.DOWN * pos_offset
        card.rotation = point.angle_to_point(Vector2.UP) - TAU/4
        point = point.rotated(angle_delta)
        angle_offset += angle_delta

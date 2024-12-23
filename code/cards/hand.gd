extends Control

## Width of the visible card (for layout calculations).
@export_range(10.0, 10000.0) var card_width := 510.0

## Extra distance from card arc pivot to card (plus card width).
@export_range(10.0, 10000.0) var dist_from_root := 50.0

## The fraction of a circle used for the card fan. 0 would make them a flat line.
@export_range(0.0, 1.0) var card_fan_angle_turns := 0.25
## Limit the fraction of a circle between each card in the fan.
@export_range(0.0, 1.0) var card_fan_turns_per_card_max := 0.035

## When a card is selected, move it up a bit.
@export_range(0.0, 3.0) var selected_offset_multiplier := 1.4

var pause_layout := false


func _process(_dt: float):
    if not pause_layout:
        layout()


func layout():
    var count = get_child_count()

    var total_angle = card_fan_angle_turns
    if count > 0:
        var per_card = card_fan_angle_turns / count
        per_card = min(per_card, card_fan_turns_per_card_max)
        total_angle = per_card * count
    total_angle *= TAU

    var angle_delta = total_angle / count
    var angle_offset = -total_angle / 2.0 + angle_delta

    var pos_offset = dist_from_root + card_width

    var point = Vector2.UP * pos_offset
    point = point.rotated(angle_offset)

    for card in get_children():
        var p = point
        if card.is_focused():
            p *= selected_offset_multiplier
        card.position = p + Vector2.DOWN * pos_offset
        card.rotation = p.angle_to_point(Vector2.UP) - TAU / 4
        point = point.rotated(angle_delta)
        angle_offset += angle_delta

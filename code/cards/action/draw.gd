extends CardAction

func _ready():
    texture = preload("res://assets/textures/icons/icon_draw.png")


func apply(actor: Node, _target: Node, power: int):
    actor.draw_card(power)


func get_target_type() -> CardDef.Target:
    return CardDef.Target.SELF


func get_action_name():
    return "Draw"

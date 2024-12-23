extends CardAction


func _ready():
    texture = preload("res://assets/textures/icons/icon_burn.png")


func apply(_actor: Node, target: Node, power: int):
    target.status.mod_burn(power)


func get_target_type() -> CardDef.Target:
    return CardDef.Target.OPPONENT


func get_action_name():
    return "Burn"

extends CardAction


func _ready():
    texture = preload("res://assets/textures/icons/icon_poison.png")


func apply(_actor: Node, target: Node, power: int):
    target.status.mod_poison(power)


func get_target_type() -> CardDef.Target:
    return CardDef.Target.OPPONENT


func get_action_name():
    return "Poison"

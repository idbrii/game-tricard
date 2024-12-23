extends CardAction


func _ready():
    texture = preload("res://assets/textures/icons/icon_heal.png")


func apply(actor: Node, _target: Node, power: int):
    actor.status.mod_health(power)


func get_target_type() -> CardDef.Target:
    return CardDef.Target.SELF


func get_action_name():
    return "Heal"

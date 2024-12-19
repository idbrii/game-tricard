extends CardAction

func _ready():
    texture = preload("res://assets/textures/icons/icon_dmg.png")


func apply(_actor: Node, target: Node, power: int):
    target.status.mod_health(-power)


func get_target_type() -> CardDef.Target:
    return CardDef.Target.OPPONENT

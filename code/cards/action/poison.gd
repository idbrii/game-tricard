extends CardAction

func _ready():
    # TODO: new icon
    texture = preload("res://assets/textures/icons/icon_block.png")

func apply(_actor: Node, target: Node, power: int):
    target.status.mod_poison(power)


func get_target_type() -> CardDef.Target:
    return CardDef.Target.OPPONENT

extends CardAction

func _ready():
    # TODO: new icon
    texture = preload("res://assets/textures/icons/icon_block.png")

func apply(target: Node, power: int):
    target.status.mod_burn(power)


func get_target_type() -> CardDef.Target:
    return CardDef.Target.OPPONENT

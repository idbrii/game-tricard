extends CardAction

func _ready():
    texture = preload("res://assets/textures/icons/icon_block.png")

func apply(target: Node, power: int):
    target.status.mod_block(power)

func get_target_type() -> CardDef.Target:
    return CardDef.Target.SELF

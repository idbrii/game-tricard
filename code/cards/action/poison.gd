extends CardAction

func _ready():
    # TODO: new icon
    texture = preload("res://assets/textures/icons/icon_block.png")

func apply(target: Node, power: int):
    target.status.mod_poison(power)

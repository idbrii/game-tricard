extends CardAction

func _ready():
    # We don't currently have a meaning for this icon.
    texture = preload("res://assets/textures/icons/icon_reload.png")

func apply(_actor: Node, _target: Node, _power: int):
    # Barrage is implemented in player by playing the card on all creatures.
    pass

func get_target_type() -> CardDef.Target:
    return CardDef.Target.OPPONENT

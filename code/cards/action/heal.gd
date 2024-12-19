extends CardAction

func _ready():
    texture = preload("res://assets/textures/icons/icon_heal.png")


func apply(target: Node, power: int):
    target.status.mod_health(power)

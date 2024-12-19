extends CardAction

func _ready():
    texture = preload("res://assets/textures/icons/icon_draw.png")


func apply(target: Node, power: int):
    target.draw_card(power)

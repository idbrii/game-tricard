extends TextureRect

var loaded := preload("res://assets/textures/cardbase/T_Bullet_Full.png")
var spent := preload("res://assets/textures/cardbase/T_Bullet_Empty.png")

@onready var number := get_child(0)


func fire_bullet():
    number.visible = false
    texture = spent


func reload_bullet(value: int):
    var numbers = load("res://scenes/numbers.tres")
    number.texture = numbers.get_number(value)
    number.visible = true
    texture = loaded

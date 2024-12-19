extends TextureRect

@export var barrel_pivot: Control


func _process(_dt: float):
    rotation = -barrel_pivot.rotation

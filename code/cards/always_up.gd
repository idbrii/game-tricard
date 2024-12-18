@tool
extends TextureRect

@export var barrel : Control


func _process(_dt: float):
    rotation = -barrel.rotation

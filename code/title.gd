extends Node3D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene_to_file("res://scenes/battle.tscn")

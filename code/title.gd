extends Node3D


func _ready() -> void:
    if has_node("AnimationPlayer"):
        $AnimationPlayer.play("intro")
        await $AnimationPlayer.animation_finished
        get_tree().change_scene_to_file("res://scenes/title.tscn")


func _process(_dt: float) -> void:
    if Input.is_action_just_pressed("click"):
        get_tree().change_scene_to_file("res://scenes/battle.tscn")

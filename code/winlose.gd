extends Node

@export var player : Node
@export var battle : Node


func _ready():
    player.status.die.connect(_on_died)
    battle.allEnemiesDefeated.connect(_on_all_enemies_defeated)


func _on_died():
    await get_tree().create_timer(3).timeout
    get_tree().change_scene_to_file("res://scenes/title_gameover_lose.tscn")


func _on_all_enemies_defeated():
    await get_tree().create_timer(3).timeout
    get_tree().change_scene_to_file("res://scenes/title_gameover_win.tscn")
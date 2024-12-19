extends Node3D

@onready var status := $Status as Status


func _ready():
    status.hurt.connect(_on_hurt)
    status.die.connect(_on_die)


func _on_hurt():
    $AnimationPlayer.play("enemy_anim_hurt")


func _on_die():
    $AnimationPlayer.play("enemy_anim_dead")

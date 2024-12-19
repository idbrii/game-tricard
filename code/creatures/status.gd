extends Node
class_name Status

signal hurt(amount)
signal die()

@export var health := 100
@export var block := 0
@export var turns := 0

@export var health_label : Label3D


func _ready():
    _update_health()


func _update_health():
    if health_label:
        health_label.text = str(health)


func mod_health(amount):
    # TODO: resolve block
    health += amount
    if health <= 0:
        die.emit()
    elif amount < 0:
        hurt.emit(amount)

    _update_health()

func mod_block(amount):
    block += amount
    block = max(block, 0)


func mod_turns(amount):
    turns += amount

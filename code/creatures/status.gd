extends Node
class_name Status

signal blocked(amount)
signal hurt(amount)
signal die()

@export var health := 100
@export var block := 0
@export var turns := 0

## Label or Label3D for current health value.
@export var health_label : Node

## Label or Label3D for current block value.
@export var block_label : Node

## Label or Label3D for current turns value.
@export var turns_label : Node


func _ready():
    _update_health()


func _update_health():
    if health_label:
        health_label.text = str(health)


func _update_block():
    if block_label:
        block_label.text = str(block)


func _update_turns():
    if turns_label:
        turns_label.text = str(turns)


func mod_health(amount):
    if amount < 0 and block > 0:
        var before = amount
        var used_block = min(-amount, block)
        amount += used_block
        block -= used_block
        blocked.emit(used_block)
        _update_block()

    health += amount
    _update_health()

    if health <= 0:
        die.emit()
    elif amount < 0:
        hurt.emit(amount)

func mod_block(amount):
    block += amount
    block = max(block, 0)
    _update_block()


func mod_turns(amount):
    turns += amount
    _update_turns()

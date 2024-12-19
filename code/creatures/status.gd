extends Node
class_name Status

signal blocked(amount)
signal hurt(amount)
signal die()

## Life force
@export var health := 100

## Prevent this much damage
@export var block := 0

## At end of turn, damage by this much and reduce burn by one.
@export var burn := 0

## At end of turn, reduce health by this much and reduce poison by two.
@export var poison := 0

@export var turns := 0


## Label or Label3D for current health value.
@export var health_label : Node

## Label or Label3D for current block value.
@export var block_label : Node

## Label or Label3D for current burn value.
@export var burn_label : Node

## Label or Label3D for current poison value.
@export var poison_label : Node

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


func _update_burn():
    if burn_label:
        burn_label.text = str(burn)


func _update_poison():
    if poison_label:
        poison_label.text = str(poison)


func _update_turns():
    if turns_label:
        turns_label.text = str(turns)


func end_turn():
    if burn > 0:
        mod_health(-burn)
        mod_burn(-1)
    if poison > 0:
        mod_health(-poison, true)
        mod_poison(-2)


func mod_health(amount, ignore_block = false):
    if not ignore_block and amount < 0 and block > 0:
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


func _mod_stat(stat, amount):
    stat += amount
    stat = max(stat, 0)
    return stat


func mod_block(amount):
    block = _mod_stat(block, amount)
    _update_block()


func mod_burn(amount):
    burn = _mod_stat(burn, amount)
    _update_burn()


func mod_poison(amount):
    poison = _mod_stat(poison, amount)
    _update_poison()


func mod_turns(amount):
    turns += amount
    _update_turns()

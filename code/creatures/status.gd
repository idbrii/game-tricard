extends Node
class_name Status

signal hurt(amount:int)
signal die()
signal turned(current:int)
signal blocked(amount:int)

@export var display_name:String
## Life force
@export var health := 100
## Prevent this much damage
@export var block := 0
## At end of turn, damage by this much and reduce burn by one.
@export var burn := 0
## At end of turn, reduce health by this much and reduce poison by two.
@export var poison := 0
@export var turns := 0
@export var maxTurns:int = 1
@export var maxHealth:int = 100
@export var maxBlocks:int = 1

func reset():
	health = maxHealth
	turns = maxTurns
	block = 0
	poison = 0
	burn = 0

func is_dead() -> bool:
	return health <= 0

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
	health += amount
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

func mod_burn(amount):
	burn = _mod_stat(burn, amount)

func mod_poison(amount):
	poison = _mod_stat(poison, amount)

func mod_turns(amount):
	turns += amount
	turned.emit(turns)

func reset_turns():
	turns = maxTurns

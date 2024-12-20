extends Node
class_name Status

signal heal(amount:int)
signal hurt(amount:int)
signal die()
signal turned(current:int)
signal blocked_damage(amount:int)
signal burn_damage(amount:int)
signal poison_damage(amount:int)

@export var display_name:String
## Life force
@export var health:int
## Prevent this much damage
@export var block:int
## At end of turn, damage by this much and reduce burn by one.
@export var burn:int
## At end of turn, reduce health by this much and reduce poison by two.
@export var poison:int
@export var turns:int
@export var maxTurns:int = 1
@export var maxHealth:int = 3
@export var maxBlocks:int = 1

func reset():
    health = maxHealth
    turns = maxTurns
    block = 0
    poison = 0
    burn = 0

func is_dead() -> bool:
    return health <= 0


func end_turn() -> bool:
    var did_something := false
    if burn > 0:
        burn_damage.emit(burn)
        mod_health(-burn)
        mod_burn(-1)
        did_something = true
    if poison > 0:
        poison_damage.emit(poison)
        mod_health(-poison, true)
        mod_poison(-2)
        did_something = true
    return did_something


func mod_health(amount, ignore_block = false):
    prints("do dmg!", amount)
    if !ignore_block and amount < 0 and block > 0:
        print("blocking")
        var used_block = min(-amount, block)
        amount += used_block
        block -= used_block
        blocked_damage.emit(used_block)
    health += amount
    if health <= 0:
        die.emit()
    elif amount < 0:
        hurt.emit(amount)
    elif amount > 0:
        heal.emit(amount)


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

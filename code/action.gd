extends Node
class_name Action

enum Move {
    Attack,
    Block,
    Heal,
    Poison,
    Burn,
}

@export var power: int = 1
@export var moves: Array[Move]

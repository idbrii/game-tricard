extends Node

@export var status: Status

@export var hp: Node
@export var turn: Node
@export var block: Node
@export var burn: Node
@export var poison: Node


func update_labels():
    hp.get_node("Label").text = str(status.health)
    if turn:
        turn.get_node("Label").text = str(status.turns)
    block.get_node("Label").text = str(status.block)
    burn.get_node("Label").text = str(status.burn)
    poison.get_node("Label").text = str(status.poison)
    block.visible = status.block > 0
    burn.visible = status.burn > 0
    poison.visible = status.poison > 0

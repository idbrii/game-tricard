extends Node

@onready var status := $Status as Status

@onready var attack_btn := $"%AttackButton"
@onready var self_btn := $"%SelfButton"

## Placeholder until we have targeting.
@onready var victim := $"%DummyTarget"



func _ready():
    attack_btn.pressed.connect(_on_attack_pressed)


func _on_attack_pressed():
    var card := InputFocus.get_focus() as Card
    if card:
        printt("Playing card", card, "on", victim)
        card.play(victim)

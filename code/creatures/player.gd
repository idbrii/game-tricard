extends Node

@onready var status := $Status as Status

@onready var attack_btn := $"%AttackButton"
@onready var target_self_btn := $"%SelfButton"

## Placeholder until we have targeting.
@onready var victim := $"%DummyTarget"



func _ready():
    attack_btn.pressed.connect(_on_attack_pressed)
    target_self_btn.pressed.connect(_on_target_self_pressed)


func _on_attack_pressed():
    play_card(victim)


func _on_target_self_pressed():
    play_card(self)


func play_card(target):
    var card := InputFocus.get_focus() as Card
    if card:
        printt("Playing card", card, "on", target)
        card.play(target)
        await get_tree().create_timer(0.6).timeout
        # Clear the card so it goes back into the hand.
        InputFocus.set_focus(null)

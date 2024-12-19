extends Node
class_name Player

@onready var status := $Status as Status
@onready var attack_btn := $"%AttackButton"
@onready var target_self_btn := $"%SelfButton"
@onready var discard_btn := $"%HUD/DiscardAll"
@onready var deck := $"%HUD/Deck"
@onready var scene:Battle = self.get_parent()

func _ready():
	scene.mode = Battle.Mode.None
	attack_btn.pressed.connect(_on_attack_pressed)
	target_self_btn.pressed.connect(_on_target_self_pressed)
	discard_btn.pressed.connect(_on_discard_pressed)

func _on_attack_pressed():
	if scene.mode != Battle.Mode.None:
		return
	scene.mode = Battle.Mode.Select
	var en:Enemy = await scene.enemyPicked
	scene.mode = Battle.Mode.PlayerTurn
	await play_card(en)
	await scene.startEnemyTurn(self)

func _on_target_self_pressed():
	if scene.mode != Battle.Mode.None:
		return
	scene.mode = Battle.Mode.PlayerTurn
	await play_card(self)
	await scene.startEnemyTurn(self)

func _on_discard_pressed():
	deck.discard_all()

func play_card(target):
	var card := InputFocus.get_focus() as Card
	if card:
		prints("Playing card", card, "on", target)
		card.play_card(self, target)
		await get_tree().create_timer(0.6).timeout
		# Clear the card so it goes back into the hand.
		InputFocus.set_focus(null)

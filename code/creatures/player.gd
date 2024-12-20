extends Node
class_name Player

@onready var status := $Status as Status
@onready var attack_btn := $"%AttackButton"
@onready var discard_btn := $"%HUD/DiscardAll"
@onready var deck := $"%HUD/Deck"
@onready var scene:Battle = self.get_parent()

func _ready():
	scene.mode = Battle.Mode.None
	attack_btn.pressed.connect(_on_attack_pressed)
	discard_btn.pressed.connect(_on_discard_pressed)


func _on_attack_pressed():
	if scene.mode != Battle.Mode.None:
		return

	var card := InputFocus.get_focus() as Card
	if not card:
		return

	var target = self
	# Pick a target if needed
	if card.requires_target():
		scene.mode = Battle.Mode.Select
		target = await scene.enemyPicked
	prints("Playing card", card, "on", target)
	scene.mode = Battle.Mode.PlayerTurn
	InputFocus.set_focus(null)
	if card.def.is_barrage:
		var que = scene.enemies.values()
		for en:Enemy in que:
			card.play(self, en)
	else:
		card.play(self, target)
	card.inc_chamber()
	await get_tree().create_timer(0.6).timeout
	await scene.startEnemyTurn(self)

func _on_discard_pressed():
	deck.discard_all()

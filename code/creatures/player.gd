extends Node
class_name Player

@onready var status := $Status as Status
@onready var attack_btn := $"%AttackButton"
@onready var discard_btn := $"%HUD/DiscardAll"
@onready var deck := $"%HUD/Deck"
@onready var scene:Battle = self.get_parent()

func _ready():
    status.maxHealth = 10
    status.maxBlocks = 3
    status.reset()
    update_status_labels()
    scene.mode = Battle.Mode.None
    status.die.connect(_on_died)
    status.hurt.connect(_on_hurt)
    status.blocked.connect(_on_block)
    attack_btn.pressed.connect(_on_attack_pressed)
    discard_btn.pressed.connect(_on_discard_pressed)

func update_status_labels():
    $Stats/Health/Label.text = str(status.health)
    $Stats/Block/Label.text = str(status.block)

func _on_died():
    update_status_labels()
    scene.get_node("Camera").shake()
    # TODO trigger game over!

func _on_hurt(_amount:int):
    update_status_labels()
    scene.get_node("Camera").shake()

func _on_block(_amount:int):
    update_status_labels()
    print("blocked")
    # TODO play screen animation

func _on_attack_pressed():
    if scene.mode != Battle.Mode.None:
        return

    var card := InputFocus.get_focus() as Card
    if not card:
        return

    var target = self
    # Pick a target if needed
    if card.requires_target():
        attack_btn.text = "Select Target"
        scene.mode = Battle.Mode.Select
        target = await scene.enemyPicked
    prints("Playing card", card, "on", target)
    attack_btn.text = "Please Wait"
    scene.mode = Battle.Mode.PlayerTurn
    InputFocus.set_focus(null)
    if card.def.is_barrage:
        var que = scene.enemies.values()
        for en:Enemy in que:
            card.play(self, en)
    else:
        card.play(self, target)
    card.inc_chamber()
    await get_tree().create_timer(1.0).timeout
    await scene.startEnemyTurn(self)
    scene.mode = Battle.Mode.None
    attack_btn.text = "Pick Card"

func _on_discard_pressed():
    deck.discard_all()
    await get_tree().create_timer(0.5).timeout
    deck.draw_cards(deck.hand_size)
    await scene.startEnemyTurn(self)

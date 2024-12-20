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
    status.blocked_damage.connect(_on_block_damage)
    attack_btn.pressed.connect(_on_play_pressed)
    discard_btn.pressed.connect(_on_discard_pressed)
    scene.enemyPicked.connect(_on_enemyPicked)
    InputFocus.gain_focus.connect(_on_card_selected)

func update_status_labels():
    $Stats.update_labels()

func _on_died():
    update_status_labels()
    scene.get_node("Camera").shake()
    # TODO trigger game over!

func _on_hurt(_amount:int):
    update_status_labels()
    scene.get_node("Camera").shake()

func _on_block_damage(_amount:int):
    update_status_labels()
    print("blocked_damage")
    # TODO play screen animation


func _on_card_selected(_old_focus, new_focus):
    if new_focus.requires_target():
        attack_btn.text = "Select Target"
        scene.mode = Battle.Mode.Select
    else:
        if new_focus.def.is_barrage:
            attack_btn.text = "Attack All"
            scene.mode = Battle.Mode.SelectAll
        else:
            attack_btn.text = "Play Card"
            scene.mode = Battle.Mode.None


func _on_enemyPicked(target):
    scene.mode = Battle.Mode.None
    var card := get_current_card()
    if not card:
        return

    _play_card(card, target)


func get_current_card() -> Card:
    return InputFocus.get_focus() as Card


func _on_play_pressed():
    if InputFocus.lock_input:
        return

    if scene.mode != Battle.Mode.None and scene.mode != Battle.Mode.SelectAll:
        return

    var card := get_current_card()
    if not card:
        return

    _play_card(card, self)


func _play_card(card: Card, target):
    prints("Playing card", card, "on", target)
    attack_btn.text = "Please Wait"
    scene.mode = Battle.Mode.PlayerTurn
    InputFocus.lock_input = true
    if card.def.is_barrage:
        var que = scene.enemies.values()
        for en:Enemy in que:
            card.play(self, en)
    else:
        card.play(self, target)
    update_status_labels()
    await card.next_chamber()
    await get_tree().create_timer(1.0).timeout
    await deck.discard_card_anim(card)
    InputFocus.set_focus(null)
    await scene.startEnemyTurn(self)
    scene.mode = Battle.Mode.None
    attack_btn.text = "Pick Card"
    InputFocus.lock_input = false


func _on_discard_pressed():
    if InputFocus.lock_input:
        return

    InputFocus.lock_input = true
    deck.discard_all()
    await get_tree().create_timer(0.5).timeout
    deck.draw_cards(deck.hand_size)
    await scene.startEnemyTurn(self)
    InputFocus.lock_input = false

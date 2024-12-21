extends Node
class_name Player


@export var hand_neutral_pos : Control


@onready var status := $Status as Status
@onready var attack_btn := $"%AttackButton"
@onready var cheat_upgrade_btn := $"%CheatButton"
@onready var cheat_giveup_btn := $"%GiveUpButton"
@onready var discard_btn := $"%HUD/DiscardAll"
@onready var deck := $"%HUD/Deck"
@onready var scene:Battle = self.get_parent()


func _ready():
    attack_btn.text = "Pick Card"
    status.maxHealth = 10
    status.maxBlocks = 3
    status.reset()
    update_status_labels()
    scene.mode = Battle.Mode.None
    status.die.connect(_on_died)
    status.hurt.connect(_on_hurt)
    status.blocked_damage.connect(_on_block_damage)
    attack_btn.pressed.connect(_on_play_pressed)
    cheat_upgrade_btn.pressed.connect(_on_cheat_upgrade_pressed)
    cheat_giveup_btn.pressed.connect(_on_cheat_giveup_pressed)
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
            attack_btn.text = "Target Self"
            scene.mode = Battle.Mode.None


func _on_enemyPicked(target):
    scene.mode = Battle.Mode.None
    var card := get_current_card()
    if not card:
        return

    _play_card(card, target)


func get_current_card() -> Card:
    return InputFocus.get_focus() as Card


func _on_cheat_upgrade_pressed():
    for card in deck.hand.get_children():
        card.upgrade()


func _on_cheat_giveup_pressed():
    status.mod_health(-100000)


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
    attack_btn.text = "Playing..."
    scene.mode = Battle.Mode.PlayerTurn
    # Don't set_waiting_for_enemy yet so our cards are still the focus.
    block_input(true)
    if card.def.is_barrage:
        var que = scene.enemies.values()
        for en:Enemy in que:
            card.play(self, en)
    else:
        card.play(self, target)
    update_status_labels()
    await card.next_chamber()
    await get_tree().create_timer(0.5).timeout
    await deck.discard_card_anim(card)
    await set_waiting_for_enemy(true)
    await end_turn()


func _on_discard_pressed():
    if InputFocus.lock_input:
        return

    await set_waiting_for_enemy(true)
    deck.discard_all()
    await get_tree().create_timer(0.5).timeout
    await deck.draw_cards(deck.hand_size)
    await end_turn()


func end_turn():
    update_status_labels()
    if status.end_turn():
        update_status_labels()
        # Make sure player sees their stats tick down.
        await get_tree().create_timer(0.5).timeout
    InputFocus.set_focus(null)
    attack_btn.text = "Enemy Turn"
    await scene.startEnemyTurn(self)
    scene.mode = Battle.Mode.None
    attack_btn.text = "Pick Card"
    await set_waiting_for_enemy(false)


func draw_card(power):
    await deck.draw_cards(power)
    await get_tree().create_timer(0.4).timeout


func block_input(should_block):
    InputFocus.lock_input = should_block
    discard_btn.disabled = should_block


func set_waiting_for_enemy(is_waiting):
    block_input(is_waiting)

    # widgets move when window is resized, so use a ref
    var dest = hand_neutral_pos.global_position
    if is_waiting:
        dest += Vector2.DOWN * 200

    var start = deck.hand.global_position
    var anim_frames := 4
    for i in range(anim_frames):
        var pos = lerp(start, dest, float(i) / anim_frames)
        deck.hand.global_position = pos
        await get_tree().process_frame
    deck.hand.global_position = dest

extends Node

@export var spit: Array[AudioStream]
@export var poison: Array[AudioStream]
@export var burn: Array[AudioStream]
@export var hurt: Array[AudioStream]
@export var heal: Array[AudioStream]

@onready var discard_btn := $"%HUD/DiscardAll"

var pool: AudioPooler


func _ready():
    pool = AudioPooler.new()
    add_child(pool)

    await get_tree().process_frame
    var player = get_parent()
    player.status.burn_damage.connect(_on_burn_damage)
    player.status.poison_damage.connect(_on_poison_damage)
    player.status.hurt.connect(_on_hurt)
    player.status.heal.connect(_on_heal)

    discard_btn.pressed.connect(_on_discard_pressed)


func _on_discard_pressed():
    var sound = Random.choose_value(spit)
    pool.play(sound)


func _on_burn_damage(_amount: int):
    pool.play(Random.choose_value(burn))


func _on_poison_damage(_amount: int):
    pool.play(Random.choose_value(poison))


func _on_hurt(_amount: int):
    pool.play(Random.choose_value(hurt))


func _on_heal(_amount: int):
    pool.play(Random.choose_value(heal))

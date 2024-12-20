extends Node

@export var spit : Array[AudioStream]

@onready var discard_btn := $"%HUD/DiscardAll"

var pool : AudioPooler


func _ready():
    pool = AudioPooler.new()
    add_child(pool)
    discard_btn.pressed.connect(_on_discard_pressed)


func _on_discard_pressed():
    var sound = Random.choose_value(spit)
    pool.play(sound)

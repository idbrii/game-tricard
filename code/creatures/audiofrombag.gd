extends Node
class_name AudioFromBag

@export var sound_bag: Array[AudioStream]

var pool: AudioPooler


func _ready():
    pool = AudioPooler.new()
    add_child(pool)


func play_sound():
    var sound = Random.choose_value(sound_bag)
    pool.play(sound)

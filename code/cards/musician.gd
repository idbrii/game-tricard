extends Node
# This class is an autoload. Access it with Musician.blah()


func _ready():
    # Create music in autoload so it never stops playing.
    var music := load("res://scenes/music_player.tscn") as PackedScene
    var m = music.instantiate()
    add_child(m)

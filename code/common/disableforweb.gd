extends Node

func _ready():
    if OS.has_feature("web"):
        queue_free()

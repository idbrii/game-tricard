extends Node

var unique_cards : Array[CardDef]
@export var card_template : PackedScene

@export var hand : Node


func _ready():
    unique_cards = load_card_defs("res://scenes/carddeck/deckdef/")
    generate_deck()


func load_card_defs(path: String) -> Array[CardDef]:
    var file_paths: Array[CardDef] = []
    var dir = DirAccess.open(path)
    dir.list_dir_begin()
    var file_name = dir.get_next()
    while file_name != "":
        var file_path = path + "/" + file_name
        file_paths.append(ResourceLoader.load(file_path) as CardDef)
        file_name = dir.get_next()
    return file_paths


func generate_deck():
    var count = unique_cards.size()
    for i in range(10):
        var idx = randi() % count
        add_card(unique_cards[idx])


func add_card(card_def):
    var card = card_template.instantiate()
    # Can't do much setup until card hits _ready, so just set the def.
    card.def = card_def
    hand.add_child(card)

extends Node

var unique_cards: Array[CardDef]
@export var card_template: PackedScene

@export var hand: Node

@onready var draw := $"%HUD/DrawPile"
@onready var discard := $"%HUD/DiscardPile"

var deck_size := 16
var hand_size := 5


func _ready():
    unique_cards = load_card_defs("res://scenes/carddeck/deckdef/")
    generate_deck(deck_size)
    # Wait so cards are in the scene tree and ready.
    await get_tree().process_frame
    draw_cards(hand_size)


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


func generate_deck(num_cards):
    var count = unique_cards.size()
    for i in range(num_cards):
        var idx = randi() % count
        add_card(unique_cards[idx])


func add_card(card_def):
    var card = card_template.instantiate()
    # Can't do much setup until card hits _ready, so just set the def.
    card.def = card_def
    draw.add_child(card)


func draw_cards(num_cards):
    for i in range(num_cards):
        var c = draw.get_child(0)
        if not c:
            # TODO: Shuffle discard
            break
        draw.remove_child(c)
        hand.add_child(c)
        c.set_is_face_up(true)


func discard_all():
    for c in hand.get_children():
        c.set_is_face_up(false)
        hand.remove_child(c)
        discard.add_child(c)

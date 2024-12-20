extends Node


var unique_cards: Array[CardDef]
@export var card_template: PackedScene

@export var hand: Node

@onready var draw := $"%HUD/DrawPile"
@onready var discard := $"%HUD/DiscardPile"

var deck_size := 11
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
            await shuffle_discard()
            await get_tree().create_timer(0.2).timeout
            c = draw.get_child(0)
            if not c:
                break

        draw.remove_child(c)
        hand.add_child(c)
        # Add to left side of hand.
        hand.move_child(c, 0)
        c.set_is_face_up(true)


func shuffle_discard():
    var children = discard.get_children()
    children.shuffle()
    for c in children:
        await animate_card_to_pile(c, draw, 5)


func discard_all():
    for c in hand.get_children():
        await discard_card_anim(c, 2)


func discard_card_anim(c: Card, anim_frames: int = 10):
    await animate_card_to_pile(c, discard, anim_frames)


func animate_card_to_pile(c: Card, pile: Node, anim_frames: int):
    hand.pause_layout = true

    var start = c.global_position
    var dest = pile.global_position
    for i in range(anim_frames):
        var pos = lerp(start, dest, float(i) / anim_frames)
        c.global_position = pos
        await get_tree().process_frame

    hand.pause_layout = false
    move_to_pile(c, pile)


func move_to_pile(c: Card, pile: Node):
    var p = c.get_parent()
    p.remove_child(c)
    pile.add_child(c)

    c.set_is_face_up(false)

extends Resource
class_name CardDef

@export var card_name := ""

@export var art := CompressedTexture2D

## Does the card attack all enemies?
@export var is_barrage := false

@export var actions : Array[PackedScene]

## Three values that are the power values on each chamber.
@export var chamber_values : Array[int]

# Resources don't display properly without this boilerplate init function.
func _init(
        p_card_name = "",
        p_art = null,
        p_is_barrage = false,
        p_actions : Array[PackedScene] = [],
        p_chamber_values : Array[int] = []):

    card_name = p_card_name
    art = p_art
    is_barrage = p_is_barrage
    actions = p_actions
    chamber_values = p_chamber_values

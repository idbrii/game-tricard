extends Resource
class_name CardDef

@export var card_name := ""

## Does the card attack all enemies?
@export var is_barrage := false

@export var actions : Array[PackedScene]

## Three values that are the power values on each chamber.
@export var chamber_values : Array[int]



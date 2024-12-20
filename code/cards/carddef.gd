extends Resource
class_name CardDef


var Barrage = preload("res://code/cards/action/barrage.gd")


@export var card_name := ""

@export var art := Texture2D

## Does the card attack all enemies?
@export var is_barrage := false

@export var actions: Array[Script]
@export var upgrade_actions: Array[Script]

## Three values that are the power values on each chamber.
@export var chamber_values: Array[int]

enum Target {
    SELF,
    OPPONENT,
}

# Resources don't display properly without this boilerplate init function.
func _init(
    p_card_name = "",
    p_art = null,
    p_is_barrage = false,
    p_actions: Array[Script] = [],
    p_chamber_values: Array[int] = []
):
    card_name = p_card_name
    art = p_art
    is_barrage = p_is_barrage
    actions = p_actions
    chamber_values = p_chamber_values


func get_art() -> Texture2D:
    # We can't just return art because for some reason that triggers this error:
    # Parse Error: Cannot return value of type "GDScriptNativeClass" because the function return type is "Texture2D".
    return load(art.resource_path)


## actions_root should probably be a HBoxContainer.
func add_actions(actions_root: Control):
    if is_barrage:
        actions_root.add_child(Barrage.new())

    for action in actions:
        var a = action.new()
        actions_root.add_child(a)


func add_upgrade_action(actions_root: Control):
    if upgrade_actions.is_empty():
        return

    var idx = randi() % upgrade_actions.size()
    var action = upgrade_actions[idx]
    var a = action.new()
    actions_root.add_child(a)


func requires_target(actions_root: Control):
    if is_barrage:
        return false

    for action in actions_root.get_children():
        var t = action.get_target_type()
        if t == Target.OPPONENT:
            return true
    return false

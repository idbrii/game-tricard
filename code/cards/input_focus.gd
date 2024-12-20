extends Node
# This class is an autoload. Access it with InputFocus.set_focus()

signal lose_focus(old_focus, new_focus)
signal gain_focus(old_focus, new_focus)

var current_focus := Node
var lock_input := false


func set_focus(new_focus):
    if current_focus:
        lose_focus.emit(current_focus, new_focus)
    current_focus = new_focus
    if new_focus:
        gain_focus.emit(current_focus, new_focus)


func get_focus():
    return current_focus


func is_focused(item):
    return current_focus == item

extends Node
# This class is an autoload. Access it with InputFocus.set_focus()

signal lose_focus(old_focus, new_focus)
signal gain_focus(old_focus, new_focus)

var current_focus := Node
var lock_input := false


func _input(event: InputEvent):
    if event.is_action_pressed("toggle_full_screen"):
        get_viewport().set_input_as_handled()
        _swap_fullscreen_mode()
    elif event.is_action_pressed("quit_game"):
        get_viewport().set_input_as_handled()
        get_tree().quit()


func _swap_fullscreen_mode():
    if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


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

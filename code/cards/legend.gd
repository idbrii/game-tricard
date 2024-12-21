extends Control


func _ready():
    var actions = load_action_defs("res://code/cards/action/")
    for a in actions:
        var t = a.new()
        var name = t.get_action_name()
        if not name:
            continue
        var label = Label.new()
        label.text = name
        var hbox = HBoxContainer.new()
        hbox.add_child(t)
        hbox.add_child(label)
        $VBox.add_child(hbox)


func load_action_defs(path: String):
    var defs := []
    var dir = DirAccess.open(path)
    dir.list_dir_begin()
    var file_name = dir.get_next()
    while file_name != "":
        var file_path = path + "/" + file_name
        file_path = file_path.replace(".remap", "")
        defs.append(ResourceLoader.load(file_path))
        file_name = dir.get_next()
    return defs

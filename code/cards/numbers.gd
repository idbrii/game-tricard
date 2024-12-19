extends Resource

@export var numbers : Array[Texture2D]

# Resources don't display properly without this boilerplate init function.
func _init(
        p_numbers : Array[Texture2D] = []):
    numbers = p_numbers

func get_number(n : int) -> Texture2D:
    # We can't just return a texture because for some reason that triggers this error:
    # Parse Error: Cannot return value of type "GDScriptNativeClass" because the function return type is "Texture2D".
    return load(numbers[n].resource_path)

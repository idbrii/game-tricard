extends TextureButton
class_name BetterTextureButton


## Use the Textures > Normal image as a mask for the clickable area instead of
## supplying a manually-generated one.
@export var use_texture_normal_for_click_mask := true


func _ready():
    if use_texture_normal_for_click_mask:
        var texture_bitmap = BitMap.new()
        texture_bitmap.create_from_image_alpha(texture_normal.get_image())
        set_click_mask(texture_bitmap)

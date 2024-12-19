extends TextureRect
class_name CardAction


func apply(_target: Node, _power: int):
    pass

func get_target_type() -> CardDef.Target:
    return CardDef.Target.OPPONENT

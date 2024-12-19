extends CardAction


func apply(target: Node, power: int):
    target.status.mod_health(power)

extends CardAction


func apply(target: Node, power: int):
    target.draw_card(power)

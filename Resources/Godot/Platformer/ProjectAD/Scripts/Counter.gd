extends Label

var tickets = 0

func _ready():
	text = str(tickets)


func _on_ticket_collected():
	tickets = tickets + 1
	_ready()

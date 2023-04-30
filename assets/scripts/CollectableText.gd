extends RichTextLabel

var initialCollectibleCount: int
var collected: int = 0
var youWinText: RichTextLabel
var youLoseText: RichTextLabel

func _ready():
	var collectibles = get_tree().get_nodes_in_group("collectibles")
	initialCollectibleCount = collectibles.size()
	text = "Data Objects Found: 0 / " + str(initialCollectibleCount)
	Global.connect("collectible", self, "_on_collectible_signal")
	Global.connect("game_over", self, "_on_game_over")
	youWinText = get_parent().get_node("YouWinText")
	youLoseText = get_parent().get_node("YouLoseText")

func _on_collectible_signal(location):
	collected += 1
	text = "Data Objects Found: " + str(collected) + " / " + str(initialCollectibleCount)
	if collected == initialCollectibleCount:
		Global.playerWon = true
		youWinText.visible = true
		
func _on_game_over():
	youLoseText.visible = true

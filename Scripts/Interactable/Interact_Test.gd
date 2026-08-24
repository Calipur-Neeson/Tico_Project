extends BaseInteractable

@export var item: BaseItem

func Interact(player: Player) -> void:
	player.container.currentItem = item
	queue_free()

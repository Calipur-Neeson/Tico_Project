class_name PlayerContainer
extends Node

var items: Dictionary = {}
var currentItem: BaseItem

func AddItem(item: BaseItem, amount: int = 1) -> void:
	if items.has(item):
		items[item] += amount
	else:
		items[item] = amount


func RemoveItem(item: BaseItem, amount: int = 1) -> void:
	if not items.has(item):
		return

	if items[item] < amount:
		return

	items[item] -= amount

	if items[item] <= 0:
		items.erase(item)


func GetAmount(item: BaseItem) -> int:
	return items.get(item, 0)

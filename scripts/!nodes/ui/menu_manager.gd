class_name MenuManager
extends InterfaceManager


var root_menu: Menu


func change_root_menu(to_menu: Menu = null) -> void:
	if root_menu:
		root_menu.close()
	
	if root_menu == to_menu:
		root_menu == null
	elif to_menu:
		root_menu = to_menu
	elif root_menu.close_destination:
		root_menu = root_menu.close_destination
	else:
		root_menu = null
	
	if root_menu:
		_on_new_root(root_menu)
		root_menu.open()
	else:
		_on_null_root()


func update_menu(menu: Menu) -> void:
	update(menu.filter_children(Interface.ChildFilter.INTERFACE))


func _on_null_root() -> void:
	pass


func _on_new_root(_new_root: Menu) -> void:
	pass

#class_name MenuManager
#extends InterfaceManager
#
#
#signal active_menu_changed(menu: Menu)
#signal root_menu_changed(menu: Menu)
#
#var active_menu: Menu
#var root_menu: Menu
#var open_menus: Array[Menu]
#
#var _max_z_index: int = 0
#
#
#func change_root_menu(to_menu: Menu = null) -> void:
	## Close current root menu.
	#if root_menu:
		#root_menu.close()
	#
	## Select a new root menu.
	#root_menu = (
		#null if root_menu == to_menu else
		#to_menu if to_menu else 
		#root_menu.close_destination
	#)
	#
	## Open the new root menu.
	#if root_menu:
		#_on_new_root(root_menu)
		#root_menu.open()
	#else:
		#_on_null_root()
	#
	#root_menu_changed.emit(root_menu)
#
#
#func set_active(menu: Menu) -> void:
	#open_menus.erase(menu)
	#open_menus.push_front(menu)
	#active_menu = menu
	#
	#_max_z_index += 1
	#active_menu.z_index = _max_z_index
	#
	#active_menu_changed.emit(active_menu)
#
#
#func clear_active(menu: Menu = null) -> void:
	#if menu and menu != active_menu: return
	#open_menus.erase(menu)
	#active_menu = open_menus.front() if open_menus else null
	#
	#_max_z_index -= 1
	#
	#if active_menu:
		#active_menu.z_index = _max_z_index
	#
	#active_menu_changed.emit(active_menu)
#
#
#func update_menu(menu: Menu) -> void:
	#update(menu.filter_children(Interface.ChildFilter.INTERFACE))
#
#
#func _on_null_root() -> void:
	#pass
#
#
#func _on_new_root(_new_root: Menu) -> void:
	#pass

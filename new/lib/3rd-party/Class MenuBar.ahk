class MenuBar
{
	Create(Menu, NamePrefix)
	{
		static MenuName := 0

		Menus := [NamePrefix . MenuName++]
		For each, Item in Menu
		{
			Ref := Item[2]
			If (IsObject(Ref)) && (Ref._NewEnum())
			{
				SubMenus := MenuBar.Create(Ref, NamePrefix)
				Menus.Push(SubMenus*), Ref := ":" SubMenus[1]
			}
			Menu, % Menus[1], Add, % Item[1], %Ref%
		}

		Return Menus
	}

	class Item
	{
		Rename(MenuName, ItemName, NewItemName)
		{
			Try Menu, % MenuName, Rename, % ItemName, % NewItemName
		}

		Toggle(MenuName, PreviousItem, LastClickedItem := "_single")
		{
			static Handler := {"UnCheck": "PreviousItem", "Check": "LastClickedItem"}

			If (LastClickedItem == "_single") ; single item
			{
				If IsObject(PreviousItem)
				{
					For Key, Value in PreviousItem
						Try Menu, % MenuName, ToggleCheck, % Value
				}
				Else
					Try Menu, % MenuName, ToggleCheck, % PreviousItem
				Return
			}

			If (PreviousItem = LastClickedItem) ; safety check
				Return

			For Key, Value in Handler
				Try Menu, % MenuName, % Key, % %Value%
		}

		Disable(MenuName, ItemName)
		{
			If IsObject(ItemName)
			{
				For Key, Value in ItemName
					Try Menu, % MenuName, Disable, % Value
			}
			Else
				Try Menu, % MenuName, Disable, % ItemName
		}
	}

	class Tray
	{
		NoStandard()
		{
			Menu, Tray, NoStandard
		}
	}
}
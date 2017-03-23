Class Menu
{
	Disable(MenuName, MenuObject)
	{
		For Key, Value in MenuObject
		{
			Menu, % MenuName, Disable, % Value
		}
	}

	Toggle(MenuName, MenuObject, ToggleItem)
	{
		For Key, Value in MenuObject
		{
			Menu, % MenuName, Uncheck, % Value
		}
		Menu, % MenuName, ToggleCheck, % ToggleItem
	}

	Add(MenuObject, MenuHandler)
	{
		For k, v in MenuObject
		{
			For Key, Value in MenuObject[k]
				Menu, % k, Add, % Value, % MenuHandler
		}
	}
}
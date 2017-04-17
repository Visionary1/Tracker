Class SetMouseSpeed
{
	__New(speed)
	{
		DllCall("SystemParametersInfo", "UInt", 0x70, "UInt", 0, "UIntP", Ptr, "UInt", 0)
		this.OriginalSpeed := Ptr
		this.Set(speed)
	}

	__Delete()
	{
		this.Set(this.OriginalSpeed)
	}

	Set(speed)
	{
		DllCall("SystemParametersInfo", "UInt", 0x71, "UInt", 0, "UInt", speed, "UInt", 0)
	}
}
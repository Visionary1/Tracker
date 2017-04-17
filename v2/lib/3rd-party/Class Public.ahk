class Public ; base object for all callable objects
{
	__Call(method, args*)
	{
		If IsObject(method) || (method == "")
			Return method ? this.Call(method, args*) : this.Call(args*)
	}
}
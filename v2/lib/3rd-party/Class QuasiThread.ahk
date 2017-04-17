Class QuasiThread
{
	__New(target) {
		this.Target := IsObject(target) ? target : Func(target)
	}

	__Delete() {
		this.Stop()
		this.Delete("Target")
	}

	__Call(method, args*) {
		If IsObject(method)
			Return this.Call(method, args*)
		Else If (method == "")
			Return this.Call(args*)
	}

	Call() {
		this.Target.Call()

		If (this.Period < 0)
			this.Stop()
	}

	Start(period) {
		this.Period := period
		SetTimer, % this, % period
	}

	Stop() {
		SetTimer, % this, Delete
	}
}
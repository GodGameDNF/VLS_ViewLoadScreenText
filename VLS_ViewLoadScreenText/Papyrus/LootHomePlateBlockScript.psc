ScriptName LootHomePlateBlockScript Extends ObjectReference

Actor Property PlayerRef Auto
GlobalVariable Property gLootYes Auto

Event OnTriggerEnter(ObjectReference akActionRef)
	if akActionRef == PlayerRef
		if gLootYes.GetValue() == 1
			gLootYes.SetValue(2)
		Endif
	Endif
EndEvent

Event OnTriggerLeave(ObjectReference akActionRef)
	if akActionRef == PlayerRef
		Utility.Wait(1)
		if gLootYes.GetValue() == 2
			gLootYes.SetValue(1)
		Endif
	Endif
EndEvent
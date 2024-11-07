ScriptName LAJ_LootingFilterContainerScript Extends ObjectReference

ObjectReference Property ReturnMarker Auto
bool Property bGet Auto

Event OnClose(ObjectReference akActionRef)
	if !(LAJ_LootF4SE.FilterContainerSetting(bGet))
		Debug.Messagebox("필터 등록에 실패했습니다. 다시 시도해주세요")
	Endif

	RemoveAllItems(Game.GetPlayer())
	moveto(returnMarker)
EndEvent
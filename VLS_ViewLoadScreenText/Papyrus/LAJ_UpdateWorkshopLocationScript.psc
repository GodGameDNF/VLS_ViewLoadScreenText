ScriptName LAJ_UpdateWorkshopLocationScript Extends Quest

Quest Property MQ102 Auto
Quest Property LAJ_UpdateWorkshopOwnChecker Auto

Spell Property LAJ_ScarpSpell Auto
RefCollectionAlias Property WorkshopArray Auto
FormList Property LAJ_WorkshopList Auto

WorkshopParentScript Property WorkshopParent Auto

Event OnQuestInit()
	Game.GetPlayer().AddSpell(LAJ_ScarpSpell, false)
	RegisterForCustomEvent(WorkshopParent,  "WorkshopPlayerOwnershipChanged")

	if MQ102.GetStage() > 1
		LAJ_UpdateWorkshopOwnChecker.Start()
		Utility.Wait(0.1)

		int i = WorkshopArray.GetCount()
		While i
			i -= 1
			ObjectReference WorkshopRef = WorkshopArray.GetAt(i)
			Location WorkshopLocation = WorkshopRef.GetCurrentLocation()
			if (WorkshopRef as WorkshopScript).OwnedByPlayer && WorkshopLocation.GetName() != ""
				LAJ_WorkshopList.AddForm(WorkshopLocation)
			Endif
		EndWhile
		Utility.Wait(0.1)
		LAJ_UpdateWorkshopOwnChecker.Stop()
	Endif
EndEvent

Event WorkshopParentScript.WorkshopPlayerOwnershipChanged(WorkshopParentScript akSender, Var[] akArgs)
	if (akArgs[0] as bool)
		LAJ_WorkshopList.AddForm((akArgs[1] as ObjectReference).GetCurrentLocation())
	else
		LAJ_WorkshopList.RemoveAddedForm((akArgs[1] as ObjectReference).GetCurrentLocation())
	Endif
EndEvent
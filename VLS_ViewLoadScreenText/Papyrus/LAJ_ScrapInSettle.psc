ScriptName LAJ_ScrapInSettle extends ActiveMagicEffect

Actor Property LAJ_scrapActor Auto

ObjectReference Property LootTempBox Auto
FormList property ComponentList Auto
FormList property ComponentScrapList Auto
Actor Property pPlayer Auto
GlobalVariable Property gInSettle Auto
GlobalVariable Property gLootSettle Auto
GlobalVariable Property gLootYes Auto

GlobalVariable Property gLAJ_SpellResetCounter Auto
Spell Property LAJ_ScarpSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	gInSettle.SetValue(1)
	if gLootSettle.GetValue() == 1
		if gLootYes.GetValue() == 1
			gLootYes.SetValue(2)
		Endif
	Endif

	int PrintScrapCount 
	if LAJ_scrapActor.GetComponentCount() > 0
		int iIndex = 31
		While iIndex
			iIndex -= 1
			Int iScrapCount =  LAJ_scrapActor.GetComponentCount(ComponentList.GetAt(iIndex)) 
			pPlayer.AddItem(ComponentScrapList.GetAt(iIndex), iScrapCount, True)
			PrintScrapCount += iScrapCount
		EndWhile

		LAJ_scrapActor.RemoveAllItems()
		Debug.Notification("총 "+PrintScrapCount+" 개의 스크랩 재료가 전송됨")
	Endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	gInSettle.SetValue(0)
	if gLootYes.GetValue() == 2
		gLootYes.SetValue(1)
	Endif

	int iResetCount = gLAJ_SpellResetCounter.GetValueInt()
	gLAJ_SpellResetCounter.SetValue(iResetCount + 1)
	if iResetCount > 20
		gLAJ_SpellResetCounter.SetValue(0)
		pPlayer.RemoveSpell(LAJ_ScarpSpell)
		Utility.Wait(0.2)
		pPlayer.AddSpell(LAJ_ScarpSpell, false)
	Endif
EndEvent
Scriptname LAJ_MCMManager Extends Quest

Actor Property PlayerRef Auto
Actor Property LAJ_scrapActor Auto

GlobalVariable Property gAllGetCount Auto

GlobalVariable Property gMCMDebug_OpenBox Auto
GlobalVariable Property gMCMDebug_RunScrap Auto

FormList property ComponentList Auto
FormList property ComponentScrapList Auto

bool bDebugBoxOpen
bool bFilterChange
bool bMCMScrap

Function OpenDebugBox()
	if !bDebugBoxOpen
		bDebugBoxOpen = true
		Utility.Wait(0.05)
		if gMCMDebug_OpenBox.GetValue() == 1
			LAJ_scrapActor.OpenInventory(true)
		Endif
		bDebugBoxOpen = false
		gMCMDebug_OpenBox.SetValue(0)
	Endif
EndFunction

Function OpenAllGetCount()
	Debug.Messagebox("이 세이브에서 오토루팅으로 먹은 아이템 : " + gAllGetCount.GetValueInt() + " 개")
EndFunction

Function MCMScrapButton()
	if !bMCMScrap
		bMCMScrap = true
		Utility.Wait(0.03)
		if gMCMDebug_RunScrap.GetValue() == 1
			int PrintScrapCount 
			if LAJ_scrapActor.GetComponentCount() > 0
				int iIndex = 31
				While iIndex
					iIndex -= 1
					Int iScrapCount =  LAJ_scrapActor.GetComponentCount(ComponentList.GetAt(iIndex)) 
					PlayerRef.AddItem(ComponentScrapList.GetAt(iIndex), iScrapCount, True)
					PrintScrapCount += iScrapCount
				EndWhile

				LAJ_scrapActor.RemoveAllItems()
				Debug.Notification("총 "+PrintScrapCount+" 개의 스크랩 재료가 전송됨")
			Endif
		Endif
		gMCMDebug_RunScrap.SetValue(0)
		bMCMScrap = false
	Endif
EndFunction

Function miscFilterSetting()
	if !bFilterChange
		bFilterChange = true
		Utility.Wait(0.05)
		LAJ_LootF4SE.setMiscFilter()
		bFilterChange = false
	Endif
EndFunction
ScriptName LAJ_LootingFilterScript Extends ObjectReference

Actor Property PlayerRef Auto
Message Property LootingFilterMessage Auto
Message Property LootingFilterDescriptionMessage Auto
ObjectReference Property LootingFilterGetRef Auto
ObjectReference Property LootingFilterSkipRef Auto

GlobalVariable Property gFilterDescription Auto

Event OnActivate(ObjectReference akActionRef)
	BlockActivation(True, True)

	bool isRepeat = True
	While isRepeat
		int Sel = LootingFilterMessage.Show()
		if Sel == 0
			isRepeat = False
			LootingFilterGetRef.Moveto(Self, 0, 0, -5000)

			if !(LAJ_LootF4SE.FillContainerfromFile(true))
				debug.messagebox("오류가 발생했습니다. 다시 시도해주세요")
				BlockActivation(False)
				return
			Endif

			LootingFilterGetRef.Activate(PlayerRef)
		elseif Sel == 1
			isRepeat = False
			LootingFilterSkipRef.Moveto(Self, 0, 0, -5000)

			if !(LAJ_LootF4SE.FillContainerfromFile(false))
				debug.messagebox("오류가 발생했습니다. 다시 시도해주세요")
				BlockActivation(False)
				return
			Endif

			LootingFilterSkipRef.Activate(PlayerRef)
		elseif Sel == 2
			int dSel = LootingFilterDescriptionMessage.Show()
			if dSel == 0
				gFilterDescription.SetValue(1)
			Endif
		else
			isRepeat = False
		Endif
	EndWhile

	BlockActivation(False)
EndEvent
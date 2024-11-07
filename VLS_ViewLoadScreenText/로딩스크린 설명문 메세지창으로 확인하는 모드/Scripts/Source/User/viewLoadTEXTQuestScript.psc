ScriptName viewLoadTEXTQuestScript Extends Quest

Message Property loadTextMessage Auto
GlobalVariable Property textIndex Auto
GlobalVariable Property indexEND Auto
GlobalVariable Property vanillaIndex Auto

Event OnQuestInit()
	InputEnableLayer myLayer = InputEnableLayer.Create()
	myLayer.DisablePlayerControls(true, true, true, true, false, true, true, true, true, true, true)

	bool refeat = true
	while refeat
		int i = textIndex.GetValueInt()
		VLS_ViewLoadScreenText.setLoadText(i)

		int c = loadTextMessage.Show()
		if c == 0
			textIndex.mod(-1)
		elseif c == 1
			textIndex.mod(1)
		elseif c == 2
			if i >= 10
				textIndex.Setvalue(i - 20)
			else
				textIndex.Setvalue(0)
			endif
		elseif c == 3
			if i <= indexEND.GetValueInt() - 20
				textIndex.Setvalue(i + 20)
			else
				textIndex.Setvalue(indexEND.GetValueInt())
			endif
		elseif c == 4
			textIndex.Setvalue(vanillaIndex.GetValueInt())
		else
			refeat = false
		Endif
	endwhile

	myLayer.Reset()
	myLayer.Delete()

	stop()
EndEvent
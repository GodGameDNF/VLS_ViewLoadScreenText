Scriptname LAJ_5_0_5433patchQuestScript extends Quest

Quest Property QuestLootJunkRun Auto
Quest Property NoUse_RegisterLootQuest Auto
Spell Property LAJ_ScarpSpell Auto

Event OnQuestInit()
	if QuestLootJunkRun.IsRunning()
		QuestLootJunkRun.Stop()
		NoUse_RegisterLootQuest.Stop()
		Actor PlayerRef = Game.GetPlayer()
		PlayerRef.RemoveSpell(LAJ_ScarpSpell)
		Utility.Wait(0.1)
		PlayerRef.AddSpell(LAJ_ScarpSpell, false)
	Endif
	Stop()
EndEvent
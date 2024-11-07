#include <chrono>
#include <ctime>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <sys/stat.h>
#include <vector>
#include <windows.h>

using namespace RE;

PlayerCharacter* p = nullptr;
BSScript::IVirtualMachine* vm = nullptr;
TESDataHandler* DH = nullptr;

BGSMessage* viewMessage = nullptr;
TESGlobal* textIndex = nullptr;
TESGlobal* indexEND = nullptr;
TESGlobal* vanillaIndex = nullptr;
int vanillaIndexSave;

TESObjectACTI* nameActi = nullptr;

std::vector<TESFile*> vanillaFileList;

struct DataEntry
{
	TESFile* LoadFile;         // ESP 파일 ID 또는 이름
	std::string loadText;    // 데이터 내용
};

std::vector<DataEntry> loadDatas;

void setLoadText(std::monostate, int i)
{
	i = i < loadDatas.size() ? i : loadDatas.size() - 1;

	std::string_view fileName = loadDatas[i].LoadFile->GetFilename();
	std::string viewText = loadDatas[i].loadText;

	std::string indexString = "(" + std::to_string(i) + "/" + std::to_string(static_cast<int>(indexEND->value)) + ")";

	nameActi->fullName = std::string(fileName) + "\n" + indexString + "\n\n" + viewText;
}

void loadScreenSorting()
{
	BSTArray<TESFile*> fileArray = DH->compiledFileCollection.files;
	BSTArray<TESFile*> smallFileArray = DH->compiledFileCollection.smallFiles;

	std::vector<DataEntry> nonLightLoadDatas;
	std::vector<DataEntry> lightLoadDatas;

	auto& tempLoadForms = DH->GetFormArray<RE::TESLoadScreen>();

	// Iterate through the array and process each LoadScreen Form
	for (RE::TESLoadScreen* loadScreen : tempLoadForms) {
		if (loadScreen) {
			BGSLocalizedString tempText = loadScreen->loadingText;

			if (!tempText.empty()) {
				TESFile* file = loadScreen->GetFile();
				if (file) {
					if (file->IsLight()) {
						lightLoadDatas.push_back(DataEntry{ file, tempText.c_str() });
					} else {
						nonLightLoadDatas.push_back(DataEntry{ file, tempText.c_str() });
					}
				}
			}
		}
	}

	bool isVanillaEnd = false;
	for (TESFile* checkFile : fileArray) {
		for (const DataEntry& entry : nonLightLoadDatas) {
			if (entry.LoadFile == checkFile) {
				loadDatas.push_back(entry);
				if (!isVanillaEnd) {
					bool isVanillaESP = false;
					for (size_t i = 0 ; i < vanillaFileList.size(); ++i) {
						if (vanillaFileList[i] == checkFile) {
							isVanillaESP = true;
							break;
						}
					}

					if (!isVanillaESP) {
						vanillaIndexSave = loadDatas.size();
						isVanillaEnd = true;
					}
				}
			}
		}
	}

	if (!isVanillaEnd) {
		vanillaIndexSave = loadDatas.size();
	}

	for (TESFile* checkFile : smallFileArray) {
		for (const DataEntry& entry : lightLoadDatas) {
			if (entry.LoadFile == checkFile) {
				loadDatas.push_back(entry);
			}
		}
	}
}

void saveVanillaFiles() {
	TESForm* fallout4 = (TESForm*)DH->LookupForm(0x13AD1, "Fallout4.esm");
	TESForm* DLCRobot = (TESForm*)DH->LookupForm(0xBCA, "DLCRobot.esm");
	TESForm* DLCworkshop01 = (TESForm*)DH->LookupForm(0x83F, "DLCworkshop01.esm");
	TESForm* DLCCoast = (TESForm*)DH->LookupForm(0x4F2B, "DLCCoast.esm");
	TESForm* DLCworkshop02 = (TESForm*)DH->LookupForm(0x893, "DLCworkshop02.esm");
	TESForm* DLCworkshop03 = (TESForm*)DH->LookupForm(0x119D, "DLCworkshop03.esm");
	TESForm* DLCNukaWorld = (TESForm*)DH->LookupForm(0x7D75, "DLCNukaWorld.esm");
	TESForm* London = (TESForm*)DH->LookupForm(0x00E701, "LondonWorldSpace.esm");

	if (fallout4)
		vanillaFileList.push_back(fallout4->sourceFiles.array[0][0]);
	if (DLCRobot)
		vanillaFileList.push_back(DLCRobot->sourceFiles.array[0][0]);
	if (DLCworkshop01)
		vanillaFileList.push_back(DLCworkshop01->sourceFiles.array[0][0]);
	if (DLCCoast)
		vanillaFileList.push_back(DLCCoast->sourceFiles.array[0][0]);
	if (DLCworkshop02)
		vanillaFileList.push_back(DLCworkshop02->sourceFiles.array[0][0]);
	if (DLCworkshop03)
		vanillaFileList.push_back(DLCworkshop03->sourceFiles.array[0][0]);
	if (DLCNukaWorld)
		vanillaFileList.push_back(DLCNukaWorld->sourceFiles.array[0][0]);
	if (London)
		vanillaFileList.push_back(London->sourceFiles.array[0][0]);

}

void OnF4SEMessage(F4SE::MessagingInterface::Message* msg)
{
	switch (msg->type) {
	case F4SE::MessagingInterface::kGameDataReady:
		{
			p = PlayerCharacter::GetSingleton();
			DH = TESDataHandler::GetSingleton();

			textIndex = (TESGlobal*)DH->LookupForm(0x2, "VLS_ViewLoadScreenText.esp");
			indexEND = (TESGlobal*)DH->LookupForm(0x4, "VLS_ViewLoadScreenText.esp");
			vanillaIndex = (TESGlobal*)DH->LookupForm(0x9, "VLS_ViewLoadScreenText.esp");
			viewMessage = (BGSMessage*)DH->LookupForm(0x1, "VLS_ViewLoadScreenText.esp");
			nameActi = (TESObjectACTI*)DH->LookupForm(0x6, "VLS_ViewLoadScreenText.esp");

			saveVanillaFiles();
			loadScreenSorting();

			break;
		}
	case F4SE::MessagingInterface::kPostLoadGame:
		{
			indexEND->value = loadDatas.size() - 1;
			vanillaIndex->value = vanillaIndexSave;

			break;
		}
	}
}

bool RegisterPapyrusFunctions(RE::BSScript::IVirtualMachine* a_vm)
{
	vm = a_vm;

	a_vm->BindNativeMethod("VLS_ViewLoadScreenText"sv, "setLoadText"sv, setLoadText);

	return true;
}

extern "C" DLLEXPORT bool F4SEAPI F4SEPlugin_Query(const F4SE::QueryInterface* a_f4se, F4SE::PluginInfo* a_info)
{
#ifndef NDEBUG
	auto sink = std::make_shared<spdlog::sinks::msvc_sink_mt>();
#else
	auto path = logger::log_directory();
	if (!path) {
		return false;
	}

	*path /= fmt::format("{}.log", Version::PROJECT);
	auto sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(path->string(), true);
#endif

	auto log = std::make_shared<spdlog::logger>("Global Log"s, std::move(sink));

#ifndef NDEBUG
	log->set_level(spdlog::level::trace);
#else
	log->set_level(spdlog::level::info);
	log->flush_on(spdlog::level::trace);
#endif

	spdlog::set_default_logger(std::move(log));
	spdlog::set_pattern("[%^%l%$] %v"s);

	logger::info("{} v{}", Version::PROJECT, Version::NAME);

	a_info->infoVersion = F4SE::PluginInfo::kVersion;
	a_info->name = Version::PROJECT.data();
	a_info->version = Version::MAJOR;

	if (a_f4se->IsEditor()) {
		logger::critical("loaded in editor");
		return false;
	}

	const auto ver = a_f4se->RuntimeVersion();
	if (ver < F4SE::RUNTIME_1_10_162) {
		logger::critical("unsupported runtime v{}", ver.string());
		return false;
	}

	return true;
}

extern "C" DLLEXPORT bool F4SEAPI F4SEPlugin_Load(const F4SE::LoadInterface* a_f4se)
{
	F4SE::Init(a_f4se);

	const F4SE::PapyrusInterface* papyrus = F4SE::GetPapyrusInterface();
	if (papyrus)
		papyrus->Register(RegisterPapyrusFunctions);

	const F4SE::MessagingInterface* message = F4SE::GetMessagingInterface();
	if (message)
		message->RegisterListener(OnF4SEMessage);

	return true;
}

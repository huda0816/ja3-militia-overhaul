# Overritten core files

## Functions

AddToSectorInventory - ItemContainer

UnitInventory:GetEquipedArmour - Mercenary
UnitInventory:GetHandheldItems - Mercenary

CreateMessageBox - ZuluMessageQuestionBox

ReceiveEmail - Emails

OpenTutorialPopupSatelliteMap - TutorialPopup

GetPDABrowserDialog - PDA
HyperlinkVisited - PDA

SquadWindow:Open - XSatelliteObjects - full
SquadWindow:SpawnSquadIcon - XSatelliteObjects - full
GetSatelliteIconImages - XSatelliteObjects
SectorWindow:GetSectorCenter - XSatelliteObjects
GetSatelliteIconImagesSquad - XSatelliteObjects

GetSatelliteSquadsForContextMenu - XSatelliteMap - full
XSatelliteViewMap:OpenContextMenu - XSatelliteMap - full
XSatelliteViewMap:RemoveContextMenu - XSatelliteMap
XSatelliteViewMap:SelectSquad - XSatelliteMap
XSatelliteViewMap:OpenContextMenu - XSatelliteMap
XSatelliteViewMap:ExitTravelMode - XSatelliteMap

RemoveUnitFromSquad - SatelliteSquad - full
CreateNewSatelliteSquad - SatelliteSquad - patch
IsPlayer1Squad -SatelliteSquad - full
GetSectorTravelTime - SatelliteSquad
GetSectorDistance - SatelliteSquad

GetMercCurrentDailySalary - Money - patch
GetMoneyProjection - Money -patch
AddMoney - Money

GetSquadManagementMilitiaSquads - MilitiaMagement - full

OpenSquadCreation - SquadManagement - patch

SquadCantMove - SatelliteTravel - patch
SatelliteCanTravelState - SatelliteTravel - patch

GetSquadsInSector - Utility - patch
GetPlayerMercsInSector - Utility - full
IsMerc - Utility - patch
GetSquadsOnMapUI - Utility
GetSquadsOnMap - Utility
GetGroupedSquads - Utility
GetSectorName - Utility
RemoveSquadsFromLists - Utility
GetMilitiaSquads - Utility
GetTimeAsTable - Utility

GiveCombatTask - CombatTasks - patch

GetSectorOperationResource - SatelliteSectorOperations - full

UnitProperties:GetPersonalMorale - ClassDef-Zulu.generated.lua - patch

IModeExploration:InitiateUnitMovement - IModeExploration - patch

UIEnterSectorInternal - SatelliteCabinet - patch
SatelliteToggleActionState - SatelliteCabinet

IsAutoResolveEnabled - SatelliteConflict - patch
SatelliteRetreat - SatelliteConflict - full
ResolveConflict - SatelliteConflict - full
CanGoInMap - SatelliteConflict

RollForMilitiaPromotion - SatelliteConflict - full

SpawnMilitia - SatelliteView - full
GetCitySectors - SatelliteView

Unit:DropLoot - Unit - patch

## TFormats

TFormat.GetDailyMoneyChange

## XTemplates

PDAMercRollover
Inventory
SquadsAndMercs
SatelliteViewMapContextMenu
TeamMembers
PDASatellite
PDAFinances
PDAMoneyRollover
SatelliteConflict
PDASquadManagement
PDABrowser
PDAQuests_Email

## MSGHooks

SatelliteNewSquadSelected
ClosePDA
OpenPDA
ConflictStart
ConflictEnd
StatusEffectAdded
ReachSectorCentor
OnAttack
UnitDiedOnSector
NewHour
NewDay
ReloadLua
ZuluGameLoaded
Autorun
UnitJoinedPlayerSquad
DialogClose
SquadStartedTravelling
SquadSectorChanged
SquadFinishedTraveling
MercHired
SquadSpawned
PreSquadDespawned
QuestParamChanged
ConflictStart
EnterSector
SectorSideChanged



# Overritten core files

## Functions

AddToSectorInventory - ItemContainer

UnitInventory:GetEquipedArmour - Mercenary
UnitInventory:GetHandheldItems - Mercenary
HasPerk - Mercenary

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
PointOfInterestRolloverClass:GetPOITextForRollover - XSatelliteObjects

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
SetSatelliteSquadSide - SatelliteSquad
SplitSquad - SatelliteSquad
DiscoverIntelForSector - SatelliteSquad

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
RecalcOperationETAs - SatelliteSectorOperations
XDragContextWindow - SatelliteSctorOperations - parent

UnitBase:GetPersonalMorale - Unit.lua - patch

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
CityModifyLoyalty - SatelliteView
CreateMilitiaUnitData - SatelliteView
GetLeastExpMilitia - SatelliteView

Unit:DropLoot - Unit - patch
RollSkillCheck - Unit
Unit:ExitCombat

GetSquadBag - SquadBag

GetGuardpostRollover - Guardpost

GetAmmosWithCaliber - Inventory
PlaceInventoryItem - Inventory
GetDropContainer - Inventory

SetCombatActionState - CombatActions

Targeting_UnitInMelee - IModeCombatMelee
IModeCommonUnitControl:UpdateCursorImage - IModeCombatMelee

IsMeleeRangeTarget - CombatAi

GetCombatPath - Combat

Unit:RecalcUIActions - UnitCaching

AddTimelineEvent - SatelliteTimeline


## TFormats

TFormat.GetDailyMoneyChange - Money

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
SectorOperationMainUI
SectorOperationsUI

## MSGHooks

SatelliteNewSquadSelected
ClosePDA
OpenPDA
ConflictStart
ConflictEnd
StatusEffectAdded
ReachSectorCenter
OnAttack
UnitDiedOnSector
NewHour
NewDay
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
OperationCompleted



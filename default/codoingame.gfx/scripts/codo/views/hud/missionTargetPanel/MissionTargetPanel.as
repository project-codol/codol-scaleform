package codo.views.hud.missionTargetPanel
{
   import codo.constants.HUDComponentTypes;
   import codo.localization.Dict;
   import codo.localization.DictZHunt;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.HUDComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MissionTargetPanel extends HUDComponent
   {
      
      private static const DEFAULT_TEXT_COLOR:uint = 15003350;
      
      public static const MISSION_VIEW_OBSTACLE:int = 0;
      
      public static const MISSION_VIEW_PROTECT:int = 1;
      
      public static const MISSION_VIEW_DOM:int = 2;
      
      public static const MISSION_VIEW_SEARCH:int = 3;
      
      public static const MISSION_OBSTACLE_SUBTYPE_CRYSTAL:int = 0;
      
      public static const MISSION_OBSTACLE_SUBTYPE_DOOR:int = 1;
      
      public static const MISSION_OBSTACLE_SUBTYPE_EVACUATION:int = 2;
      
      public static const MISSION_OBSTACLE_SUBTYPE_JAMMING:int = 3;
      
      public static const MISSION_OBSTACLE_SUBTYPE_AIR_DROP:int = 4;
      
      public static const MISSION_PROTECT_SUBTYPE_CHARGE_GENERATOR:int = 0;
      
      public static const MISSION_PROTECT_SUBTYPE_SCAN_DNA:int = 1;
      
      public static const MISSION_PROTECT_SUBTYPE_SIGNAL_TOWER:int = 2;
      
      public static const MISSION_PROTECT_SUBTYPE_ENERGY_TRANSFER:int = 3;
      
      public static const MISSION_PROTECT_SUBTYPE_TANK_REPAIRING:int = 4;
      
      public static const MISSION_PROTECT_SUBTYPE_CONVOY_TANK:int = 5;
      
      public static const MISSION_PROTECT_SUBTYPE_HACK_SERVER:int = 6;
      
      public static const MISSION_PROTECT_SUBTYPE_C4_DETONATE:int = 7;
      
      public static const MISSION_DOM_SUBTYPE_UPLOAD_SIGNAL:int = 0;
      
      public static const MISSION_DOM_SUBTYPE_SCAN_EXIT:int = 1;
      
      public static const MISSION_DOM_SUBTYPE_SCAN_DNA:int = 2;
      
      public static const MISSION_DOM_SUBTYPE_CRACKING:int = 3;
      
      public static const MISSION_DOM_SUBTYPE_SENSE:int = 4;
      
      private static const PROGRESS_DIGIT:String = "00";
      
      private static const PROGRESS_PERCENT:String = "10%";
      
      private static const PROGRESS_FRACTION:String = "0/1";
      
      private static const PROGRESS_NONE:String = "";
      
      private static const EVACUATION_PROGRESSLABEL_X:Number = -73;
      
      private static var MISSION_LABELS:Array = [[[{
         "label":DictZHunt.OBSTACLE_CLEAN_PROGRESS,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.DESTROY_DOOR_LOCK,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.WAITING_FOR_RESCUE,
         "progress":PROGRESS_DIGIT
      }],[{
         "label":DictZHunt.JAMMING,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.AIR_DROP,
         "progress":PROGRESS_PERCENT
      }]],[[{
         "label":DictZHunt.GENERATOR_CHARGE_PROGRESS,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.SCAN_DNA_SAMPLE,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.TOWER_REBOOTING,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.ENERGY_TRANSFERRING,
         "progress":PROGRESS_PERCENT
      },{
         "label":DictZHunt.WAIT_FOR_ACTIVATE,
         "progress":PROGRESS_NONE
      }],[{
         "label":DictZHunt.REPAIRING,
         "progress":PROGRESS_NONE
      }],[{
         "label":DictZHunt.PROTECT_TANK,
         "progress":PROGRESS_NONE
      }],[{
         "label":DictZHunt.HACKING_SERVER,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.C4_DETONATE,
         "progress":PROGRESS_PERCENT
      }]],[[{
         "label":DictZHunt.WAITING_FOR_CONNECTION,
         "progress":PROGRESS_NONE
      },{
         "label":DictZHunt.DATA_UPLOADING,
         "progress":PROGRESS_PERCENT
      },{
         "label":DictZHunt.SIGNAL_WEAK,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.SCAN_EXIT_PENDING,
         "progress":PROGRESS_NONE
      },{
         "label":DictZHunt.SCAN_EXIT,
         "progress":PROGRESS_PERCENT
      },{
         "label":DictZHunt.SCAN_EXIT_INTERRUPTED,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.SCAN_DNA_PENDING,
         "progress":PROGRESS_NONE
      },{
         "label":DictZHunt.SCAN_DNA_SAMPLE,
         "progress":PROGRESS_PERCENT
      },{
         "label":DictZHunt.SCAN_DNA_INTERRUPTED,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.WAIT_FOR_CRACK,
         "progress":PROGRESS_NONE
      },{
         "label":DictZHunt.CRACKING,
         "progress":PROGRESS_PERCENT
      },{
         "label":DictZHunt.CRACK_INTERRUPT,
         "progress":PROGRESS_PERCENT
      }],[{
         "label":DictZHunt.WAIT_FOR_SENSE,
         "progress":PROGRESS_NONE
      },{
         "label":DictZHunt.SENSING,
         "progress":PROGRESS_PERCENT
      },{
         "label":DictZHunt.SENSE_INTERRUPT,
         "progress":PROGRESS_PERCENT
      }]],[[{
         "label":DictZHunt.COLLECT_PROGRESS,
         "progress":PROGRESS_FRACTION
      }]]];
      
      public var myProgressLabel:TextField;
      
      public var myProgressLabelExtra:TextField;
      
      public var myProgress:TextField;
      
      public var myProtectIcon:ProtectIcon;
      
      public var myObstacleIcon:MovieClip;
      
      public var myDOMIcon:MovieClip;
      
      public var mySearchIcon:MovieClip;
      
      public function MissionTargetPanel()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.MISSIONTARGET_PANEL;
      }
      
      public function toggleView(viewType:int, missionSubtype:int) : void
      {
         var frameIndex:int = 0;
         this.myProtectIcon.visible = false;
         this.myObstacleIcon.visible = false;
         this.myDOMIcon.visible = false;
         this.mySearchIcon.visible = false;
         this.myProgressLabel.textColor = DEFAULT_TEXT_COLOR;
         this.myProgress.textColor = DEFAULT_TEXT_COLOR;
         this.myProgressLabel.visible = true;
         this.myProgressLabelExtra.visible = false;
         this.myProgress.visible = true;
         this.myProgress.text = "";
         if(viewType == MISSION_VIEW_OBSTACLE)
         {
            switch(missionSubtype)
            {
               case MISSION_OBSTACLE_SUBTYPE_EVACUATION:
                  this.myProgressLabelExtra.text = LocalizeUtil.localize(Dict.SECOND);
                  this.myProgressLabelExtra.visible = true;
                  this.myProgressLabel.x = EVACUATION_PROGRESSLABEL_X;
                  break;
               case MISSION_OBSTACLE_SUBTYPE_DOOR:
               case MISSION_OBSTACLE_SUBTYPE_CRYSTAL:
               case MISSION_OBSTACLE_SUBTYPE_JAMMING:
               case MISSION_OBSTACLE_SUBTYPE_AIR_DROP:
            }
            frameIndex = missionSubtype + 1;
            this.myObstacleIcon.gotoAndStop(frameIndex);
            this.myObstacleIcon.visible = true;
         }
         else if(viewType == MISSION_VIEW_PROTECT)
         {
            this.myProtectIcon.setupIcons(missionSubtype);
         }
         else if(viewType == MISSION_VIEW_DOM)
         {
            this.myDOMIcon["mySignal"].visible = false;
            this.myDOMIcon["myScanline"].visible = false;
            this.myDOMIcon["myDNA"].visible = false;
            switch(missionSubtype)
            {
               case MISSION_DOM_SUBTYPE_CRACKING:
               case MISSION_DOM_SUBTYPE_SCAN_EXIT:
                  this.myDOMIcon["myScanline"].visible = true;
                  break;
               case MISSION_DOM_SUBTYPE_SCAN_DNA:
                  this.myDOMIcon["myDNA"].visible = true;
                  break;
               case MISSION_DOM_SUBTYPE_UPLOAD_SIGNAL:
               case MISSION_DOM_SUBTYPE_SENSE:
               default:
                  this.myDOMIcon["mySignal"].visible = true;
            }
            this.myDOMIcon.visible = true;
         }
         else if(viewType == MISSION_VIEW_SEARCH)
         {
            this.mySearchIcon.visible = true;
         }
         this.setMissionLabel(viewType,missionSubtype);
      }
      
      public function setMissionLabel(missionType:int, missionSubtype:int = 0, missionState:int = 0) : void
      {
         var labels:Array = MISSION_LABELS[missionType][missionSubtype];
         if(labels.length > missionState)
         {
            this.setLabelText(labels[missionState].label,labels[missionState].progress);
         }
         else
         {
            this.setLabelText("",PROGRESS_NONE);
         }
      }
      
      public function setLabelText(label:String, progressPlaceholder:String) : void
      {
         this.myProgressLabel.text = label;
         var progressText:String = this.myProgress.text;
         this.myProgress.text = progressPlaceholder;
         var totalWidth:Number = this.myProgressLabel.textWidth + this.myProgress.textWidth + (this.myProgressLabelExtra.visible ? this.myProgressLabelExtra.textWidth : 0);
         this.myProgress.text = progressText;
         this.myProgressLabel.x = -totalWidth * 0.5;
         this.myProgress.x = this.myProgressLabel.x + this.myProgressLabel.textWidth;
         this.myProgressLabelExtra.x = this.myProgress.x + this.myProgress.textWidth;
         this.myProgress.visible = progressPlaceholder != PROGRESS_NONE;
      }
      
      public function updateLabelExtra() : void
      {
         this.myProgressLabelExtra.x = this.myProgress.x + this.myProgress.textWidth;
      }
   }
}


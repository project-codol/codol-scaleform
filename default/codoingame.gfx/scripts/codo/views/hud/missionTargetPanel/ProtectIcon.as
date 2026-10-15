package codo.views.hud.missionTargetPanel
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class ProtectIcon extends MovieClip
   {
      
      private static const ICON_GENERATOR:int = 0;
      
      private static const ICON_DNA:int = 1;
      
      private static const ICON_ELECTRIC_TOWER:int = 2;
      
      private static const ICON_UMBRELLA:int = 3;
      
      private static const ICON_CONSOLE:int = 4;
      
      private static const ICON_TANK_REPAIR:int = 5;
      
      private static const ICON_TANK:int = 6;
      
      private static const ICON_C4:int = 7;
      
      private static const ICON_SERVER:int = 8;
      
      private static const ICON_ACTIVATED_FRAME:int = 1;
      
      private static const ICON_UNACTIVATED_FRAME:int = 2;
      
      private static const ICON_ONE_TARGET_FRAME:int = 1;
      
      private static const ICON_TWO_TARGETS_RIGHT_ARROW_FRAME:int = 2;
      
      private static const ICON_TWO_TARGETS_DUAL_ARROWS_FRAME:int = 3;
      
      private var myBridge:MovieClip;
      
      private var mIconNames:Array = ["myGeneratorIcon","myDNAIcon","myElectricTowerIcon","myUmbrellaIcon","myConsoleIcon","myTankRepairIcon","myTankIcon","myC4","myServerIcon"];
      
      private var mTargetIcons:Array = [];
      
      private var mTargets:Vector.<GeneratorHealthProgressBar>;
      
      public function ProtectIcon()
      {
         super();
         this.mTargets = new Vector.<GeneratorHealthProgressBar>();
      }
      
      public function setupIcons(missionSubtype:int) : void
      {
         var target:GeneratorHealthProgressBar = null;
         var fillBarStyle:int = GeneratorHealthProgressBar.FILL_BAR_STYLE_NORMAL;
         var targetFrame:int = ICON_ONE_TARGET_FRAME;
         this.mTargetIcons.length = 0;
         this.mTargets.length = 0;
         switch(missionSubtype)
         {
            case MissionTargetPanel.MISSION_PROTECT_SUBTYPE_C4_DETONATE:
               this.mTargetIcons.push(this.mIconNames[ICON_C4]);
               break;
            case MissionTargetPanel.MISSION_PROTECT_SUBTYPE_CONVOY_TANK:
               this.mTargetIcons.push(this.mIconNames[ICON_TANK]);
               break;
            case MissionTargetPanel.MISSION_PROTECT_SUBTYPE_TANK_REPAIRING:
               this.mTargetIcons.push(this.mIconNames[ICON_TANK_REPAIR]);
               fillBarStyle = GeneratorHealthProgressBar.FILL_BAR_STYLE_SECTION;
               break;
            case MissionTargetPanel.MISSION_PROTECT_SUBTYPE_SIGNAL_TOWER:
               this.mTargetIcons.push(this.mIconNames[ICON_ELECTRIC_TOWER]);
               break;
            case MissionTargetPanel.MISSION_PROTECT_SUBTYPE_SCAN_DNA:
               this.mTargetIcons.push(this.mIconNames[ICON_DNA]);
               break;
            case MissionTargetPanel.MISSION_PROTECT_SUBTYPE_ENERGY_TRANSFER:
               this.mTargetIcons.push(this.mIconNames[ICON_CONSOLE]);
               this.mTargetIcons.push(this.mIconNames[ICON_UMBRELLA]);
               targetFrame = ICON_TWO_TARGETS_RIGHT_ARROW_FRAME;
               break;
            case MissionTargetPanel.MISSION_PROTECT_SUBTYPE_HACK_SERVER:
               this.mTargetIcons.push(this.mIconNames[ICON_SERVER]);
               this.mTargetIcons.push(this.mIconNames[ICON_SERVER]);
               targetFrame = ICON_TWO_TARGETS_DUAL_ARROWS_FRAME;
               break;
            case MissionTargetPanel.MISSION_PROTECT_SUBTYPE_CHARGE_GENERATOR:
            default:
               this.mTargetIcons.push(this.mIconNames[ICON_GENERATOR]);
         }
         gotoAndStop(targetFrame);
         for(var i:int = 0; i < this.mTargetIcons.length; i++)
         {
            target = getChildByName("myTarget".concat(i)) as GeneratorHealthProgressBar;
            if(target == null)
            {
               break;
            }
            this.resetIcon(target);
            target.setFillBarStyle(fillBarStyle);
            target.getChildByName(this.mTargetIcons[i]).visible = true;
            this.mTargets.push(target);
         }
         this.myBridge = getChildByName("myBridge") as MovieClip;
      }
      
      public function SetProgress(progress:Array, animated:Boolean) : void
      {
         var i:int = 0;
         while(i < this.mTargets.length && i < progress.length)
         {
            this.mTargets[i].SetProgress(progress[i],animated);
            i++;
         }
      }
      
      public function SetState(state:int) : Boolean
      {
         var i:int = 0;
         var activated:Boolean = false;
         visible = false;
         var allActivated:Boolean = true;
         for(i = 0; i < this.mTargets.length; i++)
         {
            activated = (state & 1) != 0;
            if(activated)
            {
               visible = true;
               this.mTargets[i].gotoAndStop(ICON_ACTIVATED_FRAME);
            }
            else
            {
               allActivated = false;
               this.mTargets[i].gotoAndPlay(ICON_UNACTIVATED_FRAME);
            }
            this.mTargets[i].myFill.visible = activated;
            state >>= 1;
         }
         if(this.myBridge != null)
         {
            if(allActivated)
            {
               this.myBridge.gotoAndPlay(2);
            }
            else
            {
               this.myBridge.gotoAndStop(1);
            }
         }
         return visible;
      }
      
      private function resetIcon(icon:MovieClip) : void
      {
         var name:String = null;
         var childIcon:DisplayObject = null;
         for each(name in this.mIconNames)
         {
            childIcon = icon.getChildByName(name);
            if(childIcon == null)
            {
               throw new Error("HUD ProtectICon: Can\'t find icon " + name);
            }
            childIcon.visible = false;
         }
      }
   }
}


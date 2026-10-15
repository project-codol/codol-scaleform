package codo.views.hudSpy
{
   import codo.constants.SpyRoundType;
   import codo.localization.DictHud;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class OverallStatePanel extends MovieClip
   {
      
      public var myLostLabel:TextField;
      
      public var myInvestigatorCount:TextField;
      
      public var mySpyCount:TextField;
      
      public var myCivilianCount:TextField;
      
      public var myAliveLabel:TextField;
      
      public var myCivilianIcon:MovieClip;
      
      public var mySpyIcon:MovieClip;
      
      public var myPoliceIcon:MovieClip;
      
      public function OverallStatePanel()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.myLostLabel.text = LocalizeUtil.localize(DictHud.SPY_BODY_MISSING);
         this.myAliveLabel.text = LocalizeUtil.localize(DictHud.SPY_PLAYER_ALIVE);
         this.myCivilianIcon.gotoAndStop(3);
         this.mySpyIcon.gotoAndStop(2);
      }
      
      public function setRoundType(roundType:int) : void
      {
         if(roundType == SpyRoundType.ROUND_NORMAL)
         {
            this.myCivilianIcon.gotoAndStop(3);
            this.myCivilianCount.visible = this.mySpyIcon.visible = this.myPoliceIcon.visible = this.mySpyCount.visible = this.myInvestigatorCount.visible = true;
         }
         else
         {
            this.myCivilianCount.visible = this.mySpyIcon.visible = this.myPoliceIcon.visible = this.mySpyCount.visible = this.myInvestigatorCount.visible = false;
            this.myCivilianIcon.gotoAndStop(3 + roundType);
         }
      }
   }
}


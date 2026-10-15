package codo.component.playercard
{
   import codo.base.BaseSubElement;
   import codo.component.PlayerCard;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.event.ParaEvent;
   import codo.objects.PlayerObj;
   import codo.style.GlobalGuide;
   import codo.utils.TLogUtil;
   import flash.display.Sprite;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgUtil;
   
   public class PlayerCardShared extends BaseSubElement
   {
      
      public var myPlayerCard:PlayerCard;
      
      public var myCardHitarea:Sprite;
      
      private var mCallback:Function;
      
      private var mClickable:BehaviourClickable;
      
      private var mAudio:BehaviourAudio;
      
      private var mFocusCallback:Function;
      
      private var mUnfocusCallback:Function;
      
      public function PlayerCardShared()
      {
         super();
         this.mClickable = new BehaviourClickable(this.myCardHitarea);
         this.mClickable.addMouseOverCallback(this.onMouseOver);
         this.mClickable.addMouseOutCallback(this.onMouseOut);
         this.mClickable.addClickCallback(this.onMouseClick);
         this.mClickable.setEnabled(false);
         this.mAudio = new BehaviourAudio(this.mClickable);
         this.mAudio.overrideMouseOverAudio("ui_callingcard_mouseover_01");
         this.mAudio.setEnabled(false);
         alpha = GlobalGuide.UNFOCUS_ALPHA;
      }
      
      override public function set enable(isEnabled:Boolean) : void
      {
         super.enable = isEnabled;
         if(this.mClickable != null)
         {
            this.mClickable.setEnabled(isEnabled);
            this.mAudio.setEnabled(isEnabled);
         }
         this.myPlayerCard.myDisabledIcon.visible = !isEnabled;
      }
      
      override public function active() : void
      {
         super.active();
         listen(BCEvent.EVT_ON_CAREER_INFO_UPDATED,this.onCareerInfoUpdate);
         listen(BCEvent.EVT_CALLSIGN_REFRESH,this.onCareerInfoUpdate);
         listen(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodStateChanged);
         this.data = PlayerObj.getObj();
         alpha = 1;
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unlisten(BCEvent.EVT_ON_CAREER_INFO_UPDATED,this.onCareerInfoUpdate);
         unlisten(BCEvent.EVT_CALLSIGN_REFRESH,this.onCareerInfoUpdate);
         unlisten(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodStateChanged);
      }
      
      public function registerFocusCallback(callback:Function) : void
      {
         this.mFocusCallback = callback;
      }
      
      public function registerUnfocusCallback(callback:Function) : void
      {
         this.mUnfocusCallback = callback;
      }
      
      private function onWarGodStateChanged(cEvt:ParaEvent) : void
      {
         this.data = PlayerObj.getObj();
      }
      
      private function onCareerInfoUpdate(cResult:Object) : void
      {
         this.data = PlayerObj.getObj();
      }
      
      private function set data(cDat:PlayerObj) : void
      {
         var prestigeLevel:String = null;
         if(cDat != null)
         {
            if(cDat.name != null)
            {
               this.myPlayerCard.setName(cDat.name);
            }
            else
            {
               this.myPlayerCard.setName("");
            }
            if(cDat.clanName != null)
            {
               this.myPlayerCard.setClanName(cDat.clanName);
            }
            else
            {
               this.myPlayerCard.setClanName("");
            }
            if(cDat.careerData != null)
            {
               this.myPlayerCard.setRank(cDat.careerData.currentLevel);
               prestigeLevel = cDat.careerData.prestige == 0 ? "" : cDat.careerData.prestige.toString();
               this.myPlayerCard.setPrestige(prestigeLevel);
               this.myPlayerCard.setPrestigeIcon(FsgUtil.getPrestigeIcon(cDat.careerData.prestige));
            }
            else
            {
               this.myPlayerCard.setRank("");
               this.myPlayerCard.setPrestige("");
            }
            if(cDat.callSignObj != null)
            {
               if(cDat.callSignObj.cardTitle != null)
               {
                  this.myPlayerCard.setTitle(cDat.callSignObj.cardTitle);
               }
               this.myPlayerCard.setBackground(cDat.callSignObj.cardBackgroundURL);
               this.myPlayerCard.setEmblem(cDat.callSignObj.cardIconURL);
               this.myPlayerCard.setNameplate(cDat.callSignObj.cardNameplateColor);
               this.myPlayerCard.setFrame(cDat.callSignObj.cardFrameURL);
            }
         }
      }
      
      public function set clickCallback(callback:Function) : void
      {
         this.mCallback = callback;
      }
      
      protected function onMouseOver() : void
      {
         GlobalGuide.TOGGLE_ITEM_FOCUS(this,true,false,1.02);
         this.myPlayerCard["myBackgroundOutline"].gotoAndStop(2);
         if(null != this.mFocusCallback)
         {
            this.mFocusCallback();
         }
      }
      
      protected function onMouseOut() : void
      {
         GlobalGuide.TOGGLE_ITEM_FOCUS(this,false);
         this.myPlayerCard["myBackgroundOutline"].gotoAndStop(1);
         if(null != this.mUnfocusCallback)
         {
            this.mUnfocusCallback();
         }
      }
      
      protected function onMouseClick() : void
      {
         if(!enable)
         {
            return;
         }
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_PLAYERCARD_CARD_SELECT);
         if(this.mCallback != null)
         {
            this.mCallback();
         }
      }
   }
}


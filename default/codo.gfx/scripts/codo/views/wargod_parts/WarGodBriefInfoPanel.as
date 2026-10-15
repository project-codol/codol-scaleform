package codo.views.wargod_parts
{
   import codo.base.BaseSubElement;
   import codo.component.TextField;
   import codo.component.social.ClanCommonTip;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictWarGod;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.style.WarGodGuide;
   import flash.display.MovieClip;
   
   public class WarGodBriefInfoPanel extends BaseSubElement
   {
      
      private static const BG_FRAME:int = 3;
      
      private static const FRAME_HEIGHT_DEFAULT:Number = 366;
      
      private static const FRAME_HEIGHT_SAFE:Number = 407;
      
      public var mySeasonNameCard:WarGodNameCard;
      
      public var myHeroicValuePanel:MovieClip;
      
      private var mGlobalSetting:WarGodGlobalSettingObj;
      
      private var mSeasonObj:WarGodSeasonObj;
      
      private var mPlayerWarGod:WarGodPlayerObj;
      
      public function WarGodBriefInfoPanel()
      {
         super();
         this.myHeroicValuePanel.myBg.gotoAndStop(BG_FRAME);
         this.myHeroicValuePanel.myBg.width = 457;
         this.myHeroicValuePanel.myBg.height = FRAME_HEIGHT_DEFAULT;
         this.myHeroicValuePanel.mySafeLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myHeroicValuePanel.mySafeLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeroicValuePanel.mySafeLabel.width = 437;
         this.myHeroicValuePanel.mySafeLabel.text = DictWarGod.WARGOD_SAFE_FROM_DEMOTION;
         this.myHeroicValuePanel.mySafeLabel.visible = false;
         this.myHeroicValuePanel.mySafeBG.visible = false;
         this.myHeroicValuePanel.myHeroicLabel.textStyle = WarGodGuide.styleSeasonName;
         this.myHeroicValuePanel.myHeroicLabel.x = 1;
         this.myHeroicValuePanel.myHeroicLabel.y = 300;
         this.myHeroicValuePanel.myHeroicLabel.width = 437;
         this.myHeroicValuePanel.myHeroicLabel.height = 64;
         this.myHeroicValuePanel.myHeroicLabel.text = DictWarGod.WARGOD_HEROIC_VALUE;
         this.myHeroicValuePanel.myInfoTip.setType(ClanCommonTip.TYPE_MULTIPLE_LINE);
         this.myHeroicValuePanel.myInfoTip.setFixedWidth(300);
         this.myHeroicValuePanel.myInfoTip.hideTip();
      }
      
      override public function active() : void
      {
         super.active();
         this.mGlobalSetting = getDP(DataID.WARGOD_GLOBAL_SETTING);
         this.mSeasonObj = getDP(DataID.CURRENT_WARGOD_INFO);
         this.mPlayerWarGod = getDP(DataID.PLAYER_WARGOD_DATA);
         listen(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodStateChanged);
         listen(BCEvent.EVT_WARGOD_PLAYER_OBJ_CHANGED,this.onWarGodStateChanged);
         this.update();
         this.myHeroicValuePanel.myInfoTip.bindMovieClip(this.myHeroicValuePanel.myInfoButton,this.heroicValueToolTipTextSetter);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unlisten(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodStateChanged);
         unlisten(BCEvent.EVT_WARGOD_PLAYER_OBJ_CHANGED,this.onWarGodStateChanged);
         this.myHeroicValuePanel.myInfoTip.unbindMovieClip(this.myHeroicValuePanel.myInfoButton);
         this.myHeroicValuePanel.myInfoTip.hideTip();
      }
      
      private function heroicValueToolTipTextSetter(tf:TextField) : void
      {
         tf.myTextClip.text = DictWarGod.HEROIC_VALUE_TIP;
      }
      
      private function onWarGodStateChanged(cEvt:ParaEvent) : void
      {
         if(Boolean(this.mPlayerWarGod))
         {
            this.mGlobalSetting = getDP(DataID.WARGOD_GLOBAL_SETTING);
            this.mSeasonObj = getDP(DataID.CURRENT_WARGOD_INFO);
            this.mPlayerWarGod = getDP(DataID.PLAYER_WARGOD_DATA);
            this.update();
         }
      }
      
      private function update() : void
      {
         this.showSeasonInfo();
      }
      
      private function showSeasonInfo() : void
      {
         var state:int = 0;
         var isOpening:Boolean = false;
         var warGodRank:PlayerWarGodRank = null;
         var hvExChangeRate:int = 0;
         var hvProtectionRate:int = 0;
         this.myHeroicValuePanel.visible = false;
         this.mySeasonNameCard.setData(this.mPlayerWarGod);
         if(!this.mSeasonObj)
         {
            this.switchSeasonOpen(false);
         }
         else
         {
            state = getDP(DataID.WARGOD_OPENING_STATE);
            isOpening = state == WarGodSeasonObj.STATE_OPEN || state == WarGodSeasonObj.STATE_PAUSE;
            this.switchSeasonOpen(isOpening);
            if(isOpening)
            {
               if(this.mPlayerWarGod.phase == WarGodPlayerObj.PHASE_PLACEMENT)
               {
                  this.myHeroicValuePanel.myHeroicValueMeter.enabled = false;
               }
               else
               {
                  warGodRank = this.mPlayerWarGod.warGodRank;
                  hvExChangeRate = int(this.mGlobalSetting.hvExchangeRate[warGodRank.tier]);
                  hvProtectionRate = int(this.mGlobalSetting.hvProtectionRate[warGodRank.tier]);
                  this.myHeroicValuePanel.myHeroicValueMeter.setData(this.mPlayerWarGod.heroicValue,hvExChangeRate,hvProtectionRate);
                  this.myHeroicValuePanel.mySafeLabel.visible = this.myHeroicValuePanel.mySafeBG.visible = this.mPlayerWarGod.heroicValue >= hvProtectionRate && this.mPlayerWarGod.phase == WarGodPlayerObj.PHASE_STAR;
               }
            }
         }
         this.myHeroicValuePanel.myBg.height = Boolean(this.myHeroicValuePanel.mySafeLabel.visible) ? FRAME_HEIGHT_SAFE : FRAME_HEIGHT_DEFAULT;
      }
      
      private function switchSeasonOpen(isOpen:Boolean) : void
      {
         this.myHeroicValuePanel.myHeroicValueMeter.enabled = isOpen;
      }
   }
}


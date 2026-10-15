package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.component.PlayerCard;
   import codo.constants.BCInGameEvent;
   import codo.constants.GameInfo;
   import codo.utils.ShoutcastUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudPlayerCard extends BaseView
   {
      
      private static const CORE_VIEW:int = 0;
      
      private static const SPLASH_VIEW:int = 1;
      
      public var myLeftContainer:MovieClip;
      
      public var myCenterAnchor:MovieClip;
      
      public var myRightContainer:MovieClip;
      
      public function HudPlayerCard()
      {
         super();
         if(this.myLeftContainer.myPlayerCard.myTitle != null)
         {
            this.myLeftContainer.myPlayerCard.myTitle.text = "";
         }
         if(this.myLeftContainer.myPlayerCard.myDisabledIcon != null)
         {
            this.myLeftContainer.myPlayerCard.myDisabledIcon.visible = false;
         }
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      override protected function showView() : void
      {
         var stageSize:Object = null;
         var stagePosition:Object = null;
         super.showView();
         visible = true;
         stageSize = GameInfo.stageSize;
         stagePosition = GameInfo.stagePosition;
         this.myLeftContainer.x = stagePosition.x;
         this.myLeftContainer.y = stagePosition.y;
         this.myRightContainer.x = stagePosition.x + (stageSize.x - GameInfo.DEFAULT_WIDTH);
         this.myRightContainer.y = stagePosition.y + (stageSize.y - GameInfo.DEFAULT_HEIGHT);
         var temptf:TextField = this.myLeftContainer.myPlayerCard.myClanName as TextField;
         temptf.text = "";
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_PlayerCard,this);
         ShoutcastUtil.getInstance().registerView(this);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
      }
      
      public function refreshSpectator(isSpectating:Boolean, y:Number) : void
      {
         if(isSpectating)
         {
            this.broadcast(BCInGameEvent.EVT_PLAYERCARD_OPENED,y);
         }
         else
         {
            this.broadcast(BCInGameEvent.EVT_PLAYERCARD_ClOSED);
         }
      }
      
      public function refreshVisuals(index:Number, emblemIcon:String, prestigeIcon:String, background:String, frame:String) : void
      {
         trace("HudPlayerCard::refreshVisuals( " + index + ":Number, " + emblemIcon + ":String, " + prestigeIcon + ":String, " + background + ":String, " + frame + ":String )");
         if(Boolean(emblemIcon))
         {
            if(index == CORE_VIEW)
            {
               (this.myLeftContainer.myPlayerCard as PlayerCard).setEmblem(emblemIcon);
            }
            else
            {
               (this.myRightContainer.mySplashCardHolder.myTweenHack.mySplashPlayerCard as PlayerCard).setEmblem(emblemIcon);
            }
         }
         if(Boolean(prestigeIcon))
         {
            if(index == CORE_VIEW)
            {
               this.myLeftContainer.myPlayerCard.myPrestigeIcon.setImage(prestigeIcon);
            }
            else
            {
               this.myRightContainer.mySplashCardHolder.myTweenHack.mySplashPlayerCard.myPrestigeIcon.setImage(prestigeIcon);
            }
         }
         if(Boolean(background))
         {
            if(index == CORE_VIEW)
            {
               (this.myLeftContainer.myPlayerCard as PlayerCard).setBackground(background);
            }
            else
            {
               (this.myRightContainer.mySplashCardHolder.myTweenHack.mySplashPlayerCard as PlayerCard).setBackground(background);
            }
         }
         if(Boolean(frame))
         {
            if(index == CORE_VIEW)
            {
               (this.myLeftContainer.myPlayerCard as PlayerCard).setFrame(frame);
            }
            else
            {
               (this.myRightContainer.mySplashCardHolder.myTweenHack.mySplashPlayerCard as PlayerCard).setFrame(frame);
            }
         }
      }
   }
}


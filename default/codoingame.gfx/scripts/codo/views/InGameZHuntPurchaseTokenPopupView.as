package codo.views
{
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.event.ParaEvent;
   import codo.localization.DictZHunt;
   import codo.utils.InGameTokenUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.TextUtil;
   import codo.views.hud.HUDPopupComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class InGameZHuntPurchaseTokenPopupView extends HUDPopupComponent
   {
      
      private static const TEXT_BG_PADDING:int = 20;
      
      private static const TOKEN_COUNT_ANCHOR:int = 557;
      
      public var myCaption:TextField;
      
      public var myTokensLabel:TextField;
      
      public var myTokens:TextField;
      
      public var myUsage:TextField;
      
      public var myAvailableTokens:TextField;
      
      public var myTimeleft:TextField;
      
      public var myHintLabel:TextField;
      
      public var myGameEndLabel:TextField;
      
      public var myHintBG:MovieClip;
      
      public var myReviveHint:TextField;
      
      private var mPurchased:Boolean = false;
      
      public function InGameZHuntPurchaseTokenPopupView()
      {
         super();
         mShowMask = false;
         mBlurView = false;
         listen(BCEvent.EVT_TOKEN_UPDATE_DISPLAY,this.updateTokenDisplay);
         this.myTokensLabel.text = LocalizeUtil.localize(DictZHunt.REMAINING_TOKEN_COUNT);
         this.myUsage.text = LocalizeUtil.localize(DictZHunt.USE_TOKEN_KEEP_LOADOUT);
         this.myHintLabel.text = LocalizeUtil.localize(DictZHunt.USE_TOKEN_TO_RESTART_MATCH);
         this.myHintBG.width = this.myHintLabel.textWidth + TEXT_BG_PADDING;
         this.myHintBG.x = 640 - this.myHintBG.width / 2;
         this.myGameEndLabel.text = LocalizeUtil.localize(DictZHunt.MATCH_FAILED);
         this.toggleGameEndTimer(false);
         this.myReviveHint.visible = false;
      }
      
      override protected function showView() : void
      {
         super.showView();
         var remainingTokens:uint = InGameTokenUtil.GetTokenOwned();
         this.setRemainingTokenCount(remainingTokens);
         if(!this.mPurchased)
         {
            if(remainingTokens == 0)
            {
               if(InGameTokenUtil.CanBuyToken())
               {
                  this.myCaption.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(DictZHunt.BUY_TOKENS_MESSAGING);
               }
               else
               {
                  this.myCaption.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(DictZHunt.TOKEN_USE_UP);
               }
            }
            else
            {
               this.myCaption.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(DictZHunt.SPEND_TOKENS_MESSAGING);
            }
         }
         this.mPurchased = false;
         this.setAvailableTokenCount(InGameTokenUtil.GetTokensCanUse(),InGameTokenUtil.GetTokenUseLimit());
      }
      
      private function updateTokenDisplay(evt:ParaEvent) : void
      {
         var success:Boolean = Boolean(evt.myPara.success);
         trace(success);
         if(success)
         {
            this.myCaption.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(DictZHunt.BUY_TOKENS_SUCCESS_SPEND_MESSAGING);
         }
         else
         {
            this.myCaption.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(DictZHunt.BUY_TOKENS_ERROR_MESSAGING);
         }
         this.mPurchased = true;
      }
      
      private function setRemainingTokenCount(count:uint) : void
      {
         this.myTokens.text = "x" + count.toString();
         var format:TextFormat = this.myTokens.getTextFormat(0,1);
         format.size = 50;
         this.myTokens.setTextFormat(format,0,1);
         TextUtil.resizeTextToFitWidth(this.myTokens);
         this.myTokens.y = TOKEN_COUNT_ANCHOR + (this.myTokens.height - this.myTokens.textHeight);
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.ZHUNT_PURCHASE_TOKEN;
      }
      
      private function setAvailableTokenCount(count:uint, limit:uint) : void
      {
         if(count == 0)
         {
            this.myCaption.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(DictZHunt.TOKEN_USE_UP);
         }
         var limitText:String = count.toString() + "/" + limit.toString();
         this.myAvailableTokens.text = LocalizeUtil.param(LocalizeUtil.localize(DictZHunt.AVAILABLE_TOKEN_COUNT),[limitText]);
      }
      
      public function toggleGameEndTimer(gameEnd:Boolean) : void
      {
         this.myTimeleft.visible = this.myGameEndLabel.visible = this.myHintBG.visible = this.myHintLabel.visible = gameEnd;
      }
      
      public function paramFontFormat(format:TextFormat) : void
      {
         format.bold = true;
         format.font = GameInfo.GAME_FONT_AENCY_FB;
      }
      
      public function setTimeleft(sec:int) : void
      {
         LocalizeUtil.paramCustomizeFormat(this.myTimeleft,DictZHunt.MATCH_END_TIMELEFT,[sec],this.paramFontFormat);
      }
   }
}


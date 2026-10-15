package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.CyborgTokenItemState;
   import codo.interfaces.ICyborgTokenItem;
   import codo.localization.DictInGame;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class CyborgTokenView extends BaseView
   {
      
      private static const POS_ORIGIN_X:Number = 165;
      
      private static const POS_ORIGIN_Y:Number = 560;
      
      public var myTokenTitleTF:TextField;
      
      public var myTokenSubTitleTF:TextField;
      
      public var myToken2:ICyborgTokenItem;
      
      public var myToken1:ICyborgTokenItem;
      
      public var myToken0:ICyborgTokenItem;
      
      public var myTotalTokens:MovieClip;
      
      public var myBg:Sprite;
      
      public var myTitleTF_fsg:TextField;
      
      public var mySubTitleTF_fsg:TextField;
      
      private var _currentFocusToken:ICyborgTokenItem;
      
      private var _tokens:Vector.<ICyborgTokenItem>;
      
      public function CyborgTokenView()
      {
         super();
         this._tokens = new <ICyborgTokenItem>[this.myToken0,this.myToken1,this.myToken2];
      }
      
      override protected function onInit() : void
      {
         this.myTotalTokens.myTokenCounter.myTextTF.autoSize = "left";
         if(this.myTokenTitleTF != null)
         {
            this.myTokenTitleTF.text = DictInGame.CYBORGS_REVIVE_TOKEN_TITLE;
            this.myTokenSubTitleTF.text = DictInGame.CYBORGS_REVIVE_TOKEN_SUBTITLE;
         }
         else
         {
            this.myTitleTF_fsg.text = DictInGame.CYBORGS_REVIVE_TOKEN_TITLE_FSG;
         }
         if(ScaleformUtil.isFsgCyborgTokenEnabled())
         {
            this.x = 0;
            this.y = -40;
         }
         else
         {
            this.x = POS_ORIGIN_X;
            this.y = POS_ORIGIN_Y;
         }
      }
      
      override protected function showView() : void
      {
         super.showView();
         var tokenAmount:uint = CFunctionCommonContainer.GetCyborgTokenCount();
         this.myTotalTokens.myTokenCounter.myTextTF.text = "X" + String(tokenAmount > 999 ? 999 : tokenAmount);
         this.myTotalTokens.x = this.myBg.x + this.myBg.width - this.myTotalTokens.width - 7;
      }
      
      override protected function enableData() : void
      {
         var token:ICyborgTokenItem = null;
         var tokenInfo:String = CFunctionCommonContainer.Dvar_GetString("ui_tok_info");
         var tokenFields:Array = tokenInfo.split(",");
         var numSpent:int = int(tokenFields[0]);
         var numOwned:int = int(tokenFields[1]);
         Logger.print("CyborgTokenView::enableData spent=" + numSpent + " owned=" + numOwned);
         var focusOnFirstToken:Boolean = true;
         this._currentFocusToken = null;
         if(this.mySubTitleTF_fsg != null)
         {
            this.mySubTitleTF_fsg.text = LocalizeUtil.replace(LocalizeUtil.localize(DictInGame.CYBORGS_REVIVE_TOKEN_SUBTITLE_FSG),[String(this._tokens.length - numSpent),String(this._tokens.length)]);
         }
         for(var i:int = 0; i < this._tokens.length; i++)
         {
            token = this._tokens[i];
            if(i < numSpent)
            {
               token.setTokenState(CyborgTokenItemState.STATE_SPENT);
            }
            else if(numOwned > 0 && i < numSpent + numOwned)
            {
               token.setTokenState(CyborgTokenItemState.STATE_OWNED,focusOnFirstToken);
               if(focusOnFirstToken == true)
               {
                  this._currentFocusToken = token;
                  focusOnFirstToken = false;
               }
            }
            else
            {
               token.setTokenState(CyborgTokenItemState.STATE_EMPTY,focusOnFirstToken);
               if(focusOnFirstToken == true)
               {
                  this._currentFocusToken = token;
                  focusOnFirstToken = false;
               }
            }
         }
         if(this._currentFocusToken != null)
         {
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
            this.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
         }
         else
         {
            this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
            this.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
         }
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         for(var i:uint = 0; i < this._tokens.length; i++)
         {
            this._tokens[i].stopProgress();
         }
      }
      
      private function onKeyDownHandle(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode == Keyboard.F)
         {
            if(this._currentFocusToken != null)
            {
               this._currentFocusToken.startProgress();
            }
         }
      }
      
      private function onKeyUpHandle(cEvt:KeyboardEvent) : void
      {
         if(this._currentFocusToken != null)
         {
            this._currentFocusToken.stopProgress();
         }
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandle);
         this.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
      }
   }
}


package fsg.component
{
   import codo.constants.CyborgTokenItemState;
   import codo.interfaces.ICyborgTokenItem;
   import codo.localization.DictInGame;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import shaui.component.core.UIComponent;
   
   public class FsgCyborgTokenItem extends UIComponent implements ICyborgTokenItem
   {
      
      public var myActionText:MovieClip;
      
      public function FsgCyborgTokenItem()
      {
         super();
      }
      
      public function startProgress() : void
      {
      }
      
      public function stopProgress() : void
      {
      }
      
      public function setTokenState(state:int, hasFocus:Boolean = false) : void
      {
         if(hasFocus)
         {
            this.myActionText.visible = true;
            if(state == CyborgTokenItemState.STATE_OWNED)
            {
               this.myActionText.myTextTF.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(DictInGame.CYBORGS_TOKEN_USE);
            }
            else if(state == CyborgTokenItemState.STATE_EMPTY)
            {
               this.myActionText.myTextTF.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(DictInGame.CYBORGS_TOKEN_BUY);
            }
         }
         else
         {
            this.myActionText.visible = false;
         }
         if(state == CyborgTokenItemState.STATE_EMPTY)
         {
            this.gotoAndStop(3);
         }
         else if(state == CyborgTokenItemState.STATE_SPENT)
         {
            this.gotoAndStop(4);
         }
         else if(state == CyborgTokenItemState.STATE_OWNED)
         {
            if(hasFocus)
            {
               this.gotoAndStop(1);
            }
            else
            {
               this.gotoAndStop(2);
            }
         }
      }
   }
}


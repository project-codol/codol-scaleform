package codo.views.hudDMZ
{
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class HintPanel extends MovieClip
   {
      
      public var myMap:KeyHint;
      
      public var myMark:KeyHint;
      
      public var myQuickChat:KeyHint;
      
      public var myInventory:KeyHint;
      
      public function HintPanel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myMap.setHintText(LocalizeUtil.localizeFirstKeyBindingForCommand("+markerslot 1"),LocalizeUtil.localize(DictDmz.SEE_MAP));
         this.myMark.setHintText(LocalizeUtil.localizeFirstKeyBindingForCommand("+talk"),LocalizeUtil.localize(DictDmz.MARK_PLACE));
         this.myQuickChat.setHintText(LocalizeUtil.localizeFirstKeyBindingForCommand("+targetMap"),LocalizeUtil.localize(DictDmz.VOICE_WHEEL));
         this.myInventory.setHintText(LocalizeUtil.localizeFirstKeyBindingForCommand("toggleloadoutmenu"),LocalizeUtil.localize(DictDmz.LOADOUT));
         var hintArray:Array = new Array(this.myMap,this.myMark,this.myQuickChat,this.myInventory);
         var maxKeyText:Number = 0;
         var hint:KeyHint = null;
         for each(hint in hintArray)
         {
            if(hint.myKey.textWidth > maxKeyText)
            {
               maxKeyText = hint.myKey.textWidth;
            }
         }
         for each(hint in hintArray)
         {
            hint.expandKeyHint(maxKeyText);
         }
      }
   }
}


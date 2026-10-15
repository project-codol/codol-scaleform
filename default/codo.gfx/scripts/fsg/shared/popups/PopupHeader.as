package fsg.shared.popups
{
   import codo.localization.DictUIStencils;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class PopupHeader extends Sprite
   {
      
      private static const LOCALIZE:Function = LocalizeUtil.localize;
      
      public var myPopupIntroTF:TextField;
      
      public var myPopupTitleTF:TextField;
      
      public var myPopupSubTitleTF:TextField;
      
      public function PopupHeader()
      {
         super();
         this.myPopupIntroTF.text = LOCALIZE(DictUIStencils.SHARED_INTRODUCTION_TITLE).toUpperCase();
      }
      
      public function set introText(txt:String) : void
      {
         this.myPopupIntroTF.text = LOCALIZE(txt).toUpperCase();
      }
      
      public function set title(txt:String) : void
      {
         this.myPopupTitleTF.text = LOCALIZE(txt).toUpperCase();
      }
      
      public function set subtitle(txt:String) : void
      {
         this.myPopupSubTitleTF.text = LOCALIZE(txt).toUpperCase();
      }
   }
}


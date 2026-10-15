package codo.component.matchselect
{
   import codo.component.TokenButton;
   import codo.localization.Dict;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   
   public class AsymPurchaseButton extends TokenButton
   {
      
      public static const BUTTON_ICONS:Vector.<String> = new <String>["scaleform_ash/miscicons/hover_default_corner_icon","scaleform_ash/miscicons/jugger_default_corner_icon","scaleform_ash/miscicons/spider_default_corner_icon"];
      
      public function AsymPurchaseButton()
      {
         super();
         label = LocalizeUtil.localize(Dict.ASYM_PURCHASE_POPUP_TITLE).toLocaleUpperCase();
         width = 205;
         myLabel.alignment = TextStyle.HALIGN_CENTER;
      }
      
      override public function draw() : void
      {
         super.draw();
         myLabel.x = 0;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
   }
}


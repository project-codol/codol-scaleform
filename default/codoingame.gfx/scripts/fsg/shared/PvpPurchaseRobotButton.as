package fsg.shared
{
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import flash.text.TextFieldAutoSize;
   
   public class PvpPurchaseRobotButton extends PvpPveBasePurchaseButton
   {
      
      public static const BUTTON_ICONS:Vector.<String> = new <String>["scaleform_ash/miscicons/hover_default_corner_icon","scaleform_ash/miscicons/jugger_default_corner_icon","scaleform_ash/miscicons/spider_default_corner_icon"];
      
      public function PvpPurchaseRobotButton()
      {
         super();
         myTextTF.text = LocalizeUtil.localize(Dict.ASYM_PURCHASE_POPUP_TITLE).toLocaleUpperCase();
         myTextTF.autoSize = TextFieldAutoSize.NONE;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         myTextTF.textColor = 14990138;
      }
   }
}


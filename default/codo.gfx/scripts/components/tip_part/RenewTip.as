package components.tip_part
{
   import codo.base.BaseView;
   import codo.localization.Dict;
   import flash.text.TextField;
   
   public class RenewTip extends BaseView
   {
      
      public var myTitleTF:TextField;
      
      public var myTextTF:TextField;
      
      public function RenewTip()
      {
         super();
         this.onInit();
         this.onStyleChangeForMatchType();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.myTitleTF.text = Dict.CHARACTER_EXPIRED;
         this.myTextTF.text = Dict.CHARACTER_RENEW_PROMPT;
      }
   }
}


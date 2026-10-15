package codo.component.social
{
   import codo.style.ClanGuide;
   
   public class SocialDropDownBtn2 extends SocialDropDownBtn
   {
      
      public static const ITEM_WIDTH:int = 118;
      
      public static const ITEM_HEIGHT:int = 28;
      
      public function SocialDropDownBtn2()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         isInteractiveEnabled = true;
         width = ITEM_WIDTH;
         height = ITEM_HEIGHT;
         myText.textStyle = ClanGuide.styleDropDownText2;
         myBg.gotoAndStop(NORMAL_FRAME);
      }
   }
}


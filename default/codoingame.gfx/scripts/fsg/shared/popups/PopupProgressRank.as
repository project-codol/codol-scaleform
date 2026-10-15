package fsg.shared.popups
{
   import codo.common.CFunctionCommonContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PopupProgressRank extends MovieClip
   {
      
      public static const PROGRESS_INACTIVE_FRAME:uint = 1;
      
      public static const PROGRESS_ACTIVE_FRAME:uint = 2;
      
      public static const PROGRESS_PRESTIGE_FRAME:uint = 3;
      
      public var myRankTF:TextField;
      
      public function PopupProgressRank()
      {
         super();
      }
      
      public function set rank(r:uint) : void
      {
         this.myRankTF.text = CFunctionCommonContainer.GetDisplayLevel(r);
      }
   }
}


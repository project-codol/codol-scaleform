package components.scoreboard_part
{
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class SurvivalPanelObjective extends MovieClip
   {
      
      private static const STATUS_COMPLETE:int = 1;
      
      private static const STATUS_FAILED:int = 2;
      
      private static const FRAME_COMPLETE:int = 1;
      
      private static const FRAME_FAILED:int = 2;
      
      private static const FRAME_CURRENT:int = 3;
      
      public var myName:TextField;
      
      public var myDescription:TextField;
      
      public var myCompletionStatus:MovieClip;
      
      public function SurvivalPanelObjective()
      {
         super();
      }
      
      public function setData(objName:String, objText:String, status:int) : void
      {
         if(status == STATUS_COMPLETE)
         {
            this.myCompletionStatus.gotoAndStop(FRAME_COMPLETE);
            this.myDescription.textColor = GlobalGuide.WHITE;
         }
         else if(status == STATUS_FAILED)
         {
            this.myCompletionStatus.gotoAndStop(FRAME_FAILED);
            this.myDescription.textColor = GlobalGuide.WHITE;
         }
         else
         {
            this.myCompletionStatus.gotoAndStop(FRAME_CURRENT);
            this.myDescription.textColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
         }
         this.myName.text = LocalizeUtil.localize(objName);
         this.myDescription.text = LocalizeUtil.localize(objText);
      }
   }
}


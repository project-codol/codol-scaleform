package fsg.shared.widgets
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class FsgPanelTab extends MovieClip
   {
      
      private static const FRAME_DAILY_CHALLENGE:uint = 1;
      
      private static const FRAME_VETERAN:uint = 2;
      
      public var myIcon:MovieClip;
      
      public var myTabBG:MovieClip;
      
      public var myHitArea:Sprite;
      
      public var myTextTF:TextField;
      
      public function FsgPanelTab()
      {
         super();
      }
      
      public function get isTabVeteran() : Boolean
      {
         return false;
      }
      
      public function set isTabVeteran(isVeteran:Boolean) : void
      {
         this.myIcon.gotoAndStop(isVeteran ? FRAME_VETERAN : FRAME_DAILY_CHALLENGE);
         this.myTabBG.gotoAndStop(this.myIcon.currentFrame);
      }
      
      public function get tabTitle() : String
      {
         return this.myTextTF.text;
      }
      
      public function set tabTitle(str:String) : void
      {
         this.myTextTF.text = str.toUpperCase();
      }
      
      public function resizeWidth(widthToSet:uint) : void
      {
         this.myTabBG.width = this.myTextTF.width = widthToSet;
      }
   }
}


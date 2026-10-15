package codo.views.hud.missionGuide
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MissionGuide extends MovieClip
   {
      
      public var myText:TextField;
      
      public var myCorner:MovieClip;
      
      public var myDeleteLine:MovieClip;
      
      public var myTextWrapper:MovieClip;
      
      public function MissionGuide()
      {
         super();
         this.myDeleteLine.visible = false;
         this.myText = this.myTextWrapper["myText"];
      }
      
      public function setMissionGuide(guide:String) : void
      {
         this.myText.text = guide;
         this.myDeleteLine.visible = false;
      }
      
      public function Blink() : void
      {
         this.gotoAndPlay(2);
      }
   }
}


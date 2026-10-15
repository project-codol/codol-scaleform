package components.fsggamemodes_part
{
   import codo.localization.DictRoom;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FsgMissionCompleteBanner extends MovieClip
   {
      
      public var myTextTF:TextField;
      
      public function FsgMissionCompleteBanner()
      {
         super();
         this.visible = false;
         this.myTextTF.text = DictRoom.MISSION_COMPLETE;
      }
      
      public function setMissionCompleted(wasCompleted:Boolean = false) : void
      {
         this.visible = wasCompleted;
      }
      
      public function set isSelected(selected:Boolean) : void
      {
         gotoAndStop(selected ? 1 : 2);
      }
   }
}


package codo.views.hud.popups.HudVIPSelectVIPCharacterPopup_parts.HudVIPSelectVIPCharacterCard_parts
{
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class HudVIPSelectVIPCharacterCardSlot extends MovieClip
   {
      
      public var myIcon:FsgImageHolder;
      
      private var mData:*;
      
      public function HudVIPSelectVIPCharacterCardSlot()
      {
         super();
      }
      
      public function setData(data:*) : void
      {
         this.mData = data;
         this.myIcon.setImage(data.imageURL);
      }
   }
}


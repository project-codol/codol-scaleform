package codo.component.social
{
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   
   public class ClanSortableTitle extends ClanOptionButton
   {
      
      public function ClanSortableTitle()
      {
         super();
         myLabel.textStyle = ClanGuide.styleClanSortableHeader;
         myLabel.x = 0;
         myLabel.y = 0;
         this.endHighlight();
      }
      
      override public function set label(text:String) : void
      {
         super.label = text;
         myIcon.x = myLabel.x + myLabel.textWidth + 7;
         myIcon.y = (myHitArea.height - myIcon.height) / 2;
         myHitArea.width = myIcon.x + myIcon.width;
         width = myHitArea.width;
         height = myHitArea.height;
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         mToggled = toggled;
         myIcon.visible = toggled;
         myLabel.fontColor = toggled ? GlobalGuide.CODO_BLUE_LIGHT : GlobalGuide.GRAY_80;
         myIcon.gotoAndStop(toggled ? 2 : 1);
      }
      
      override protected function showHighlight() : void
      {
         myLabel.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         myIcon.visible = true;
         myIcon.gotoAndStop(2);
      }
      
      override protected function endHighlight() : void
      {
         if(!toggled)
         {
            myIcon.visible = false;
            myIcon.gotoAndStop(1);
            myLabel.fontColor = GlobalGuide.GRAY_80;
         }
      }
      
      override protected function showClickState() : void
      {
      }
      
      override protected function showOptions() : void
      {
         if(mOptions.length > 1)
         {
            super.showOptions();
         }
         else if(mOptions.length == 1)
         {
            mOptions[0].handle();
         }
      }
   }
}


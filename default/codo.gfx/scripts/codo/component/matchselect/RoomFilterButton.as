package codo.component.matchselect
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.objects.MatchSelectOptionObj;
   import codo.style.GlobalGuide;
   import codo.style.MatchSelectGuide;
   
   public class RoomFilterButton extends UIInteractiveComponent implements ISelectable
   {
      
      public var myLabel:TextField;
      
      protected var mToggled:Boolean = false;
      
      public function RoomFilterButton()
      {
         super();
         isInteractiveEnabled = true;
         this.initStage();
      }
      
      protected function initStage() : void
      {
         this.myLabel.textStyle = MatchSelectGuide.styleGetRoomFilterButton;
         this.myLabel.x = 0;
         this.myLabel.y = 0;
         this.myLabel.width = myHitArea.width;
         this.myLabel.height = myHitArea.height;
         gotoAndStop(1);
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!this.mToggled)
         {
            this.showHighlight();
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!this.mToggled)
         {
            this.endHighlight();
         }
      }
      
      public function get selected() : Boolean
      {
         return this.mToggled;
      }
      
      public function set selected(newSelected:Boolean) : void
      {
         this.mToggled = newSelected;
         if(this.mToggled)
         {
            this.showHighlight();
         }
         else
         {
            this.endHighlight();
         }
      }
      
      protected function showHighlight() : void
      {
         gotoAndStop(2);
         this.myLabel.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
      }
      
      protected function endHighlight() : void
      {
         gotoAndStop(1);
         this.myLabel.fontColor = GlobalGuide.WHITE;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var optionObj:MatchSelectOptionObj = data as MatchSelectOptionObj;
         this.myLabel.text = optionObj.name;
      }
   }
}


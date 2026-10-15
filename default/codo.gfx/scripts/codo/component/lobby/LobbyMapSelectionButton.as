package codo.component.lobby
{
   import codo.component.ComboBox;
   import codo.component.core.UIInteractiveComponent;
   import codo.event.ParaEvent;
   import codo.views.GameLobbyView;
   
   public class LobbyMapSelectionButton extends UIInteractiveComponent
   {
      
      public var myComboBox:ComboBox;
      
      private var mChangedMapCallback:Function = null;
      
      private var mToggled:Boolean = false;
      
      public function LobbyMapSelectionButton()
      {
         super();
         isInteractiveEnabled = true;
         this.myComboBox.myLabel.visible = false;
         this.myComboBox.myArrow.visible = false;
         this.myComboBox.myBackground.visible = false;
         this.myComboBox.myHitArea.visible = false;
         this.myComboBox.singleOptionMode = true;
         this.myComboBox.allowScrolling = true;
         this.myComboBox.scrollListHeight = GameLobbyView.LOBBY_SCROLL_LIST_HEIGHT;
         this.myComboBox.addEventListener(ComboBox.EVT_CHANGE,this.onComboBoxChanged);
         this.myComboBox.clickedOffCallback = this.onComboBoxClickedOff;
      }
      
      override public function set enabled(val:Boolean) : void
      {
         if(super.enabled == val)
         {
            return;
         }
         super.enabled = val;
         if(!enabled)
         {
            gotoAndStop("Normal");
            if(this.mToggled)
            {
               this.mToggled = false;
               this.myComboBox.toggled = false;
            }
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         gotoAndStop("Mouseover");
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(this.mToggled)
         {
            gotoAndStop("Selected");
         }
         else
         {
            gotoAndStop("Normal");
         }
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         this.mToggled = !this.mToggled;
         if(this.mToggled)
         {
            gotoAndStop("Mousedown");
            this.myComboBox.toggled = true;
         }
         else
         {
            gotoAndStop("Normal");
            this.myComboBox.toggled = false;
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         if(this.mToggled)
         {
            gotoAndStop("Selected");
         }
         else
         {
            gotoAndStop("Normal");
         }
      }
      
      override public function setData(data:*) : void
      {
         this.myComboBox.dataProvider = data as Array;
      }
      
      public function setSelectedIndex(index:int) : void
      {
         this.myComboBox.selectedIndex = index;
      }
      
      public function setChangedMapCallback(f:Function) : void
      {
         this.mChangedMapCallback = f;
      }
      
      private function onComboBoxChanged(cEvt:ParaEvent) : void
      {
         this.mToggled = false;
         gotoAndStop("Normal");
         if(this.mChangedMapCallback != null)
         {
            this.mChangedMapCallback(this.myComboBox.selectedData.id);
         }
      }
      
      private function onComboBoxClickedOff() : void
      {
         this.mToggled = false;
         gotoAndStop("Normal");
      }
   }
}


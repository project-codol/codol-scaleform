package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.ComboBoxSettingRowObj;
   import flash.display.Sprite;
   
   public class ComboBoxSettingRow extends UIInteractiveComponent
   {
      
      public var myComboBox:ComboBox;
      
      public var myLabel:TextField;
      
      public var myBackground:Sprite;
      
      public function ComboBoxSettingRow()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var itemData:ComboBoxSettingRowObj = data as ComboBoxSettingRowObj;
         this.myComboBox.width = 210;
         this.myComboBox.allowScrolling = true;
         this.myComboBox.scrollListHeight = 300;
         this.myComboBox.singleOptionMode = true;
         this.myComboBox.showSelectionInHeader = true;
         this.myComboBox.dataProvider = itemData.dataProvider;
         this.myComboBox.registerClickEvent(this.onComboBoxClicked);
         this.myLabel.text = itemData.label;
      }
      
      override public function set width(w:Number) : void
      {
         this.myBackground.width = w;
         this.myLabel.width = w;
         this.myComboBox.x = w - this.myComboBox.width;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      private function onComboBoxClicked() : void
      {
         parent.swapChildren(this,parent.getChildAt(parent.numChildren - 1));
      }
   }
}


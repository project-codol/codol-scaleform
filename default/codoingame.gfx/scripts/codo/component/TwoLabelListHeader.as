package codo.component
{
   import codo.objects.ScrollListTwoLabelHeaderObj;
   import codo.style.GlobalGuide;
   
   public class TwoLabelListHeader extends ListHeaderToggle
   {
      
      public var mySubLabel:TextField;
      
      public function TwoLabelListHeader()
      {
         super();
         this.mySubLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.mySubLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var headerData:ScrollListTwoLabelHeaderObj = mData as ScrollListTwoLabelHeaderObj;
         if(Boolean(headerData.subLabel))
         {
            this.mySubLabel.text = headerData.subLabel;
         }
         myCount.visible = false;
      }
      
      override public function set width(w:Number) : void
      {
         super.width = w;
         this.mySubLabel.x = myBackground.width - this.mySubLabel.textWidth - 15;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.mySubLabel.fontColor = GlobalGuide.WHITE;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.mySubLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
      }
   }
}


package codo.component
{
   import codo.style.GlobalGuide;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class CartButton extends Button
   {
      
      public var myIcon:Sprite;
      
      private var mIconColorOn:ColorTransform;
      
      private var mIconColorOff:ColorTransform;
      
      public function CartButton()
      {
         super();
         this.mIconColorOn = new ColorTransform();
         this.mIconColorOn.color = GlobalGuide.WHITE;
         this.mIconColorOff = new ColorTransform();
         this.mIconColorOff.color = GlobalGuide.NAV_TEXT_BLUE;
         isInteractiveEnabled = true;
         this.myIcon.transform.colorTransform = this.mIconColorOff;
         myLabel.textStyle = GlobalGuide.styleGlobalShoppingCartItemCount;
         myLabel.fontColor = GlobalGuide.NAV_TEXT_BLUE;
         this.numberOfItems = 0;
         labelFocusColor = GlobalGuide.WHITE;
         labelUnfocusColor = GlobalGuide.NAV_TEXT_BLUE;
      }
      
      public function set numberOfItems(num:int) : void
      {
         if(num > 0)
         {
            myLabel.text = num.toString();
            myLabel.visible = true;
         }
         else
         {
            myLabel.visible = false;
         }
         myLabel.x = this.myIcon.x;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         GlobalGuide.TOGGLE_ITEM_FOCUS(this,true,false,1.1);
         this.myIcon.transform.colorTransform = this.mIconColorOn;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         GlobalGuide.TOGGLE_ITEM_FOCUS(this,false);
         this.myIcon.transform.colorTransform = this.mIconColorOff;
      }
   }
}


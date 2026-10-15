package codo.shared
{
   import codo.component.ItemFooterButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1483")]
   public dynamic class ItemFooterButton extends codo.component.ItemFooterButton
   {
      
      public function ItemFooterButton()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}


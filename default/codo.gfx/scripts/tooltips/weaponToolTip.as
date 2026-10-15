package tooltips
{
   import components.tip_part.ItemTip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3952")]
   public dynamic class weaponToolTip extends ItemTip
   {
      
      public function weaponToolTip()
      {
         super();
         addFrameScript(9,this.frame10,19,this.frame20);
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         visible = false;
         stop();
      }
   }
}


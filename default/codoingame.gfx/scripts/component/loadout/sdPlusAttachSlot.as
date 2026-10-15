package component.loadout
{
   import codo.component.loadout.SDPlusAttachSlot;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3552")]
   public dynamic class sdPlusAttachSlot extends SDPlusAttachSlot
   {
      
      public function sdPlusAttachSlot()
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


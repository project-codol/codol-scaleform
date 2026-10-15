package component.loadout
{
   import codo.component.loadout.SDPlusAttachSlot;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3555")]
   public dynamic class WeaponCardAttachmentCosmetic extends SDPlusAttachSlot
   {
      
      public function WeaponCardAttachmentCosmetic()
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


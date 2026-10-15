package codo.shared
{
   import codo.component.CharacterSwitchModuleArrow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5433")]
   public dynamic class characterSwitchModuleLoadoutArrow extends CharacterSwitchModuleArrow
   {
      
      public function characterSwitchModuleLoadoutArrow()
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


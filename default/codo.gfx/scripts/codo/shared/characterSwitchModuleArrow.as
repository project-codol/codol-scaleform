package codo.shared
{
   import codo.component.CharacterSwitchModuleArrow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5438")]
   public dynamic class characterSwitchModuleArrow extends CharacterSwitchModuleArrow
   {
      
      public function characterSwitchModuleArrow()
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


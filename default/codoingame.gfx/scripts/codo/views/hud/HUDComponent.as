package codo.views.hud
{
   import codo.common.CFunctionInGameContainer;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.errors.IllegalOperationError;
   
   public class HUDComponent extends MovieClip
   {
      
      protected var mCompIndex:int;
      
      public function HUDComponent()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
      }
      
      public function registerComponent() : void
      {
         if(ScaleformUtil.isScaleform)
         {
            this.mCompIndex = CFunctionInGameContainer.AS_RegisterHUDComponent(this.CompType,this);
         }
         else
         {
            this.mCompIndex = -1;
         }
      }
      
      protected function Notify(msg:int, param:Object) : Object
      {
         if(ScaleformUtil.isScaleform)
         {
            return CFunctionInGameContainer.AS_HUDComponentNotify(this.mCompIndex,msg,param);
         }
         return null;
      }
      
      public function get CompType() : int
      {
         throw new IllegalOperationError("Must override CompType function");
      }
   }
}


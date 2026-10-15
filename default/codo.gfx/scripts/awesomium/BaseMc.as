package awesomium
{
   import flash.display.MovieClip;
   
   public class BaseMc extends MovieClip
   {
      
      protected var m_rawAsset:MovieClip;
      
      public function BaseMc(asset:MovieClip)
      {
         super();
         this.m_rawAsset = asset;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.assembleAsset();
         this.registerListener();
      }
      
      protected function assembleAsset() : void
      {
      }
      
      protected function registerListener() : void
      {
      }
      
      protected function unregisterListener() : void
      {
      }
      
      public function dispose() : void
      {
         this.unregisterListener();
      }
   }
}


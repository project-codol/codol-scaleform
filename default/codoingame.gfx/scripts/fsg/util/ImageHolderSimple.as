package fsg.util
{
   import codo.event.ImageLoaderEvent;
   import flash.display.DisplayObject;
   
   public class ImageHolderSimple extends FsgImageHolder
   {
      
      public function ImageHolderSimple()
      {
         super();
      }
      
      override protected function onImageLoaded(e:ImageLoaderEvent) : void
      {
         try
         {
            clearChildDisplayObjects();
            mLoadedAsset = addChild(e.m_displayObject as DisplayObject);
            displatchLoadComplete(e.m_status);
         }
         catch(error:Error)
         {
            addChild(e.m_displayObject as DisplayObject);
            displatchLoadComplete(e.m_status);
         }
      }
   }
}


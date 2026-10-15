package codo.component.matchselect
{
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.objects.MapIllustrationObj;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class MapSmallIntroduction extends UIInteractiveComponent implements ISelectable
   {
      
      public var myOutline:MovieClip;
      
      public var myVideoMask:MovieClip;
      
      public var myImageHolder:FsgImageHolder;
      
      private var mSelected:Boolean;
      
      public function MapSmallIntroduction()
      {
         super();
         this.myOutline.visible = false;
         this.myVideoMask.visible = false;
         isInteractiveEnabled = true;
      }
      
      override public function setData(data:*) : void
      {
         var map:MapIllustrationObj = null;
         super.setData(data);
         map = data as MapIllustrationObj;
         this.myImageHolder.setImage(map.imageURL);
         this.myOutline.visible = false;
         this.myVideoMask.visible = map.videoURL != "";
      }
      
      public function highlightOutline() : void
      {
         this.myOutline.visible = true;
      }
      
      public function set selected(sel:Boolean) : void
      {
         this.mSelected = sel;
         this.myOutline.visible = this.mSelected;
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
   }
}


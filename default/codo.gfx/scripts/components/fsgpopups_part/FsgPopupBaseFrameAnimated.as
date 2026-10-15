package components.fsgpopups_part
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class FsgPopupBaseFrameAnimated extends Sprite
   {
      
      public var myMask:Sprite;
      
      public var myOutline:Sprite;
      
      public var myAnimatedHighlight:MovieClip;
      
      public function FsgPopupBaseFrameAnimated()
      {
         super();
      }
      
      public function setSize(w:int = -1, h:int = -1) : void
      {
         if(w > -1)
         {
            this.myOutline.width = this.myMask.width = w;
            this.myAnimatedHighlight.scaleX = this.myOutline.scaleX;
         }
         if(h > -1)
         {
            this.myOutline.height = this.myMask.height = h;
            this.myAnimatedHighlight.scaleY = this.myOutline.scaleY;
         }
      }
   }
}


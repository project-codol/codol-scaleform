package codo.views.hud.shared
{
   import flash.display.MovieClip;
   
   public class AnimatedWaypointBase extends MovieClip
   {
      
      public var myArrow:MovieClip;
      
      public var type:int;
      
      public var id:int;
      
      public function AnimatedWaypointBase()
      {
         super();
         this.id = 0;
         this.type = 0;
      }
      
      public function setData(data:*) : void
      {
      }
      
      public function setupScale(w:Number, h:Number) : void
      {
         width = w;
         height = h;
      }
      
      public function setupArrow(alpha:Number, angle:Number) : void
      {
         if(this.myArrow == null)
         {
            return;
         }
         this.myArrow.visible = alpha > 0;
         this.myArrow.rotation = angle;
      }
      
      public function setupAlpha(a:Number) : void
      {
         alpha = a;
      }
   }
}


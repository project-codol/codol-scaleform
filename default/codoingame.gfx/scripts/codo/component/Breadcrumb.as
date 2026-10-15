package codo.component
{
   import codo.component.factory.GlobalFactory;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class Breadcrumb extends MovieClip
   {
      
      public static const DEFAULT_X:Number = 3;
      
      public static const DEFAULT_Y:Number = 5;
      
      public var myText:flash.text.TextField;
      
      public function Breadcrumb()
      {
         super();
      }
      
      public static function addBreadcrumb(obj:DisplayObjectContainer, x:Number = NaN, y:Number = NaN, isEnd:Boolean = true) : Breadcrumb
      {
         var breadcrumb:Breadcrumb = null;
         breadcrumb = !isEnd ? GlobalFactory.BUILD_BREADCRUMB() : GlobalFactory.BUILD_BREADCRUMB_END();
         obj.addChild(breadcrumb);
         breadcrumb.x = isNaN(x) ? DEFAULT_X : x;
         breadcrumb.y = isNaN(y) ? DEFAULT_Y : y;
         breadcrumb.visible = false;
         return breadcrumb;
      }
      
      public function set text(text:String) : void
      {
         if(this.myText != null)
         {
            this.myText.text = text;
         }
      }
   }
}


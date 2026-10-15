package codo.utils
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class StageUtil
   {
      
      public function StageUtil()
      {
         super();
      }
      
      public static function isElementIncludeIn(cElement:Object, cTarget:Object) : Boolean
      {
         var result:Boolean = false;
         var tempParent:DisplayObject = cElement as DisplayObject;
         while(tempParent != null)
         {
            if(tempParent == cTarget)
            {
               result = true;
               break;
            }
            tempParent = tempParent.parent;
         }
         return result;
      }
      
      public static function localPosToStagePos(cTarget:DisplayObject) : Point
      {
         return cTarget.parent.localToGlobal(new Point(cTarget.x,cTarget.y));
      }
   }
}


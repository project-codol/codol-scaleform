package codo.utils
{
   public class ObjUtil
   {
      
      public function ObjUtil()
      {
         super();
      }
      
      public static function convert(cObj:Object, cCls:Class) : *
      {
         if(cObj is cCls)
         {
            return cObj as cCls;
         }
         return new cCls(cObj);
      }
      
      public static function merge(objectA:Object, objectB:Object) : Object
      {
         var prop:String = null;
         var result:Object = {};
         for(prop in objectB)
         {
            result[prop] = objectB[prop];
         }
         for(prop in objectA)
         {
            result[prop] = objectA[prop];
         }
         return result;
      }
      
      public static function ObjTrace(oObj:Object, sPrefix:String = "") : void
      {
         var i:* = undefined;
         if(sPrefix == "")
         {
            sPrefix = "---";
         }
         else
         {
            sPrefix += "---";
         }
         for(i in oObj)
         {
            trace(sPrefix,i + " : " + oObj[i],"  ");
            if(typeof oObj[i] == "object")
            {
               ObjTrace(oObj[i],sPrefix);
            }
         }
      }
   }
}


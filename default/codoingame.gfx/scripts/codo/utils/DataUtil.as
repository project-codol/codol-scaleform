package codo.utils
{
   import codo.models.DataProvider;
   import codo.objects.CustomObject;
   
   public class DataUtil
   {
      
      public function DataUtil()
      {
         super();
      }
      
      public static function isInArray(cID:*, cDat:Array) : Boolean
      {
         var dat:* = undefined;
         if(cDat == null || cDat.length <= 0)
         {
            return false;
         }
         for each(dat in cDat)
         {
            if(cID == dat.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function indexInArray(cObj:Object, cDat:Array) : int
      {
         var dat:* = undefined;
         if(cDat == null || cDat.length <= 0)
         {
            return -1;
         }
         for each(dat in cDat)
         {
            if(cObj == dat.id)
            {
               return cDat.indexOf(dat);
            }
         }
         return -1;
      }
      
      public static function arrayToDP(cDat:Array) : DataProvider
      {
         var dat:* = undefined;
         var tempDP:DataProvider = new DataProvider();
         if(cDat != null)
         {
            for each(dat in cDat)
            {
               tempDP.push(dat);
            }
         }
         return tempDP;
      }
      
      public static function compareObj(cObjA:Object, cObjB:Object) : Boolean
      {
         var i:* = undefined;
         if(cObjA == cObjB)
         {
            return true;
         }
         if(cObjA == null || cObjB == null)
         {
            return false;
         }
         if(cObjA is CustomObject && cObjB is CustomObject)
         {
            return cObjA.toString() == cObjB.toString();
         }
         for(i in cObjA)
         {
            if(typeof cObjA[i] == "object")
            {
               if(DataUtil.compareObj(cObjA[i],cObjB[i]) == false)
               {
                  return false;
               }
            }
            else if(cObjA[i] != cObjB[i])
            {
               return false;
            }
         }
         for(i in cObjB)
         {
            if(typeof cObjB[i] == "object")
            {
               if(DataUtil.compareObj(cObjB[i],cObjA[i]) == false)
               {
                  return false;
               }
            }
            else if(cObjB[i] != cObjA[i])
            {
               return false;
            }
         }
         return true;
      }
      
      public static function shuffleVectorOrArray(input:*) : void
      {
         var randomIndex:int = 0;
         var itemAtIndex:* = undefined;
         var floor:Function = Math.floor;
         for(var i:int = input.length - 1; i >= 0; )
         {
            randomIndex = floor(Math.random() * (i + 1));
            itemAtIndex = input[randomIndex];
            input[randomIndex] = input[i];
            input[i] = itemAtIndex;
            i--;
         }
      }
      
      public static function VectorToArray(vec:Object) : Array
      {
         var len:uint = vec != null ? uint(vec["length"]) : 0;
         var arr:Array = new Array(len);
         for(var i:int = 0; i < arr.length; i++)
         {
            arr[i] = vec[i];
         }
         return arr;
      }
      
      public static function copyElems(dest:Object, ... srcs) : *
      {
         var src:* = undefined;
         var j:int = 0;
         for(var i:int = 0; i < srcs.length; i++)
         {
            src = srcs[i];
            if(src != null)
            {
               for(j = 0; j < src.length; j++)
               {
                  dest.push(src[j]);
               }
            }
         }
         return dest;
      }
      
      public static function CopyData(dest:Object, src:Object) : void
      {
         var i:uint = 0;
         var s:String = null;
         if(src is Array)
         {
            for(i = 0; i < src.length; i++)
            {
               dest[i] = src[i];
            }
         }
         else
         {
            for(s in src)
            {
               try
               {
                  dest[s] = src[s];
               }
               catch(e:Error)
               {
               }
            }
         }
      }
   }
}


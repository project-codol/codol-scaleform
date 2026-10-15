package codo.objects
{
   import codo.utils.ScaleformUtil;
   import com.adobe.utils.StringUtil;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   
   public dynamic class CustomObject
   {
      
      private static var LINK_KEY:Dictionary = new Dictionary();
      
      public function CustomObject(cObj:Object = null)
      {
         var tempCls:Class = null;
         var clsPackage:String = null;
         var tempCustVector:Array = null;
         var tempCustVectorCls:Class = null;
         var k:* = undefined;
         var i:* = undefined;
         var j:uint = 0;
         super();
         var tempDataKey:Dictionary = GET_LINK_KEY_BY_CLASS(this.constructor);
         if(cObj is CustomObject)
         {
            for(k in tempDataKey)
            {
               this[k] = cObj[k];
            }
         }
         else
         {
            for(i in cObj)
            {
               if(tempDataKey[i] != null && tempDataKey[i].indexOf("::Vector") != -1)
               {
                  if(ScaleformUtil.isScaleform)
                  {
                     clsPackage = tempDataKey[i].substr(20);
                  }
                  else
                  {
                     clsPackage = tempDataKey[i].split("__AS3__.vec::Vector.<")[1].substr(0,-1);
                  }
                  tempCls = getDefinitionByName("Vector.<" + clsPackage + ">") as Class;
                  if(clsPackage.indexOf("::") != -1 && cObj[i].length > 0)
                  {
                     tempCustVectorCls = getDefinitionByName(StringUtil.replace(clsPackage,"::",".")) as Class;
                     tempCustVector = [];
                     for(j = 0; j < cObj[i].length; j++)
                     {
                        if(cObj[i][j] is CustomObject == false)
                        {
                           tempCustVector.push(new tempCustVectorCls(cObj[i][j]));
                        }
                        else
                        {
                           tempCustVector.push(cObj[i][j]);
                        }
                     }
                     this[i] = tempCls(tempCustVector);
                  }
                  else
                  {
                     this[i] = tempCls(cObj[i]);
                  }
               }
               else if(tempDataKey[i] != null && tempDataKey[i].indexOf("::") != -1)
               {
                  tempCls = getDefinitionByName(StringUtil.replace(tempDataKey[i],"::",".")) as Class;
                  if(cObj[i] is CustomObject)
                  {
                     this[i] = cObj[i];
                  }
                  else
                  {
                     this[i] = new tempCls(cObj[i]);
                  }
               }
               else
               {
                  this[i] = cObj[i];
               }
            }
         }
      }
      
      public static function GET_LINK_KEY_BY_CLASS(cCls:Class) : Dictionary
      {
         var tempXML:XML = null;
         var j:uint = 0;
         var tempDict:Dictionary = LINK_KEY[cCls];
         if(tempDict == null)
         {
            LINK_KEY[cCls] = new Dictionary();
            tempDict = LINK_KEY[cCls];
            tempXML = describeType(cCls);
            for(j = 0; j < tempXML.factory.variable.@name.length(); j++)
            {
               tempDict[String(tempXML.factory.variable.@name[j])] = String(tempXML.factory.variable.@type[j]);
            }
         }
         return tempDict;
      }
      
      public function toString() : String
      {
         var i:* = undefined;
         var result:String = this.constructor.toString() + "{";
         var tempDataKeys:Dictionary = GET_LINK_KEY_BY_CLASS(this.constructor);
         for(i in tempDataKeys)
         {
            result += i + ": " + this[i] + ", ";
         }
         return result.substr(0,result.length - 2) + "}";
      }
   }
}


package codo.utils
{
   public class XMLDecoder
   {
      
      private var value:*;
      
      private var strict:Boolean;
      
      public function XMLDecoder(xml:XML, strict:Boolean = false)
      {
         super();
         this.strict = strict;
         if(xml != null)
         {
            this.value = this.parseValue(xml.children()[0]);
         }
      }
      
      public function getValue() : *
      {
         return this.value;
      }
      
      private function parseValue(xml:XML) : Object
      {
         var itemXML:XML = null;
         var cls:Class = null;
         var myobject:Object = null;
         var array:Array = null;
         var object:Object = null;
         var type:String = xml.name().localName;
         var name:String = xml.@name;
         var value:String = xml.@value;
         if(type == "int")
         {
            return int(value);
         }
         if(type == "number")
         {
            return Number(value);
         }
         if(type == "string")
         {
            return value;
         }
         if(type == "boolean")
         {
            return Boolean(value == "true" ? true : false);
         }
         if(type == "array")
         {
            array = [];
            for each(itemXML in xml.children())
            {
               array.push(this.parseValue(itemXML));
            }
            return array;
         }
         if(type == "object")
         {
            object = {};
            for each(itemXML in xml.children())
            {
               object[itemXML.@name] = this.parseValue(itemXML);
            }
            return object;
         }
         if(type == "")
         {
            return null;
         }
         return null;
      }
   }
}


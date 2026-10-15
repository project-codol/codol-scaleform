package com.greensock.text
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   
   public class SplitTextField extends Sprite
   {
      
      public static const version:Number = 0.6;
      
      public static const TYPE_CHARACTERS:String = "characters";
      
      public static const TYPE_WORDS:String = "words";
      
      public static const TYPE_LINES:String = "lines";
      
      private static const _propNames:Array = ["embedFonts","alpha","antiAliasType","blendMode","filters","focusRect","gridFitType","mouseEnabled","sharpness","selectable","textColor","thickness"];
      
      private var _splitType:String;
      
      private var _regOffsetX:Number;
      
      private var _regOffsetY:Number;
      
      private var _source:TextField;
      
      public var textFields:Array;
      
      public function SplitTextField(source:TextField = null, splitType:String = "characters", regOffsetX:Number = 0, regOffsetY:Number = 0)
      {
         super();
         this._source = source;
         this._splitType = splitType;
         this._regOffsetX = regOffsetX;
         this._regOffsetY = regOffsetY;
         this.mouseChildren = false;
         this.textFields = [];
         if(Boolean(source))
         {
            this.update();
         }
      }
      
      public static function split(source:TextField, spitType:String = "characters", container:DisplayObjectContainer = null, offset:Point = null) : Array
      {
         var segments:Array = null;
         var format:TextFormat = null;
         var tf:TextField = null;
         var x:Number = NaN;
         var line:uint = 0;
         var i:uint = 0;
         var j:int = 0;
         var l:uint = 0;
         var text:String = null;
         var totalSegments:uint = 0;
         var charOffset:uint = 0;
         var lineMetrics:TextLineMetrics = null;
         var ascentDiff:Number = NaN;
         if(container == null)
         {
            container = source.parent;
         }
         if(offset == null)
         {
            offset = new Point(0,0);
         }
         var index:uint = source.parent == container ? uint(source.parent.getChildIndex(source)) : uint(container.numChildren);
         var cnt:uint = 0;
         var linesTotal:uint = uint(source.numLines);
         var bounds:Rectangle = source.getBounds(source);
         var y:Number = bounds.y + offset.y;
         var fields:Array = [];
         for(line = 0; line < linesTotal; line++)
         {
            text = source.getLineText(line);
            charOffset = uint(source.getLineOffset(line));
            lineMetrics = source.getLineMetrics(line);
            if(source.text.length > charOffset)
            {
               format = source.getTextFormat(charOffset,charOffset + 1);
               if(format.align == "left")
               {
                  x = bounds.x + offset.x;
               }
               else if(format.align == "center")
               {
                  x = bounds.x + offset.x - 2 + (source.width - lineMetrics.width) * 0.5;
               }
               else
               {
                  x = bounds.x + offset.x - 4 + (source.width - lineMetrics.width);
               }
               if(spitType == TYPE_CHARACTERS)
               {
                  segments = text.split("");
               }
               else if(spitType == TYPE_WORDS)
               {
                  segments = text.split(" ").join("~#$ ~#$").split("~#$");
               }
               else
               {
                  segments = [text];
               }
               totalSegments = segments.length;
               for(i = 0; i < totalSegments; i++)
               {
                  if(segments[i].length != 0)
                  {
                     tf = new TextField();
                     j = int(_propNames.length);
                     while(Boolean(j--))
                     {
                        tf[_propNames[j]] = source[_propNames[j]];
                     }
                     tf.autoSize = TextFieldAutoSize.LEFT;
                     tf.selectable = tf.multiline = tf.wordWrap = false;
                     tf.text = segments[i];
                     l = uint(segments[i].length);
                     for(j = 0; j < l; j++)
                     {
                        format = source.getTextFormat(charOffset,charOffset + 1);
                        charOffset += 1;
                        format.align = TextFormatAlign.LEFT;
                        tf.setTextFormat(format,j,j + 1);
                     }
                     tf.x = x;
                     tf.y = y;
                     ascentDiff = lineMetrics.ascent - tf.getLineMetrics(0).ascent;
                     if(Boolean(ascentDiff))
                     {
                        tf.y += ascentDiff;
                     }
                     x += tf.textWidth;
                     if(segments[i] != " ")
                     {
                        fields[cnt++] = tf;
                     }
                  }
               }
               y += lineMetrics.height;
            }
         }
         i = fields.length;
         while(Boolean(i--))
         {
            container.addChildAt(TextField(fields[i]),index);
         }
         if(Boolean(source.parent))
         {
            source.parent.removeChild(source);
         }
         return fields;
      }
      
      public function activate() : void
      {
         this.activated = true;
      }
      
      public function deactivate() : void
      {
         this.activated = false;
      }
      
      public function destroy() : void
      {
         this.activated = false;
         this.clear();
         this._source = null;
      }
      
      private function update() : void
      {
         var p:DisplayObjectContainer = null;
         var point:Point = null;
         this.clear();
         if(Boolean(this._source.parent))
         {
            p = this._source.parent;
            p.addChildAt(this,p.getChildIndex(this._source));
            p.removeChild(this._source);
         }
         var m:Matrix = this._source.transform.matrix;
         if(this._regOffsetX != 0 || this._regOffsetY != 0)
         {
            point = m.transformPoint(new Point(this._regOffsetX,this._regOffsetY));
            m.tx = point.x;
            m.ty = point.y;
         }
         this.transform.matrix = m;
         this.textFields = split(this._source,this._splitType,this,new Point(-this._regOffsetX,-this._regOffsetY));
      }
      
      private function clear() : void
      {
         var i:int = int(this.textFields.length);
         while(Boolean(i--))
         {
            this.removeChild(this.textFields[i]);
         }
         this.textFields = [];
      }
      
      public function get source() : TextField
      {
         return this._source;
      }
      
      public function set source(tf:TextField) : void
      {
         this._source = tf;
         this.update();
      }
      
      public function get splitType() : String
      {
         return this._splitType;
      }
      
      public function set splitType(type:String) : void
      {
         this._splitType = type;
         this.update();
      }
      
      public function get regOffsetX() : Number
      {
         return this._regOffsetX;
      }
      
      public function set regOffsetX(x:Number) : void
      {
         this._regOffsetX = x;
         this.update();
      }
      
      public function get regOffsetY() : Number
      {
         return this._regOffsetY;
      }
      
      public function set regOffsetY(y:Number) : void
      {
         this._regOffsetY = y;
         this.update();
      }
      
      public function get activated() : Boolean
      {
         return Boolean(this.parent != null);
      }
      
      public function set activated(b:Boolean) : void
      {
         if(this._source == null)
         {
            return;
         }
         if(Boolean(this._source.parent) && b)
         {
            this._source.parent.addChildAt(this,this._source.parent.getChildIndex(this._source));
            this._source.parent.removeChild(this._source);
         }
         else if(Boolean(this.parent) && !b)
         {
            this.parent.addChildAt(this._source,this.parent.getChildIndex(this));
            this.parent.removeChild(this);
         }
      }
   }
}


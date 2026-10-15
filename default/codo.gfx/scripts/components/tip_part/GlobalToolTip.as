package components.tip_part
{
   import codo.interfaces.IDisposable;
   import codo.objects.ToolTipObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class GlobalToolTip extends MovieClip implements IDisposable
   {
      
      public var myBg:MovieClip;
      
      public var myLabel:TextField;
      
      public var myArrow:Sprite;
      
      private var m_config:ToolTipObject;
      
      public function GlobalToolTip()
      {
         super();
         mouseEnabled = buttonMode = this.myArrow.visible = false;
         this.myLabel.multiline = true;
         this.myLabel.wordWrap = true;
         this.myLabel.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function build(config:ToolTipObject) : void
      {
         var position:Point = null;
         var offsetWidth:uint = 0;
         var offsetHeight:uint = 0;
         var requestClip:DisplayObject = config.requestClip;
         position = config.requestClip.localToGlobal(new Point(requestClip.x,requestClip.y));
         var BKG_PADDING:uint = 10;
         if(config.setWidth > -1)
         {
            this.myLabel.width = config.setWidth;
         }
         if(config.setHeight > -1)
         {
            this.myLabel.height = config.setHeight;
         }
         if(config.contents != null)
         {
            this.myLabel.htmlText = config.contents;
         }
         if(config.textFormatting != null)
         {
            this.myLabel.setTextFormat(config.textFormatting);
         }
         this.myBg.height = this.myLabel.height + BKG_PADDING;
         this.myBg.width = this.myLabel.width + BKG_PADDING;
         this.x = position.x + config.offsetPoint.x;
         this.y = position.y + config.offsetPoint.y;
         if(config.showArrow)
         {
            offsetWidth = this.myBg.width * 0.5 - this.myArrow.width;
            offsetHeight = this.myBg.height * 0.5 - this.myArrow.height * 0.5;
            this.myArrow.visible = true;
            switch(config.arrowPosition)
            {
               case ToolTipObject.ARROW_POSITION_RIGHT:
                  this.myArrow.rotation = 90;
                  this.myArrow.x = this.myBg.width - 1;
                  this.myArrow.y = offsetHeight;
                  break;
               case ToolTipObject.ARROW_POSITION_BOTTOM:
                  this.myArrow.rotation = 180;
                  this.myArrow.x = offsetWidth;
                  this.myArrow.y = this.myBg.height - 1;
                  break;
               case ToolTipObject.ARROW_POSITION_LEFT:
                  this.myArrow.rotation = -90;
                  this.myArrow.x = 1;
                  this.myArrow.y = offsetHeight;
                  break;
               default:
                  this.myArrow.x = offsetWidth;
                  this.myArrow.y = 0.5;
            }
         }
      }
      
      public function dispose() : void
      {
         this.m_config = null;
      }
   }
}


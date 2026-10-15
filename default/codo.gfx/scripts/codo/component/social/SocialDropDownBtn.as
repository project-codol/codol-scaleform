package codo.component.social
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.style.ClanGuide;
   import flash.display.MovieClip;
   
   public class SocialDropDownBtn extends UIInteractiveComponent
   {
      
      protected var NORMAL_FRAME:int = 1;
      
      protected var HIGHLIGHT_FRAME:int = 2;
      
      public var myBg:MovieClip;
      
      public var myText:TextField;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mHandler:Function;
      
      public function SocialDropDownBtn()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         isInteractiveEnabled = true;
         this.width = ClanGuide.TOOL_TIP_ITEM_WIDTH;
         this.height = ClanGuide.TOOL_TIP_ITEM_HEIGHT;
         this.myText.textStyle = ClanGuide.styleDropDownText;
         this.myBg.gotoAndStop(this.NORMAL_FRAME);
      }
      
      override public function set width(value:Number) : void
      {
         this.myBg.width = value;
         this.myText.width = value;
         this.mWidth = value;
         myHitArea.width = value;
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function set height(value:Number) : void
      {
         this.myBg.height = value;
         this.myText.height = value;
         this.mHeight = value;
         myHitArea.height = value;
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.myText.text = data as String;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myBg.gotoAndStop(this.HIGHLIGHT_FRAME);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myBg.gotoAndStop(this.NORMAL_FRAME);
      }
   }
}


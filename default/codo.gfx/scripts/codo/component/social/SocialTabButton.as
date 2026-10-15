package codo.component.social
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.style.ButtonGuide;
   import flash.display.MovieClip;
   
   public class SocialTabButton extends UIInteractiveComponent
   {
      
      public static const TYPE_BIG_CLASS_LINKAGE:String = "codo.social.socialTabButton";
      
      public static const TYPE_SMALL_CLASS_LINKAGE:String = "codo.social.smallTabButton";
      
      public static const TYPE_BIG:int = 0;
      
      public static const TYPE_SMALL:int = 1;
      
      private static const OUT_FRAME:int = 1;
      
      private static const OVER_FRAME:int = 6;
      
      private static const SELECTED_FRAME:int = 11;
      
      public var myLabel:TextField;
      
      public var myRedDot:UnsolvedNoteDot;
      
      public var myBg:MovieClip;
      
      private var mLabelText:String;
      
      private var mSelected:Boolean = false;
      
      public function SocialTabButton()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.height = myHitArea.height;
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      public function setDotCount(count:int) : void
      {
         this.myRedDot.visible = count > 0;
         this.myRedDot.setCount(count);
      }
      
      public function setType(type:int) : void
      {
         if(type == TYPE_BIG)
         {
            this.myLabel.textStyle = ButtonGuide.styleFilterCategoryButton;
         }
         else
         {
            this.myLabel.textStyle = ButtonGuide.styleSocialTabButton;
         }
      }
      
      public function setWidth(value:int) : void
      {
         this.myBg.width = value;
         myHitArea.width = value;
         this.myLabel.width = value;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this.mSelected == value)
         {
            return;
         }
         this.mSelected = value;
         if(this.mSelected)
         {
            this.myBg.gotoAndPlay(SELECTED_FRAME);
            gotoAndPlay(SELECTED_FRAME);
         }
         else if(_isFocused)
         {
            this.myBg.gotoAndPlay(OVER_FRAME);
            gotoAndPlay(OVER_FRAME);
         }
         else
         {
            this.myBg.gotoAndPlay(OUT_FRAME);
            gotoAndPlay(OUT_FRAME);
         }
      }
      
      public function set label(value:String) : void
      {
         this.mLabelText = value;
         this.myLabel.text = this.mLabelText;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!this.mSelected)
         {
            gotoAndPlay(OVER_FRAME);
            this.myBg.gotoAndPlay(OVER_FRAME);
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!this.mSelected)
         {
            gotoAndPlay(OUT_FRAME);
            this.myBg.gotoAndPlay(OUT_FRAME);
         }
      }
   }
}


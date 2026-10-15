package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.Dict;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import fsg.util.FsgImageHolder;
   
   public class CharacterRosterGridItem extends UIInteractiveComponent
   {
      
      private static const LABEL_WIDTH:Number = 79;
      
      private static const FADE_DURATION:Number = 0.2;
      
      private static const FOCUS_FRAME_FOCUS_ALPHA:Number = 0.25;
      
      private static const FOCUS_FRAME_UNFOCUS_ALPHA:Number = 0;
      
      private static const BACKGROUND_FOCUS_FRAME:int = 2;
      
      private static const BACKGROUND_UNFOCUS_FRAME:int = 1;
      
      public var myBackground:MovieClip;
      
      public var myCheck:Sprite;
      
      public var myCheckBox:Sprite;
      
      public var myFocusFrame:Sprite;
      
      public var myLabelBG:Sprite;
      
      public var myImage:FsgImageHolder;
      
      public var myLabel:TextField;
      
      private var mIndex:int = 0;
      
      private var mChecked:Boolean = false;
      
      private var mMouseOverCallback:Function;
      
      private var mColorFilter:ColorMatrixFilter;
      
      public function CharacterRosterGridItem()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.width = LABEL_WIDTH;
         this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myLabel.text = LocalizeUtil.localize(Dict.CHARACTER_ROSTER_ACTIVATE).toUpperCase();
         this.myLabel.visible = false;
         this.myFocusFrame.alpha = FOCUS_FRAME_UNFOCUS_ALPHA;
         var matrix:Array = [];
         var value:Number = 0.33;
         matrix = matrix.concat([value,value,value,0,0]);
         matrix = matrix.concat([value,value,value,0,0]);
         matrix = matrix.concat([value,value,value,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.mColorFilter = new ColorMatrixFilter(matrix);
      }
      
      public function set index(idx:int) : void
      {
         this.mIndex = idx;
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
      
      public function set characterImage(imageURL:String) : void
      {
         this.myImage.setImage(imageURL);
      }
      
      public function set checked(c:Boolean) : void
      {
         var filters:Array = null;
         this.mChecked = c;
         this.myLabelBG.visible = this.myLabel.visible = !c;
         this.myCheckBox.visible = this.myCheck.visible = c;
         if(false == this.mChecked)
         {
            filters = [];
            filters.splice(0,1,this.mColorFilter);
            this.myImage.filters = filters;
            this.myBackground.filters = filters;
         }
         else
         {
            this.myImage.filters = null;
            this.myBackground.filters = null;
         }
      }
      
      public function get checked() : Boolean
      {
         return this.mChecked;
      }
      
      override public function setData(data:*) : void
      {
         mData = data;
         if(Boolean(mData))
         {
            this.index = mData.index;
            this.characterImage = mData.imageURL;
            this.checked = mData.checked;
            registerClickEvent(mData.clickEvent,this);
            this.mMouseOverCallback = mData.mouseOverEvent;
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOut();
         this.myBackground.gotoAndStop(BACKGROUND_FOCUS_FRAME);
         TweenLite.killTweensOf(this.myFocusFrame);
         TweenLite.to(this.myFocusFrame,FADE_DURATION,{"alpha":FOCUS_FRAME_FOCUS_ALPHA});
         if(null != this.mMouseOverCallback)
         {
            this.mMouseOverCallback(this);
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myBackground.gotoAndStop(BACKGROUND_UNFOCUS_FRAME);
         TweenLite.killTweensOf(this.myFocusFrame);
         TweenLite.to(this.myFocusFrame,FADE_DURATION,{"alpha":FOCUS_FRAME_UNFOCUS_ALPHA});
      }
   }
}


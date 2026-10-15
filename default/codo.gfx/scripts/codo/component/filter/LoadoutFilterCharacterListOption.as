package codo.component.filter
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.AnimatedArrow;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.DataID;
   import codo.cpp.UiCppNewItems;
   import codo.manager.DataManager;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class LoadoutFilterCharacterListOption extends UIInteractiveComponent
   {
      
      private static const ANIM_DURATION:Number = 0.2;
      
      private static const FOCUS_ALPHA:Number = 0.5;
      
      private static const UNFOCUS_ALPHA:Number = 0.15;
      
      private static const IMAGE_FOCUS_ALPHA:Number = 0.7;
      
      private static const IMAGE_UNFOCUS_ALPHA:Number = 0.35;
      
      public var myLabel:TextField;
      
      public var myBackground:Sprite;
      
      public var myMask:Sprite;
      
      public var myScanlines:Sprite;
      
      public var myArrow:AnimatedArrow;
      
      public var myImage:FsgImageHolder;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mIndex:int = 0;
      
      private var mToggled:Boolean = false;
      
      private var mItemID:int = 0;
      
      public function LoadoutFilterCharacterListOption()
      {
         super();
         isInteractiveEnabled = true;
         this.mWidth = myHitArea.width;
         this.mHeight = myHitArea.height;
         this.myLabel.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.draw();
         this.myBackground.alpha = UNFOCUS_ALPHA;
         this.myScanlines.alpha = IMAGE_UNFOCUS_ALPHA;
         this.myImage.alpha = IMAGE_UNFOCUS_ALPHA;
         addBreadcrumb(0,0,true);
         getBreadcrumb().visible = false;
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      public function set index(idx:int) : void
      {
         this.mIndex = idx;
      }
      
      public function set isNew(isNew:Boolean) : void
      {
         getBreadcrumb().visible = isNew;
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
      
      public function set image(imageURL:String) : void
      {
         this.myImage.setImage(imageURL);
      }
      
      public function set label(label:String) : void
      {
         this.myLabel.text = label;
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      public function set id(id:int) : void
      {
         this.mItemID = id;
      }
      
      public function set toggled(tog:Boolean) : void
      {
         if(tog == this.mToggled)
         {
            return;
         }
         this.mToggled = tog;
         if(true == this.mToggled)
         {
            this.myBackground.alpha = FOCUS_ALPHA;
            this.myScanlines.alpha = IMAGE_FOCUS_ALPHA;
            this.myImage.alpha = IMAGE_FOCUS_ALPHA;
            this.myLabel.fontColor = GlobalGuide.WHITE;
            this.myArrow.show();
         }
         else
         {
            this.myBackground.alpha = UNFOCUS_ALPHA;
            this.myScanlines.alpha = IMAGE_UNFOCUS_ALPHA;
            this.myImage.alpha = IMAGE_UNFOCUS_ALPHA;
            this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            this.myArrow.hide();
         }
      }
      
      public function get toggled() : Boolean
      {
         return this.mToggled;
      }
      
      override protected function onMouseOver() : void
      {
         var prodData:ProductObj = null;
         if(false == this.mToggled)
         {
            TweenLite.killTweensOf(this.myBackground);
            TweenLite.killTweensOf(this.myScanlines);
            TweenLite.killTweensOf(this.myImage);
            TweenLite.to(this.myBackground,ANIM_DURATION,{"alpha":FOCUS_ALPHA});
            TweenLite.to(this.myScanlines,ANIM_DURATION,{"alpha":IMAGE_FOCUS_ALPHA});
            TweenLite.to(this.myImage,ANIM_DURATION,{"alpha":IMAGE_FOCUS_ALPHA});
            this.myLabel.fontColor = GlobalGuide.WHITE;
            this.myArrow.show();
         }
         if(getBreadcrumb().visible && this.mItemID > 0)
         {
            prodData = CFunctionCommonContainer.GetItemInfo(this.mItemID);
            UiCppNewItems.instance.ClearNew(prodData);
            DataManager.getInstance().request(DataID.CHARACTERLOADOUT_CHARACTERS);
         }
      }
      
      override protected function onMouseOut() : void
      {
         if(false == this.mToggled)
         {
            TweenLite.killTweensOf(this.myBackground);
            TweenLite.killTweensOf(this.myScanlines);
            TweenLite.killTweensOf(this.myImage);
            TweenLite.to(this.myBackground,ANIM_DURATION,{"alpha":UNFOCUS_ALPHA});
            TweenLite.to(this.myScanlines,ANIM_DURATION,{"alpha":IMAGE_UNFOCUS_ALPHA});
            TweenLite.to(this.myImage,ANIM_DURATION,{"alpha":IMAGE_UNFOCUS_ALPHA});
            this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            this.myArrow.hide();
         }
      }
      
      private function draw() : void
      {
         this.myMask.width = this.myBackground.width = myHitArea.width = this.mWidth;
         this.myMask.height = this.myLabel.height = myHitArea.height = this.myBackground.height = this.mHeight;
         this.myLabel.width = this.mWidth - this.myLabel.x;
      }
   }
}


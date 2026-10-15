package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class MarketplaceItemPreviewSelectorOption extends UIInteractiveComponent
   {
      
      private static const EMPTY_ALPHA:Number = 0.25;
      
      private static const LABEL_Y:Number = 7;
      
      private static const BUTTON_Y:Number = 6;
      
      public var myLabel:TextField;
      
      public var myRemoveButton:CloseButton;
      
      public var myImage:MovieClip;
      
      private var mItemData:ProductObj;
      
      private var mOnRemoveClickedCallback:Function;
      
      private var mWidth:Number = 0;
      
      private var mHeight:Number = 0;
      
      private var mIconColorOn:ColorTransform;
      
      private var mIconColorOff:ColorTransform;
      
      public function MarketplaceItemPreviewSelectorOption()
      {
         super();
         this.myLabel.y = LABEL_Y;
         this.myRemoveButton.y = BUTTON_Y;
         this.mIconColorOn = new ColorTransform();
         this.mIconColorOn.color = GlobalGuide.WHITE;
         this.mIconColorOff = new ColorTransform();
         this.mIconColorOff.color = GlobalGuide.CODO_BLUE_LIGHT;
         isInteractiveEnabled = true;
         this.myRemoveButton.setClickCallback(this.onRemoveClicked);
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.mWidth = myHitArea.width + this.myRemoveButton.width;
         this.mHeight = myHitArea.height;
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
      
      override public function set height(w:Number) : void
      {
         this.mHeight = w;
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      public function set label(l:String) : void
      {
         this.myLabel.text = l;
      }
      
      public function set itemImage(bitmap:Bitmap) : void
      {
         this.myImage.addChild(bitmap);
         this.myImage.transform.colorTransform = this.mIconColorOff;
      }
      
      public function setEmpty() : void
      {
         this.label = LocalizeUtil.localize(DictMarket.PREVIEW_SLOT_EMPTY);
         this.myLabel.alpha = EMPTY_ALPHA;
         this.myImage.transform.colorTransform = this.mIconColorOn;
         this.myImage.alpha = EMPTY_ALPHA;
         this.myRemoveButton.visible = false;
         this.mItemData = null;
      }
      
      override public function getData() : *
      {
         return this.mItemData;
      }
      
      override public function setData(data:*) : void
      {
         this.mItemData = data as ProductObj;
         this.label = this.mItemData.name;
         this.myLabel.alpha = 1;
         this.myImage.alpha = 1;
         this.myRemoveButton.visible = true;
         this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myImage.transform.colorTransform = this.mIconColorOff;
      }
      
      public function registerOnRemoveClickedCallback(callback:Function) : void
      {
         this.mOnRemoveClickedCallback = callback;
      }
      
      private function draw() : void
      {
         this.myLabel.width = this.mWidth - this.myLabel.x;
         myHitArea.width = this.mWidth - this.myRemoveButton.width;
         myHitArea.height = this.mHeight;
         this.myRemoveButton.x = myHitArea.x + myHitArea.width;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(null != this.mItemData)
         {
            this.myLabel.fontColor = GlobalGuide.WHITE;
            this.myImage.transform.colorTransform = this.mIconColorOn;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(null != this.mItemData)
         {
            this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            this.myImage.transform.colorTransform = this.mIconColorOff;
         }
      }
      
      private function onRemoveClicked() : void
      {
         this.mOnRemoveClickedCallback(this);
      }
   }
}


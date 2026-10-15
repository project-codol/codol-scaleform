package codo.component.loadout
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class SDPlusPerkSlot extends UIInteractiveComponent
   {
      
      public var myTierColorBar:Sprite;
      
      public var myTierColorBarCap:Sprite;
      
      public var myImage:FsgImageHolder;
      
      public var myItemName:TextField;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      public function SDPlusPerkSlot()
      {
         super();
         isInteractiveEnabled = true;
         this.myItemName.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemName.fontColor = GlobalGuide.BLACK;
         this.mWidth = myHitArea.width;
         this.mHeight = myHitArea.height;
         this.draw();
      }
      
      override public function setData(data:*) : void
      {
         var prodData:ProductObj = null;
         super.setData(data);
         prodData = new ProductObj(data);
         this.myTierColorBar.visible = true;
         this.myTierColorBarCap.visible = true;
         this.myItemName.visible = true;
         this.myItemName.text = prodData.name;
         this.myImage.setImage(prodData.imageURL);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[prodData.tier],new <DisplayObject>[this.myTierColorBar]);
         this.myTierColorBar.width = this.myItemName.x + this.myItemName.textWidth + this.myTierColorBarCap.width + GlobalGuide.COMPONENT_PADDING;
         this.myTierColorBarCap.x = this.myTierColorBar.x + this.myTierColorBar.width - this.myTierColorBarCap.width;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      public function draw() : void
      {
         var aspectSize:int = this.mHeight > this.mWidth ? int(this.mHeight) : int(this.mWidth);
         this.myImage.width = aspectSize;
         this.myImage.height = aspectSize;
         var halfWidth:Number = this.mWidth * 0.5;
         var halfHeight:Number = this.mHeight * 0.5;
         this.myImage.x = halfWidth - this.myImage.width * 0.5;
         this.myImage.y = halfHeight - this.myImage.height * 0.5;
         this.myTierColorBar.y = this.mHeight - this.myTierColorBar.height - 15;
         this.myTierColorBarCap.y = this.myTierColorBar.y;
         this.myItemName.y = this.myTierColorBar.y + 2;
         this.myItemName.width = this.mWidth - this.myItemName.x;
      }
   }
}


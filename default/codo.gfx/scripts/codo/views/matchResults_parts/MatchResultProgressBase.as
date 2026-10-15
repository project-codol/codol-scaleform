package codo.views.matchResults_parts
{
   import codo.base.BaseSubElement;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class MatchResultProgressBase extends BaseSubElement
   {
      
      public var myProgressLabel:TextField;
      
      public var myProgressDesc:TextField;
      
      public var myQuantityTF:TextField;
      
      public var myQuantityBkg:Sprite;
      
      public var myFillBar:Sprite;
      
      public var myResultIcon:Sprite;
      
      private var mBarWidth:int;
      
      public function MatchResultProgressBase()
      {
         super();
         this.mBarWidth = this.myFillBar.width;
      }
      
      public function setCopy(title:String, desc:String) : void
      {
         this.myProgressLabel.text = title;
         this.myProgressDesc.htmlText = desc;
      }
      
      public function set progress(progress:Number) : void
      {
         this.myFillBar.width = progress * this.mBarWidth;
      }
      
      public function set rewardQuantity(qty:int) : void
      {
         this.myQuantityTF.text = StringUtil.addZero(qty);
         Logger.print("\n\n\n\nQTY::: " + qty);
         this.enable = qty > 0;
      }
      
      public function set resultIcon(linkage:String) : void
      {
         var iconClass:Class = getDefinitionByName(linkage) as Class;
         while(this.myResultIcon.numChildren > 0)
         {
            this.myResultIcon.removeChildAt(0);
         }
         this.myResultIcon.addChild(new Bitmap(new iconClass() as BitmapData));
      }
      
      override public function set enable(value:Boolean) : void
      {
         super.enable = value;
         this.myQuantityBkg.visible = this.myQuantityTF.visible = value;
      }
      
      public function get inDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
   }
}


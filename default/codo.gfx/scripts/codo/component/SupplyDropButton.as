package codo.component
{
   import codo.constants.MarketMenuData;
   import codo.localization.DictMarket;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   
   public class SupplyDropButton extends Button
   {
      
      public var myDropCount:TextField;
      
      private var mDropID:int;
      
      public function SupplyDropButton()
      {
         super();
         this.myDropCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myDropCount.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myDropCount.alignment = TextStyle.HALIGN_CENTER;
         myLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         myLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myDropCount.width = 200;
         this.myDropCount.height = 200;
         myLabel.width = 200;
         this.setCount(0);
      }
      
      public function setCount(i:int) : void
      {
         this.myDropCount.text = i.toString() + "x";
         this.enabled = i > 0;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.dropID)
         {
            this.dropID = data.dropID;
         }
         if(null != data.count)
         {
            this.setCount(data.count);
         }
      }
      
      public function set dropID(id:int) : void
      {
         this.mDropID = id;
         switch(this.mDropID)
         {
            case MarketMenuData.SUPPLY_DROP_BASIC:
               label = LocalizeUtil.localize(DictMarket.MARKET_SUPPLY_DROP_BASIC).toUpperCase();
               break;
            case MarketMenuData.SUPPLY_DROP_ADVANCED:
               label = LocalizeUtil.localize(DictMarket.MARKET_SUPPLY_DROP_ADVANCED).toUpperCase();
               break;
            case MarketMenuData.SUPPLY_DROP_EVENT:
               label = LocalizeUtil.localize(DictMarket.MARKET_SUPPLY_DROP_EVENT).toUpperCase();
               break;
            default:
               label = "UNSUPPORTED DROP ID: " + this.mDropID;
         }
      }
      
      public function get dropID() : int
      {
         return this.mDropID;
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         alpha = enabled ? 1 : 0.5;
      }
      
      override public function draw() : void
      {
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!mToggled)
         {
            this.myDropCount.fontColor = mTextFocusColor;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!mToggled)
         {
            this.myDropCount.fontColor = mTextUnfocusColor;
         }
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         if(!mToggled)
         {
            this.myDropCount.fontColor = mTextClickColor;
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         if(!mToggled)
         {
            if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY) == true)
            {
               this.myDropCount.fontColor = mTextFocusColor;
            }
         }
      }
   }
}


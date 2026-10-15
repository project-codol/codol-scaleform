package codo.component.playerAccount
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.style.MarketGuide;
   import flash.display.Sprite;
   import flash.geom.Point;
   import fsg.shared.BehaviourClickable;
   import fsg.shared.BehaviourTooltip;
   
   public class PlayerAccountInfoCurrency extends UIInteractiveComponent
   {
      
      private static const PADDING:int = 4;
      
      public var myLabel:TextField;
      
      private var mIcon:Sprite;
      
      private var mToolTip:BehaviourTooltip;
      
      public function PlayerAccountInfoCurrency()
      {
         super();
         this.myLabel.textStyle = MarketGuide.accountInfoCurrencyText;
         enabled = false;
      }
      
      public function enableTooltip(value:Boolean, tooltipStr:String = "") : void
      {
         if(value)
         {
            mClickable = new BehaviourClickable(this);
            mClickable.setEnableMouseHighlight(false);
            this.mToolTip = new BehaviourTooltip(mClickable,tooltipStr,this);
            this.mToolTip.tipOffset = new Point(-10,7);
         }
      }
      
      public function set icon(iconType:Sprite) : void
      {
         this.mIcon = addChild(iconType) as Sprite;
      }
      
      override public function setData(data:*) : void
      {
         var numCount:String = data as String;
         this.myLabel.text = numCount;
         this.myLabel.x = this.mIcon.width + PADDING;
         var middleLine:Number = this.mIcon.y + this.mIcon.height / 2;
         this.myLabel.y = middleLine - this.myLabel.textHeight / 2 - 2;
      }
      
      override public function get width() : Number
      {
         return this.myLabel.textWidth + this.mIcon.width + PADDING;
      }
   }
}


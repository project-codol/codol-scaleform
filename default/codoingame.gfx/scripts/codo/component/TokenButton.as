package codo.component
{
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class TokenButton extends Button
   {
      
      public var myIcon:FsgImageHolder;
      
      public var myWarningIcon:Sprite;
      
      public function TokenButton()
      {
         super();
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         this.setMarketReadyMode(false);
      }
      
      public function setImage(image:String) : void
      {
         if(!ScaleformUtil.isScaleform)
         {
            return;
         }
         this.myIcon.setImage(image);
         this.draw();
      }
      
      public function setMarketReadyMode(isReady:Boolean) : void
      {
         mClickable.setEnabled(isReady);
         this.myWarningIcon.visible = !isReady;
         myLabel.alpha = isReady ? 1 : 0.2;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.image)
         {
            this.setImage(data.image);
         }
      }
      
      public function updateCount(tokenAmount:uint) : void
      {
         tokenAmount = FsgUtil.clamp(tokenAmount,0,999);
         var tokenLabel:String = "X" + String(tokenAmount);
         label = tokenLabel;
      }
      
      override public function draw() : void
      {
         super.draw();
         myLabel.x = this.myIcon.x + this.myIcon.width + GlobalGuide.COMPONENT_PADDING;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
   }
}


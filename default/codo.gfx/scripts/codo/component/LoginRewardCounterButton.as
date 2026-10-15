package codo.component
{
   import codo.common.CFunctionContainer;
   import codo.component.core.ItemCardBase;
   import codo.constants.MarketMenuData;
   import codo.localization.DictMOTD;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.utils.StringUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class LoginRewardCounterButton extends ItemCardBase
   {
      
      private static const ANIMATION_SPEED:Number = 0.2;
      
      public var myMouseOver:Sprite;
      
      public var myBkg:MovieClip;
      
      public var myOutline:MovieClip;
      
      public var myBarMask:Sprite;
      
      public var myQuantityBkg:MovieClip;
      
      public var myQuantityTF:flash.text.TextField;
      
      private var mReadyToShow:Boolean;
      
      private var mForceHide:Boolean;
      
      private var mProdData:ProductObj;
      
      public function LoginRewardCounterButton()
      {
         super();
         this.myBkg.gotoAndStop(1);
         this.myOutline.gotoAndStop(1);
         this.myQuantityBkg.gotoAndStop(2);
         this.myQuantityTF.textColor = GlobalGuide.CODO_BLACK;
         this.myQuantityBkg.visible = this.myQuantityTF.visible = false;
         isInteractiveEnabled = mouseEnabled = mouseChildren = true;
         myItemCategoryTF.alpha = 0;
         this.myBarMask.scaleX = 0;
         this.myMouseOver.alpha = 0;
         TextFieldEx.setVerticalAlign(myAltText,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(myAltTextShadow,TextFieldEx.VALIGN_CENTER);
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.setIsPulseIn();
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.setIsPulseIn(false);
      }
      
      private function setIsPulseIn(pulseIn:Boolean = true) : void
      {
         var targetAlpha:Number = pulseIn ? 0.4 : 0;
         var targetScale:Number = pulseIn ? 1.1 : 1;
         TweenLite.to(this.myMouseOver,ANIMATION_SPEED,{
            "alpha":targetAlpha,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this,ANIMATION_SPEED,{
            "scaleX":targetScale,
            "scaleY":targetScale,
            "ease":Cubic.easeOut
         });
      }
      
      protected function onRewardImageLoaded(e:Event) : void
      {
         var bmpImage:DisplayObject = myItemImageHolder.loadedAsset;
         myItemImageHolder.removeEventListener(Event.COMPLETE,this.onRewardImageLoaded);
         var scale:Number = this.getProduct().isGP ? 0.66 : 0.24;
         bmpImage.scaleX = bmpImage.scaleY = scale;
         bmpImage.x = (this.myBkg.width - bmpImage.width) * 0.5;
         bmpImage.y = (this.myBkg.height - bmpImage.height) * 0.5;
      }
      
      override protected function onIconImageLoaded(e:Event) : void
      {
         myItemIconHolder.removeEventListener(Event.COMPLETE,this.onIconImageLoaded);
         var bmpImage:DisplayObject = myItemIconHolder.loadedAsset;
         bmpImage.width = this.myBkg.width - 30;
         bmpImage.scaleY = bmpImage.scaleX;
         bmpImage.x = (this.myBkg.width - bmpImage.width) * 0.5;
         bmpImage.y = (this.myBkg.height - bmpImage.height) * 0.5;
      }
      
      public function update(reward:MOTDCheckinRewardObj, lastEarned:int, numTotal:int) : void
      {
         this.mProdData = ProductObj.makeItemOrGp(reward.itemID,reward.gp);
         myItemImageHolder.addEventListener(Event.COMPLETE,this.onRewardImageLoaded);
         setData(this.mProdData);
         myItemNameTF.text = DictMOTD.CHECKIN_REWARDS_TITLE;
         myItemCategoryTF.visible = false;
         if(this.mProdData.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            myAltTextShadow.y = myAltText.y = this.myBkg.y;
         }
         var lastClaimed:int = CFunctionContainer.GetCheckinRewardLastClaimed();
         this.myBarMask.scaleX = (lastClaimed + 1) / numTotal;
         if(lastEarned > lastClaimed)
         {
            this.myBkg.play();
            this.myOutline.play();
            this.myQuantityTF.text = StringUtil.addZero(lastEarned - lastClaimed);
            this.myQuantityBkg.visible = this.myQuantityTF.visible = true;
         }
         else
         {
            this.myBkg.gotoAndStop(1);
            this.myOutline.gotoAndStop(1);
            this.myQuantityBkg.visible = this.myQuantityTF.visible = false;
         }
      }
      
      override protected function positionAnimatedEmblem(emblemClip:MovieClip) : void
      {
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         alpha = enabled ? 1 : 0.5;
      }
      
      public function set readyToShow(value:Boolean) : void
      {
         this.mReadyToShow = value;
         this.refreshVisible();
      }
      
      public function set forceHide(value:Boolean) : void
      {
         this.mForceHide = value;
         this.refreshVisible();
      }
      
      private function refreshVisible() : void
      {
         visible = this.mReadyToShow && !this.mForceHide;
      }
      
      public function getProduct() : ProductObj
      {
         return mData as ProductObj;
      }
   }
}


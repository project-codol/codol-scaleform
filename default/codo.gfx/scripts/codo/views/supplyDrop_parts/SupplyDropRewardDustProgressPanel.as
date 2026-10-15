package codo.views.supplyDrop_parts
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.Dict;
   import codo.style.SupplyDropGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.SoundUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   
   public class SupplyDropRewardDustProgressPanel extends UIInteractiveComponent
   {
      
      public static const TYPE_EVENT_CRATE_PATH:String = "supply_drop_event_item_icon";
      
      public static const TYPE_ADVANCED_CRATE_PATH:String = "supply_drop_advanced_item_icon";
      
      public static const TYPE_BASIC_CRATE_PATH:String = "supply_drop_basic_item_icon";
      
      public var myTitleTF:TextField;
      
      public var mySupplyDropDustTF:TextField;
      
      public var myProgressBar:SupplyDropRewardDustProgressBar;
      
      public var myImage:SupplyDropRewardDustProgressBarIcon;
      
      public var myAddSupplyDropTF:TextField;
      
      public function SupplyDropRewardDustProgressPanel()
      {
         super();
         this.myTitleTF.textStyle = SupplyDropGuide.styleSupplyDropDustPanelTitle;
         this.myTitleTF.htmlText = LocalizeUtil.localize(Dict.SUPPLY_DROP_DUST_PANEL_TITLE);
         this.mySupplyDropDustTF.textStyle = SupplyDropGuide.styleSupplyDropDusts;
         this.mySupplyDropDustTF.text = Dict.SUPPLY_DROP_DUSTS;
         this.myAddSupplyDropTF.textStyle = SupplyDropGuide.styleAddSupplyDropTF;
         isInteractiveEnabled = false;
      }
      
      public function initializeAddSupplyDropTF() : void
      {
         this.myAddSupplyDropTF.text = "+1";
         this.myAddSupplyDropTF.alpha = 0;
         this.myAddSupplyDropTF.scaleX = 5;
         this.myAddSupplyDropTF.scaleY = 5;
         this.myAddSupplyDropTF.x = 900;
         this.myAddSupplyDropTF.y = -200;
      }
      
      public function initDusts(val:Number) : void
      {
         this.myProgressBar.stopAnimation();
         this.myProgressBar.dusts = val;
         this.myProgressBar.setDisplayDusts(val);
      }
      
      public function animateToDusts(val:Number, duration:Number, onComplete:Function) : void
      {
         this.myProgressBar.animateToDusts(val,duration,0.5,onComplete);
      }
      
      public function get dusts() : Number
      {
         return this.myProgressBar.dusts;
      }
      
      public function setDustExchangeRatio(val:int) : void
      {
         this.myProgressBar.exchangeRatio = val;
      }
      
      public function set dropID(id:uint) : void
      {
         this.myImage.dropId = id;
      }
      
      public function playSupplyDropIncreaseAnimation(newCrates:int, onCompleteHandler:Function) : void
      {
         this.myImage.showGlow();
         this.myAddSupplyDropTF.text = "+" + newCrates;
         TweenLite.to(this.myAddSupplyDropTF,0.15,{
            "onStart":this.playObtainNewCratesSound,
            "scaleX":1,
            "scaleY":1,
            "x":970,
            "y":15,
            "ease":Linear.easeIn,
            "alpha":1,
            "delay":1.4,
            "onComplete":this.onPlaySupplyDropIncreaseAnimationComplete,
            "onCompleteParams":[onCompleteHandler]
         });
      }
      
      private function playObtainNewCratesSound() : void
      {
         SoundUtil.getInstance().playSound("ui_supplydrop_reward_click_01");
      }
      
      private function onPlaySupplyDropIncreaseAnimationComplete(onCompleteHandler:Function) : void
      {
         TweenLite.to(this.myAddSupplyDropTF,0.2,{
            "scaleX":1.3,
            "scaleY":1.3,
            "x":963,
            "y":3,
            "ease":Linear.easeIn,
            "onComplete":this.onAddSupplyDropTFDropComplete,
            "onCompleteParams":[onCompleteHandler]
         });
      }
      
      private function onAddSupplyDropTFDropComplete(onCompleteHandler:Function) : void
      {
         TweenLite.to(this.myAddSupplyDropTF,0.3,{
            "scaleX":1,
            "scaleY":1,
            "x":970,
            "y":15,
            "ease":Linear.easeOut,
            "onComplete":this.onHoldAddSupplyDropTFComplete,
            "onCompleteParams":[onCompleteHandler]
         });
      }
      
      private function onHoldAddSupplyDropTFComplete(onCompleteHandler:Function) : void
      {
         onCompleteHandler();
      }
      
      public function iconOpen() : void
      {
         this.myImage.open();
      }
      
      public function iconClose(completeCallback:Function) : void
      {
         this.myImage.close(completeCallback);
      }
      
      public function killAllTweens() : void
      {
         TweenLite.killTweensOf(this.myAddSupplyDropTF);
         this.myProgressBar.killAllTweens();
      }
   }
}


package codo.component.loadout
{
   import codo.component.Button;
   import codo.objects.SDPlusUserObj;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgUtil;
   
   public class SDPlusCashTransferFlyout extends MovieClip
   {
      
      public static const TRANSFER_AMOUNT:int = 1000;
      
      public var myButton:Button;
      
      public var myOptionContainer:MovieClip;
      
      public var myOptionFrame:MovieClip;
      
      public var myOptionMount:MovieClip;
      
      public var myMask:MovieClip;
      
      private var mIsOpen:Boolean = false;
      
      private var mOpenYPos:Number = 0;
      
      public function SDPlusCashTransferFlyout()
      {
         super();
         this.myOptionFrame = this.myOptionContainer.getChildByName("myContainer") as MovieClip;
         this.myOptionMount = this.myOptionContainer.getChildByName("myOptionMount") as MovieClip;
         this.myButton.label = LocalizeUtil.param("@UI_HUD_SDPLUS_TRANSFER_FUNDS",[FsgUtil.commaFormatNumber(TRANSFER_AMOUNT)]);
         this.myButton.registerClickEvent(this.onButtonClicked);
         this.myButton.width = 172;
         this.myButton.height = 46;
         this.myOptionContainer.visible = this.mIsOpen;
         this.myOptionContainer.alpha = 0;
      }
      
      public function setUserData(data:Vector.<SDPlusUserObj>) : void
      {
         var optionClip:SDPlusCashTransferFlyoutOption = null;
         this.clearList();
         var optionClass:Class = getDefinitionByName("codo.shared.SDPlusCashTransferFlyoutOption") as Class;
         var curY:Number = 0;
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            optionClip = new optionClass() as SDPlusCashTransferFlyoutOption;
            optionClip.setData(data[i]);
            optionClip.registerClickEvent(this.onOptionClicked,optionClip);
            this.myOptionMount.addChild(optionClip);
            optionClip.y = curY;
            curY += optionClip.height + 5;
         }
         this.myOptionFrame.height = curY + 22;
         this.mOpenYPos = this.myButton.y - this.myOptionFrame.height;
         this.myOptionContainer.y = this.mOpenYPos + this.myOptionFrame.height;
         this.myMask.height = this.myOptionFrame.height + 30;
      }
      
      public function show() : void
      {
         this.mIsOpen = true;
         stage.addEventListener(MouseEvent.CLICK,this.onStageClickHandle);
         this.myOptionContainer.visible = true;
         TweenLite.killTweensOf(this.myOptionContainer);
         TweenLite.to(this.myOptionContainer,0.25,{
            "y":this.mOpenYPos,
            "alpha":1
         });
      }
      
      public function hide() : void
      {
         this.mIsOpen = false;
         TweenLite.killTweensOf(this.myOptionContainer);
         TweenLite.to(this.myOptionContainer,0.25,{
            "y":this.mOpenYPos + this.myOptionFrame.height,
            "alpha":0,
            "onComplete":this.onHideComplete
         });
         if(this.stage != null)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.onStageClickHandle);
         }
      }
      
      private function onHideComplete() : void
      {
         this.myOptionContainer.visible = false;
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         this.myButton.enabled = enabled;
         if(!enabled)
         {
            this.hide();
         }
      }
      
      private function clearList() : void
      {
         while(this.myOptionMount.numChildren > 0)
         {
            this.myOptionMount.removeChildAt(0);
         }
      }
      
      private function onStageClickHandle(cEvt:MouseEvent) : void
      {
         if(this.myOptionFrame.hitTestPoint(stage.mouseX,stage.mouseY) == false)
         {
            this.hide();
         }
      }
      
      private function onButtonClicked() : void
      {
         if(!this.mIsOpen)
         {
            this.show();
         }
         else
         {
            this.hide();
         }
      }
      
      private function onOptionClicked(option:SDPlusCashTransferFlyoutOption) : void
      {
         var userData:SDPlusUserObj = option.getData() as SDPlusUserObj;
         trace("\n\nOPTION CLICKED",userData.userName,"\n\n");
      }
   }
}


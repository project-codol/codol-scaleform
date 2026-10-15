package codo.component.loadout
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.objects.SDPlusUserObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import fsg.util.FsgUtil;
   
   public class SDPlusCashTransferFlyoutOption extends Button
   {
      
      public var mySendButton:Button;
      
      public var myCashBG:MovieClip;
      
      public var myFocusBackground:MovieClip;
      
      public var myCash:TextField;
      
      public function SDPlusCashTransferFlyoutOption()
      {
         super();
         mTextFocusColor = GlobalGuide.WHITE;
         mTextUnfocusColor = 8490904;
         this.mySendButton.label = LocalizeUtil.param("@UI_HUD_SDPLUS_SEND_CASH",[FsgUtil.commaFormatNumber(SDPlusCashTransferFlyout.TRANSFER_AMOUNT)]);
         this.mySendButton.width = 120;
         this.mySendButton.height = 30;
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         myLabel.width = 200;
         this.myCash.textStyle = myLabel.textStyle;
         this.endHighlight();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var userData:SDPlusUserObj = data as SDPlusUserObj;
         myLabel.text = userData.userName;
         this.myCash.text = "$" + FsgUtil.commaFormatNumber(userData.cash);
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         this.myCash.fontColor = mTextFocusColor;
         this.myCashBG.gotoAndStop(OVER_STATE_FRAME);
         this.mySendButton.visible = true;
         this.myFocusBackground.visible = true;
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         this.myCash.fontColor = mTextUnfocusColor;
         this.myCashBG.gotoAndStop(UP_STATE_FRAME);
         this.mySendButton.visible = false;
         this.myFocusBackground.visible = false;
      }
   }
}


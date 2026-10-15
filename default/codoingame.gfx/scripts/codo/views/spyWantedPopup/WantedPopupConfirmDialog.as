package codo.views.spyWantedPopup
{
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.component.Popup;
   import codo.localization.DictSpy;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.hudSpy.PlayerNickname;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class WantedPopupConfirmDialog extends MovieClip
   {
      
      public static const MODE_CONFIRM:int = 0;
      
      public static const MODE_ERROR:int = 1;
      
      public static const ERROR_SUCCESS:int = 0;
      
      public static const ERROR_PLAYER_DEAD:int = 1;
      
      public static const ERROR_PLAYER_ALREADY_WANTED:int = 2;
      
      public static const ERROR_PLAYER_IS_DEPUTY:int = 3;
      
      public var myContainer:Popup;
      
      public var myCancelButton:Button;
      
      public var myConfirmButton:CallToActionButton;
      
      public var myNickname:PlayerNickname;
      
      public var myText:TextField;
      
      private var mConfirmCallback:Function;
      
      private var mCancelCallback:Function;
      
      private var mClientNum:int;
      
      private var mMode:int;
      
      public function WantedPopupConfirmDialog()
      {
         super();
         this.myContainer.width = 681;
         this.myContainer.height = 200;
         this.myContainer.myCloseButton.visible = false;
         this.myContainer.myBackground.gotoAndStop(5);
         this.myContainer.header.title = LocalizeUtil.localize(DictSpy.SKILL_WANTED_ORDER_TITLE);
         this.myConfirmButton.label = LocalizeUtil.localize(DictSpy.SKILL_WANTED_CONFIRM_YES);
         this.myCancelButton.label = LocalizeUtil.localize(DictSpy.SKILL_WANTED_CONFIRM_CANCEL);
         this.myConfirmButton.registerClickEvent(this.onConfirmButtonClick);
         this.myCancelButton.registerClickEvent(this.onCancelButtonClick);
         this.mMode = 0;
      }
      
      public function setWantedPlayerData(playerData:Object) : void
      {
         var trimedName:String = null;
         var indices:Vector.<Point> = null;
         var bound:Rectangle = null;
         this.mClientNum = playerData.clientNum;
         this.myNickname.nickname = playerData.nickname;
         if(ScaleformUtil.isScaleform)
         {
            this.myText.textColor = 6005724;
            trimedName = playerData.name;
            indices = LocalizeUtil.paramTextFieldInput(this.myText,DictSpy.SKILL_WANTED_CONFIRM_TEXT,[trimedName],[GlobalGuide.WHITE],null,null);
            this.myText.x = (this.myContainer.width - this.myText.textWidth) * 0.5 - 20;
            bound = this.myText.getCharBoundaries(indices[0].x);
            this.myNickname.x = this.myText.x + bound.x - this.myNickname.width - 5;
            this.myContainer.height = this.myText.textHeight + 166;
            this.myConfirmButton.y = this.myCancelButton.y = this.myContainer.height;
         }
         else
         {
            this.myNickname.x = 0;
         }
      }
      
      public function setConfirmCallback(callback:Function) : void
      {
         this.mConfirmCallback = callback;
      }
      
      public function setCancelCallback(callback:Function) : void
      {
         this.mCancelCallback = callback;
      }
      
      public function onConfirmButtonClick() : void
      {
         if(this.mConfirmCallback != null)
         {
            this.mConfirmCallback(this.mClientNum);
         }
      }
      
      public function onCancelButtonClick() : void
      {
         if(this.mCancelCallback != null)
         {
            this.mCancelCallback();
         }
      }
      
      public function setMode(mode:int, error:int = 0) : void
      {
         if(mode != this.mMode)
         {
            this.mMode = mode;
            if(this.mMode == MODE_CONFIRM)
            {
               this.myCancelButton.visible = true;
               this.myNickname.visible = true;
            }
            else
            {
               this.myCancelButton.visible = false;
               this.myNickname.visible = false;
               if(error == ERROR_PLAYER_DEAD)
               {
                  this.myText.text = LocalizeUtil.localize(DictSpy.SKILL_WANTED_FAILED_PLAYER_DEAD);
               }
               else if(error == ERROR_PLAYER_ALREADY_WANTED)
               {
                  this.myText.text = LocalizeUtil.localize(DictSpy.SKILL_WANTED_FAILED_ALREADY_WANTED);
               }
               else
               {
                  this.myText.text = LocalizeUtil.localize(DictSpy.SKILL_WANTED_FAILED_ALREADY_DEPUTY);
               }
            }
         }
      }
      
      public function isInErrorMode() : Boolean
      {
         return this.mMode == MODE_ERROR;
      }
   }
}


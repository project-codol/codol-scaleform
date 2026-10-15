package codo.views.spyWantedPopup
{
   import codo.component.CallToActionButton;
   import codo.constants.SpyModeRoleType;
   import codo.localization.DictSpy;
   import codo.utils.LocalizeUtil;
   import codo.utils.SpyUtil;
   import codo.views.hudSpy.PlayerNickname;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class WantedTableEntry extends MovieClip
   {
      
      private static const STATE_ALIVE:int = 1;
      
      private static const STATE_MISSING:int = 2;
      
      private static const STATE_BODYFOUND:int = 3;
      
      public var myBG:MovieClip;
      
      public var myNickname:PlayerNickname;
      
      public var myName:TextField;
      
      public var myButton:CallToActionButton;
      
      public var myOutline:MovieClip;
      
      public var myRoleIcon:MovieClip;
      
      public var myTag:TextField;
      
      private var mPlayerData:Object;
      
      private var mClickCallback:Function;
      
      public function WantedTableEntry()
      {
         super();
         this.myBG.gotoAndStop(1);
         this.myRoleIcon.gotoAndStop(1);
         this.myButton.myLabel.visible = false;
         this.myTag.text = LocalizeUtil.localize(DictSpy.SKILL_WANTED_ALREADY_WANTED);
         this.myTag.visible = false;
      }
      
      public function setCheckButtonClickCallback(callback:Function) : void
      {
         this.mClickCallback = callback;
      }
      
      public function buttonClickCallback() : void
      {
         if(this.mClickCallback != null)
         {
            this.mClickCallback(this.mPlayerData);
         }
      }
      
      public function setData(data:Object, showOutline:Boolean) : void
      {
         this.mPlayerData = data;
         this.myNickname.nickname = data.nickname;
         var frameIndex:int = 1;
         if(data.role == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
         {
            frameIndex = 2;
         }
         else if(data.role == SpyModeRoleType.SPY_ROLE_SPY)
         {
            frameIndex = 3;
         }
         this.myNickname.gotoAndStop(frameIndex);
         this.myName.text = data.name;
         this.myName.textColor = SpyUtil.getRoleColor(data.role);
         this.myOutline.visible = showOutline;
         this.myButton.visible = false;
         if(data.state == STATE_ALIVE)
         {
            this.myBG.gotoAndStop(1);
            if(Boolean(data.isDeputy))
            {
               this.myRoleIcon.gotoAndStop(8);
            }
            else if(data.role == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
            {
               this.myRoleIcon.gotoAndStop(1);
            }
            else if(Boolean(data.isWanted))
            {
               this.myTag.visible = true;
               this.myRoleIcon.visible = false;
            }
            else
            {
               this.myRoleIcon.visible = false;
               this.myButton.visible = true;
               this.myButton.registerClickEvent(this.buttonClickCallback);
            }
         }
         else if(data.state == STATE_MISSING)
         {
            this.myBG.gotoAndStop(2);
            if(data.role == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
            {
               this.myRoleIcon.gotoAndStop(1);
            }
            else
            {
               this.myRoleIcon.visible = false;
            }
         }
         else
         {
            this.myBG.gotoAndStop(3);
            this.myRoleIcon.gotoAndStop(data.role);
         }
      }
   }
}


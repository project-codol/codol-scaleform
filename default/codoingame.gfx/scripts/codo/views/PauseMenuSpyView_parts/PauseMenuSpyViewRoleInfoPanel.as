package codo.views.PauseMenuSpyView_parts
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.SpyModeRoleType;
   import codo.style.SpyHudGuide;
   import flash.display.MovieClip;
   
   public class PauseMenuSpyViewRoleInfoPanel extends UIInteractiveComponent
   {
      
      public var myIcon:MovieClip;
      
      public var myRoleTF:TextField;
      
      public var myRoleDescTF:TextField;
      
      public var myImage:MovieClip;
      
      public var myRoleBg:MovieClip;
      
      public function PauseMenuSpyViewRoleInfoPanel()
      {
         super();
         this.initStage();
      }
      
      public function initStage() : void
      {
         this.myRoleTF.textStyle = SpyHudGuide.PauseMenuSpyViewRoleInfoPanelRoleCivilian;
         this.myRoleDescTF.textStyle = SpyHudGuide.PauseMenuSpyViewRoleInfoPanelRoleDesc;
         this.myRoleDescTF.width = 540;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var role:int = data as int;
         if(role == SpyModeRoleType.SPY_ROLE_NONE)
         {
            role = SpyModeRoleType.SPY_ROLE_CIVILIAN;
         }
         if(role == SpyModeRoleType.SPY_ROLE_SPY)
         {
            this.myRoleTF.textStyle = SpyHudGuide.PauseMenuSpyViewRoleInfoPanelRoleSpy;
         }
         else if(role == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
         {
            this.myRoleTF.textStyle = SpyHudGuide.PauseMenuSpyViewRoleInfoPanelRoleInvestigater;
         }
         else
         {
            this.myRoleTF.textStyle = SpyHudGuide.PauseMenuSpyViewRoleInfoPanelRoleCivilian;
         }
         var roleInfoObj:Object = CFunctionInGameContainer.AS_SpyMode_GetRoleInfo(role);
         this.myRoleTF.text = "@" + roleInfoObj.name;
         this.myRoleDescTF.text = "@" + roleInfoObj.desc;
         this.myIcon.gotoAndStop(role);
         this.myImage.gotoAndStop(role);
         this.myRoleBg.gotoAndStop(role);
      }
   }
}


package codo.views.PauseMenuSpyView_parts
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.constants.SpyModeRoleType;
   import codo.style.SpyHudGuide;
   import flash.display.MovieClip;
   
   public class PauseMenuSpyViewAllRoleDescPanel extends MovieClip
   {
      
      public var myInvestigatorTF:TextField;
      
      public var myCivilianTF:TextField;
      
      public var mySpyTF:TextField;
      
      public var myInvestigatorIcon:MovieClip;
      
      public var myCivilianIcon:MovieClip;
      
      public var mySpyIcon:MovieClip;
      
      public var myInvestigatorDesc:TextField;
      
      public var myCivilianDesc:TextField;
      
      public var mySpyDesc:TextField;
      
      public function PauseMenuSpyViewAllRoleDescPanel()
      {
         super();
         this.myInvestigatorTF.textStyle = SpyHudGuide.PauseMenuAllRoleInvestigator;
         this.myCivilianTF.textStyle = SpyHudGuide.PauseMenuAllRoleCivilian;
         this.mySpyTF.textStyle = SpyHudGuide.PauseMenuAllRoleSpy;
         this.myInvestigatorIcon.gotoAndStop(1);
         this.myCivilianIcon.gotoAndStop(3);
         this.mySpyIcon.gotoAndStop(2);
         this.myInvestigatorDesc.textStyle = SpyHudGuide.PauseMenuAllRoleInvestigatorDesc;
         this.myCivilianDesc.textStyle = SpyHudGuide.PauseMenuAllRoleCivilianDesc;
         this.mySpyDesc.textStyle = SpyHudGuide.PauseMenuAllRoleSpyDesc;
         var investigatorRoleInfo:Object = CFunctionInGameContainer.AS_SpyMode_GetRoleInfo(SpyModeRoleType.SPY_ROLE_INVESTIGATOR);
         var civilianRoleInfo:Object = CFunctionInGameContainer.AS_SpyMode_GetRoleInfo(SpyModeRoleType.SPY_ROLE_CIVILIAN);
         var spyRoleInfo:Object = CFunctionInGameContainer.AS_SpyMode_GetRoleInfo(SpyModeRoleType.SPY_ROLE_SPY);
         this.myInvestigatorTF.text = "@" + investigatorRoleInfo.name;
         this.myCivilianTF.text = "@" + civilianRoleInfo.name;
         this.mySpyTF.text = "@" + spyRoleInfo.name;
         this.myInvestigatorDesc.text = "@" + investigatorRoleInfo.pausemenuDesc;
         this.myCivilianDesc.text = "@" + civilianRoleInfo.pausemenuDesc;
         this.mySpyDesc.text = "@" + spyRoleInfo.pausemenuDesc;
      }
   }
}


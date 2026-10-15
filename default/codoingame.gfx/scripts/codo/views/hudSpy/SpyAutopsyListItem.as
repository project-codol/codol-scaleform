package codo.views.hudSpy
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.SpyModeRoleType;
   import codo.localization.DictSpy;
   import codo.style.SpyHudGuide;
   import codo.utils.SpyUtil;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   
   public class SpyAutopsyListItem extends UIInteractiveComponent
   {
      
      public var myTimeTF:TextField;
      
      public var myAutopsyTF:TextField;
      
      public var myRoleTF:TextField;
      
      public var myInspectorIcon:PlayerNickname;
      
      public var myVictimIcon:PlayerNickname;
      
      public var myRoleIcon:MovieClip;
      
      public function SpyAutopsyListItem()
      {
         super();
         this.myTimeTF.textStyle = SpyHudGuide.SpyAutopsyListTime;
         this.myAutopsyTF.textStyle = SpyHudGuide.SpyAutopsyListCivilian;
         this.myRoleTF.textStyle = SpyHudGuide.SpyAutopsyListCivilian;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var min:int = data.time / 60;
         var sec:int = data.time % 60;
         this.myTimeTF.text = StringUtil.addZero(min) + ":" + StringUtil.addZero(sec);
         this.myAutopsyTF.text = DictSpy.AUTOPSY_LIST_AUTOPSY;
         this.myRoleIcon.gotoAndStop(data.victimRole);
         this.myRoleTF.text = "[       " + SpyUtil.getLocalizedRoleName(data.victimRole) + "]";
         if(data.victimRole == SpyModeRoleType.SPY_ROLE_SPY)
         {
            this.myRoleTF.textStyle = SpyHudGuide.SpyAutopsyListSpy;
         }
         if(data.victimRole == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
         {
            this.myRoleTF.textStyle = SpyHudGuide.SpyAutopsyListInvestigator;
         }
         else
         {
            this.myRoleTF.textStyle = SpyHudGuide.SpyAutopsyListCivilian;
         }
         this.myInspectorIcon.nickname = (data.inspector + 1).toString();
         this.myVictimIcon.nickname = (data.victim + 1).toString();
      }
   }
}


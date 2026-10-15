package codo.component.career
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.objects.OnboardingChecklistObj;
   import flash.display.Sprite;
   
   public class ChallengeChecklist extends BaseSubElement
   {
      
      public var myListHolder:Sprite;
      
      public var myImp:Object;
      
      public function ChallengeChecklist()
      {
         super();
         if(Boolean(CFunctionCommonContainer.Dvar_GetBool("dailyChanllengeDisabled")))
         {
            this.myImp = new ChallengeChecklistImp(this);
         }
         else
         {
            this.myImp = new ChallengeChecklistImpOld(this);
         }
      }
      
      public function setData(data:Vector.<OnboardingChecklistObj>, useVerticalDisplay:Boolean = false, showHeaderLabel:Boolean = true, isGameLobbyView:Boolean = false) : void
      {
         this.myImp.setData(data,useVerticalDisplay,showHeaderLabel,isGameLobbyView);
      }
   }
}


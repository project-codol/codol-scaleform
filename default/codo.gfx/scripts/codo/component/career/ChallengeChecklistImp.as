package codo.component.career
{
   import codo.objects.OnboardingChecklistObj;
   import flash.utils.getDefinitionByName;
   
   public class ChallengeChecklistImp
   {
      
      private static const MARGIN_HORIZONTAL:Number = 12;
      
      private var mTarget:ChallengeChecklist;
      
      public function ChallengeChecklistImp(target:ChallengeChecklist)
      {
         super();
         this.mTarget = target;
         this.mTarget.visible = false;
      }
      
      public function setData(data:Vector.<OnboardingChecklistObj>, useVerticalDisplay:Boolean = false, showHeaderLabel:Boolean = true, isGameLobbyView:Boolean = false) : void
      {
         var item:ChallengeChecklistBoard = null;
         var curPos:Number = NaN;
         var child:ChallengeChecklistBoard = null;
         while(this.mTarget.myListHolder.numChildren > 0)
         {
            child = this.mTarget.myListHolder.removeChildAt(0) as ChallengeChecklistBoard;
            if(child != null)
            {
               child.dispose();
            }
         }
         var linkage:String = "codo.shared.career.ChallengeChecklistBoard";
         var cls:Class = getDefinitionByName(linkage) as Class;
         curPos = 0;
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            item = this.mTarget.myListHolder.addChild(new cls()) as ChallengeChecklistBoard;
            item.showHeaderLabel = showHeaderLabel;
            item.isGameLobbyView = isGameLobbyView;
            item.setData(data[i]);
            if(useVerticalDisplay)
            {
               item.y = curPos;
               curPos += item.height;
            }
            else
            {
               item.x = curPos;
               curPos += item.width + MARGIN_HORIZONTAL;
            }
         }
         this.mTarget.active();
      }
   }
}


package codo.component.career
{
   import codo.component.factory.ButtonFactory;
   import codo.component.home.HomeChallengeListItem;
   import codo.component.onboarding.OnboardingChallengesCheckbox;
   import codo.constants.GameInfo;
   import codo.objects.OnboardingCheckboxObj;
   import codo.objects.OnboardingChecklistObj;
   import com.greensock.TweenLite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class ChallengeChecklistImpOld
   {
      
      private static const NUM_COLS:int = 2;
      
      private static const PREVIEW_BOX_X_OFFSET:Number = 40;
      
      private static const PREVIEW_BOX_Y_OFFSET:Number = 75;
      
      private var mTarget:ChallengeChecklist;
      
      private var mChallengePreview:HomeChallengeListItem;
      
      private var mPreviewShowing:Boolean = false;
      
      public function ChallengeChecklistImpOld(target:ChallengeChecklist)
      {
         super();
         this.mTarget = target;
         this.mChallengePreview = ButtonFactory.BUILD_HOME_CHALLENGE_LIST_ITEM();
         this.mTarget.addChild(this.mChallengePreview);
         this.mChallengePreview.visible = false;
         this.mChallengePreview.alpha = 0;
         this.mTarget.visible = false;
      }
      
      public function setData(data:Vector.<OnboardingChecklistObj>, useVerticalDisplay:Boolean = false, showHeaderLabel:Boolean = true, isGameLobbyView:Boolean = false) : void
      {
         var item:ChallengeChecklistItem = null;
         var column:int = 0;
         var row:int = 0;
         var curY:Number = NaN;
         var child:ChallengeChecklistItem = null;
         while(this.mTarget.myListHolder.numChildren > 0)
         {
            child = this.mTarget.myListHolder.removeChildAt(0) as ChallengeChecklistItem;
            if(child != null)
            {
               child.dispose();
            }
         }
         var linkage:String = "codo.shared.career.ChallengeChecklistItem";
         var cls:Class = getDefinitionByName(linkage) as Class;
         curY = 0;
         var curRow:int = 0;
         var tallest:Number = 0;
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            item = this.mTarget.myListHolder.addChild(new cls()) as ChallengeChecklistItem;
            item.registerCheckboxFocusEvent(this.onCheckboxFocused);
            item.registerCheckboxUnfocusEvent(this.onCheckboxUnfocused);
            item.showHeaderLabel = showHeaderLabel;
            item.isGameLobbyView = isGameLobbyView;
            item.setData(data[i]);
            if(useVerticalDisplay)
            {
               item.y = curY;
               curY += item.height - 1;
            }
            else
            {
               column = i % NUM_COLS;
               row = i / NUM_COLS;
               if(row > curRow)
               {
                  curRow = row;
                  curY = tallest + 12;
                  tallest = 0;
               }
               if(item.height > tallest)
               {
                  tallest = item.height;
               }
               item.x = (item.width + 12) * column;
               item.y = curY;
            }
         }
         this.mTarget.active();
      }
      
      private function onStageMouseMoveHandle(cEvt:MouseEvent) : void
      {
         var localMousePoint:Point = null;
         var mousePoint:Point = new Point(this.mTarget.stage.mouseX,this.mTarget.stage.mouseY);
         localMousePoint = this.mTarget.globalToLocal(mousePoint);
         this.mChallengePreview.x = localMousePoint.x + PREVIEW_BOX_X_OFFSET;
         var temp:Number = localMousePoint.y - PREVIEW_BOX_Y_OFFSET - this.mChallengePreview.height * 0.5;
         if(temp + this.mChallengePreview.height > GameInfo.DEFAULT_HEIGHT)
         {
            temp = GameInfo.DEFAULT_HEIGHT - this.mChallengePreview.height;
         }
         this.mChallengePreview.y = temp;
      }
      
      private function onCheckboxFocused(checkbox:OnboardingChallengesCheckbox) : void
      {
         var checkboxData:OnboardingCheckboxObj = checkbox.getData() as OnboardingCheckboxObj;
         this.mChallengePreview.setData(checkboxData.challenge);
         if(this.mPreviewShowing)
         {
            return;
         }
         this.mChallengePreview.visible = true;
         this.mPreviewShowing = true;
         TweenLite.killTweensOf(this.mChallengePreview);
         TweenLite.to(this.mChallengePreview,0.25,{
            "alpha":1,
            "delay":0.15
         });
         if(this.mTarget.stage.hasEventListener(MouseEvent.MOUSE_MOVE) == false)
         {
            this.mTarget.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         }
         this.mTarget.setChildIndex(this.mChallengePreview,this.mTarget.numChildren - 1);
      }
      
      private function onCheckboxUnfocused(checkbox:OnboardingChallengesCheckbox) : void
      {
         this.mPreviewShowing = false;
         TweenLite.killTweensOf(this.mChallengePreview);
         TweenLite.to(this.mChallengePreview,0.25,{
            "alpha":0,
            "onComplete":this.onHideComplete,
            "delay":0.15
         });
      }
      
      private function onHideComplete() : void
      {
         this.mTarget.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         this.mChallengePreview.visible = false;
      }
   }
}


package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.objects.ChallengeRewardObj;
   import codo.objects.OnboardingChecklistObj;
   import codo.objects.ProductObj;
   import codo.objects.ResultObj;
   import codo.style.GlobalGuide;
   import codo.style.TutorialGuide;
   import codo.views.onboarding_parts.ClaimOnboardingRewardContent;
   import flash.display.Shape;
   
   public class ClaimOnboardingRewardView extends BaseView
   {
      
      private var mIndexFeature:int;
      
      private var mRewardIndex:int;
      
      public var myContent:ClaimOnboardingRewardContent;
      
      public function ClaimOnboardingRewardView()
      {
         super();
         if(isDebugMode)
         {
            this.routeData = {};
         }
         var rectangle:Shape = new Shape();
         rectangle.graphics.beginFill(GlobalGuide.CODO_BLACK,TutorialGuide.OVERLAY_ALPHA);
         rectangle.graphics.drawRect(0,0,GameInfo.DEFAULT_WIDTH,GameInfo.DEFAULT_HEIGHT);
         rectangle.graphics.endFill();
         addChildAt(rectangle,0);
         this.myContent.animatedInCallback = this.doRequest;
         this.myContent.animatedOutCallback = this.closePopupView;
      }
      
      override public function set routeData(data:*) : void
      {
         var reward:ChallengeRewardObj = null;
         var GET_INFO:Function = CFunctionCommonContainer.GetItemInfo;
         var dataObj:OnboardingChecklistObj = data as OnboardingChecklistObj;
         var productsToClaim:Vector.<ProductObj> = new Vector.<ProductObj>(0);
         var prodIDs:Array = isDebugMode ? [60217,60136,60132] : [];
         var i:int = 0;
         if(!isDebugMode)
         {
            while(i < dataObj.rewards.length)
            {
               reward = dataObj.rewards[i];
               if(reward.type == ChallengeRewardObj.REWARD_TYPE_ITEM)
               {
                  prodIDs.push(reward.entityId);
               }
               i++;
            }
            i = 0;
         }
         if(isDebugMode)
         {
            dataObj = new OnboardingChecklistObj();
            dataObj.gpValue = 0;
         }
         if(dataObj.gpValue > 0)
         {
            this.myContent.gpValue = dataObj.gpValue;
         }
         else
         {
            this.mIndexFeature = isDebugMode ? 60132 : dataObj.featuredIdx;
            for(prodIDs.sort(this.sortByIsFeatured); i < prodIDs.length; )
            {
               productsToClaim[i] = GET_INFO(prodIDs[i]);
               i++;
            }
            this.myContent.data = productsToClaim;
         }
         this.mRewardIndex = dataObj.rewardIndex;
      }
      
      private function sortByIsFeatured(a:Object, b:Object) : int
      {
         var indexA:int = a == this.mIndexFeature ? 1 : 0;
         var indexB:int = b == this.mIndexFeature ? 1 : 0;
         return indexB - indexA;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myContent.active();
      }
      
      private function doRequest() : void
      {
         if(!isDebugMode)
         {
            DataManager.request(DataID.CLAIM_ONBOARDING_REWARD,{"index":this.mRewardIndex},this.onClaimOnboardingRewardComplete);
         }
         else
         {
            this.onClaimOnboardingRewardComplete({"result":true});
         }
      }
      
      private function onClaimOnboardingRewardComplete(cRes:Object) : void
      {
         var success:Boolean = cRes.result == ResultObj.RESULT_SUCCESS;
         this.myContent.onClaimComplete(success);
         if(success)
         {
            this.broadcast(BCEvent.EVT_REFRESH_CHALLENGES);
         }
      }
      
      private function closePopupView() : void
      {
         if(isDebugMode)
         {
            this.routeData = {};
            this.showView();
         }
         else
         {
            this.broadcast(BCEvent.CLOSE_ALL_POPUP);
         }
      }
   }
}


package codo.component.onboarding
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CallToActionButton;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.PageID;
   import codo.manager.EventManager;
   import codo.objects.OnboardingCheckboxObj;
   import codo.objects.OnboardingChecklistChallengeObj;
   import codo.objects.OnboardingChecklistObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Bounce;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import fsg.util.ImageHolderSimple;
   
   public class OnboardingChallengesChecklistListItem extends UIInteractiveComponent
   {
      
      public var myListHolder:Sprite;
      
      public var myClaimButton:Sprite;
      
      public var mClaimButton:CallToActionButton;
      
      public var myClaimedIcon:Sprite;
      
      public var myRewardGPTF:TextField;
      
      public var myGPEarned:Sprite;
      
      public var myGPUnEarned:Sprite;
      
      public var myRewardUnearned:ImageHolderSimple;
      
      public var myRewardEarned:ImageHolderSimple;
      
      public var myRewardBkgProgressMask:Sprite;
      
      public var myRewardBkgProgress:Sprite;
      
      public var myBaseBkg:MovieClip;
      
      public var myOnboardingChecklistBkg:Sprite;
      
      public var myBundleDisplay:Sprite;
      
      private var mUseSmallRenderer:Boolean = false;
      
      private var mAnimateProgress:Boolean = false;
      
      private var mProgressStart:Number = 0;
      
      private var mProgressEnd:Number = 0;
      
      private var mInitWidth:Number;
      
      private var mHighlightChallenge:OnboardingChecklistChallengeObj;
      
      private var mMaskDimensions:Point;
      
      private var mGlower:GlowFilter;
      
      public function OnboardingChallengesChecklistListItem()
      {
         super();
         this.mClaimButton = this.myClaimButton.getChildAt(0) as CallToActionButton;
         this.mClaimButton.width = 110;
         this.mClaimButton.height = 32;
         this.mClaimButton.label = "@SF_UI_CLAIM";
         this.mClaimButton.registerClickEvent(this.onClaimClicked);
         this.mInitWidth = this.myRewardBkgProgressMask.width;
         this.myGPEarned.visible = this.myGPUnEarned.visible = false;
         this.mGlower = new GlowFilter(GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,0.5,20,20);
         this.myBundleDisplay.visible = false;
         this.onProgressAnimComplete();
      }
      
      private function set bundleItemNum(num:int) : void
      {
         var tf:TextField = this.myBundleDisplay.getChildByName("myValueTF") as TextField;
         tf.text = num.toString();
         this.myBundleDisplay.visible = true;
      }
      
      public function setHighlightChallenge(chal:OnboardingChecklistChallengeObj) : void
      {
         this.mHighlightChallenge = chal;
      }
      
      override public function setData(data:*) : void
      {
         var checklistData:OnboardingChecklistObj = null;
         var prodObj:ProductObj = null;
         super.setData(data);
         checklistData = mData as OnboardingChecklistObj;
         if(checklistData == null)
         {
            return;
         }
         this.myRewardGPTF.alpha = checklistData.complete ? 1 : 0.7;
         if(!checklistData.claimed)
         {
            this.mClaimButton.enabled = this.myClaimButton.visible = checklistData.complete && checklistData.challenges.length > 0;
            this.myClaimedIcon.visible = false;
            this.myClaimButton.scaleX = this.myClaimButton.scaleY = 0;
         }
         else
         {
            this.myClaimedIcon.visible = true;
            this.myClaimedIcon.scaleX = this.myClaimedIcon.scaleY = 0;
            TweenLite.to(this.myClaimedIcon,1,{
               "scaleX":1,
               "scaleY":1,
               "ease":Bounce.easeOut
            });
            this.myClaimButton.visible = false;
         }
         this.myRewardEarned.addEventListener(Event.COMPLETE,this.onImageLoaded);
         if(checklistData.gpValue > 0)
         {
            this.myRewardGPTF.visible = true;
            this.myRewardGPTF.text = checklistData.gpValue.toString();
            this.myGPEarned.visible = this.myGPUnEarned.visible = true;
         }
         else
         {
            prodObj = CFunctionCommonContainer.GetItemInfo(checklistData.rewards[checklistData.featuredIdx].entityId);
            this.myRewardEarned.setImage(prodObj.imageURL);
            this.myRewardUnearned.setImage(prodObj.imageURL);
            this.myRewardGPTF.visible = this.myGPEarned.visible = this.myGPUnEarned.visible = false;
            if(checklistData.rewards.length > 1)
            {
               this.bundleItemNum = checklistData.rewards.length;
            }
         }
         this.buildList();
         this.updateProgress();
      }
      
      private function onProgressAnimComplete() : void
      {
         if(this.mClaimButton.enabled)
         {
            this.myClaimButton.scaleX = this.myClaimButton.scaleY = 1;
            TweenMax.to(this.myClaimButton,0.3,{
               "scaleX":1.05,
               "scaleY":1.05,
               "yoyo":true,
               "repeat":-1
            });
            TweenMax.to(this.mClaimButton,0.4,{
               "glowFilter":this.mGlower,
               "yoyo":true,
               "repeat":-1
            });
         }
      }
      
      private function updateProgress() : void
      {
         var startWidth:Number = this.mInitWidth * this.mProgressStart;
         var endWidth:Number = this.mInitWidth * this.mProgressEnd;
         var len:int = this.myListHolder.numChildren;
         var i:int = 0;
         var delay:Number = 0;
         if(this.mAnimateProgress)
         {
            this.myRewardBkgProgress.width = this.myRewardBkgProgressMask.width = startWidth;
            TweenLite.to(this.myRewardBkgProgressMask,1,{
               "width":endWidth,
               "ease":Cubic.easeOut,
               "delay":0.5,
               "onComplete":this.onProgressAnimComplete
            });
            TweenLite.to(this.myRewardBkgProgress,1,{
               "width":endWidth,
               "ease":Cubic.easeOut
            });
         }
         else
         {
            this.myRewardBkgProgress.width = this.myRewardBkgProgressMask.width = endWidth;
            this.onProgressAnimComplete();
         }
         while(i < len)
         {
            delay += i * 0.03;
            OnboardingChallengesCheckbox(this.myListHolder.getChildAt(i)).animateIn(delay,this.mAnimateProgress);
            i++;
         }
      }
      
      public function set animateProgress(doAnim:Boolean) : void
      {
         this.mAnimateProgress = doAnim;
      }
      
      public function set useSmallRenderer(useSmall:Boolean) : void
      {
         this.mUseSmallRenderer = useSmall;
         if(useSmall)
         {
            gotoAndStop(2);
            this.myBaseBkg.gotoAndStop(2);
            this.mInitWidth = this.myRewardBkgProgressMask.width;
            this.myClaimButton.x = this.myRewardBkgProgressMask.x + this.mInitWidth * 0.5;
         }
         else
         {
            gotoAndStop(1);
            this.myBaseBkg.gotoAndStop(1);
         }
         this.mMaskDimensions = new Point(this.myBaseBkg.width,this.myBaseBkg.height);
      }
      
      private function buildList() : void
      {
         var challenge:OnboardingChecklistChallengeObj = null;
         var item:OnboardingChallengesCheckbox = null;
         var nextItem:OnboardingChallengesCheckbox = null;
         var progress:String = null;
         var checkboxData:OnboardingCheckboxObj = null;
         var justCompleted:Boolean = false;
         var fillStart:Number = 0;
         var fillEnd:Number = 0;
         var fillTotal:Number = 0;
         var challenges:Array = OnboardingChecklistObj(mData).challenges;
         var len:int = int(challenges.length);
         var i:int = 0;
         var cls:Class = getDefinitionByName("codo.shared.onboarding.OnboardingChallengesCheckbox") as Class;
         for(var listHeight:int = 0; i < len; )
         {
            challenge = challenges[i];
            fillStart += challenge.startValue / challenge.target;
            fillEnd += challenge.progress / challenge.target;
            fillTotal += 1;
            if(challenge.target > 1)
            {
               progress = challenge.progress.toString().concat("/",challenge.target.toString());
            }
            else
            {
               progress = null;
            }
            justCompleted = challenge.getFinished() && challenge.startValue < challenge.target && !challenge.uiChallenge;
            checkboxData = new OnboardingCheckboxObj();
            checkboxData.name = challenge.name;
            checkboxData.finished = challenge.getFinished();
            checkboxData.animateIn = justCompleted;
            checkboxData.progress = progress;
            checkboxData.challenge = challenge;
            item = this.myListHolder.addChild(new cls()) as OnboardingChallengesCheckbox;
            item.setData(checkboxData);
            if(challenge == this.mHighlightChallenge)
            {
               item.myLabel.textColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
               item.myValue.textColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
            }
            listHeight += item.myOutline.height + 8;
            if(i > 0)
            {
               nextItem = this.myListHolder.getChildAt(i - 1) as OnboardingChallengesCheckbox;
               item.y = nextItem.y + nextItem.height;
            }
            i++;
         }
         this.mProgressStart = fillStart / fillTotal;
         this.mProgressEnd = fillEnd / fillTotal;
      }
      
      private function onImageLoaded(e:Event) : void
      {
         this.myRewardEarned.removeEventListener(Event.COMPLETE,this.onImageLoaded);
         var endX:int = -7;
         var endY:int = 24;
         var endScale:Number = 0.52;
         this.myRewardGPTF.visible = false;
         if(this.mUseSmallRenderer)
         {
            endScale = 0.44;
            endX = -6;
            endY = 44;
         }
         this.myRewardEarned.y = this.myRewardUnearned.y = endY;
         this.myRewardEarned.x = this.myRewardUnearned.x = endX;
         this.myRewardEarned.scaleX = this.myRewardUnearned.scaleX = endScale;
         this.myRewardEarned.scaleY = this.myRewardUnearned.scaleY = endScale;
      }
      
      private function onClaimClicked() : void
      {
         var checklistData:OnboardingChecklistObj = mData as OnboardingChecklistObj;
         EventManager.getInstance().broadcast(BCEvent.EVT_ROUTE_TO_PAGE,{
            "page":PageID.ONBOARDING_CLAIM_CHALLENGE_REWARD,
            "routeData":checklistData
         });
         TweenMax.killAll();
      }
      
      override public function get height() : Number
      {
         return this.myOnboardingChecklistBkg.height;
      }
   }
}


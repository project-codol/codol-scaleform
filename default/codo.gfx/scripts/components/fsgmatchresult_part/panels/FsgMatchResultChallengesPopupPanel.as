package components.fsgmatchresult_part.panels
{
   import codo.component.MatchResultChallengeListItem;
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.component.career.ChallengeChecklist;
   import codo.component.onboarding.OnboardingChallengeChecklist;
   import codo.localization.Dict;
   import codo.localization.DictChallenge;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.DailyChallengeObj;
   import codo.objects.OnboardingChecklistObj;
   import codo.objects.ScrollListSettings;
   import codo.objects.WeeklyChallengeObj;
   import codo.services.ChallengeService;
   import codo.style.GlobalGuide;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   import flash.display.MovieClip;
   
   public class FsgMatchResultChallengesPopupPanel extends FsgMatchResultPopupPanelBase
   {
      
      private static const LIST_WIDTH:Number = 428;
      
      private static const LIST_HEIGHT:Number = 770;
      
      public var myChecklistPanel:OnboardingChallengeChecklist;
      
      public var myNoChallengesText:TextField;
      
      public var myChallengeChecklist:ChallengeChecklist;
      
      public var myScrollList:ScrollList;
      
      public var myBG:MovieClip;
      
      public var mIsFirstTime:Boolean = true;
      
      private var _checklist:Vector.<OnboardingChecklistObj>;
      
      public function FsgMatchResultChallengesPopupPanel()
      {
         super();
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.itemPadding = GlobalGuide.COMPONENT_PADDING;
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.useNavArrows = false;
         listSettings.autoSize = false;
         this.myScrollList.settings = listSettings;
         this.myScrollList.settings.buildGridItemRenderMethod = BUILD_MATCH_RESULT_CHALLENGE_LIST_ITEM;
         this.myScrollList.width = LIST_WIDTH;
         this.myScrollList.height = LIST_HEIGHT;
         this.myBG.width = LIST_WIDTH + 40;
         this.myBG.height = LIST_HEIGHT + 40;
         this.myChecklistPanel.animateProgress = true;
         this.myNoChallengesText.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myNoChallengesText.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myNoChallengesText.fontColor = GlobalGuide.GRAY_80;
         this.myNoChallengesText.width = 500;
         this.myNoChallengesText.text = "@SF_UI_NO_RECENT_CHALLENGES";
         this.myChecklistPanel.deactive();
         this.myChallengeChecklist.visible = false;
      }
      
      public static function BUILD_MATCH_RESULT_CHALLENGE_LIST_ITEM() : MatchResultChallengeListItem
      {
         return new MatchResultChallengeListItem();
      }
      
      override public function active() : void
      {
         super.active();
         if(this.mIsFirstTime && this._checklist != null)
         {
            this.myChecklistPanel.setData(this._checklist,true);
            this.mIsFirstTime = false;
            playSound("ui_contracts_click_01");
         }
      }
      
      public function setChallengesData(challenges:Vector.<ChallengeBaseObj>, showChallenges:Boolean, showChecklist:Boolean) : void
      {
         var objVec:Vector.<Object> = null;
         var dailyChallenges:Vector.<Object> = null;
         var weeklyChallenges:Vector.<Object> = null;
         var veteranChallenges:Vector.<Object> = null;
         var i:uint = 0;
         var allCategories:Vector.<Object> = null;
         var obj:Object = null;
         this.myScrollList.visible = this.myBG.visible = showChallenges;
         this.myNoChallengesText.visible = false;
         if(showChecklist)
         {
            this._checklist = ChallengeService.getInstance().GetOnboardingChecklist();
            this.myChecklistPanel.y = 18;
            this.myChecklistPanel.setData(this._checklist,true);
            this.myChecklistPanel.active();
         }
         else
         {
            this.myChecklistPanel.deactive();
         }
         if(showChallenges)
         {
            objVec = DataUtil.copyElems(new Vector.<Object>(0),challenges);
            dailyChallenges = new Vector.<Object>();
            weeklyChallenges = new Vector.<Object>();
            veteranChallenges = new Vector.<Object>();
            for(i = 0; i < objVec.length; i++)
            {
               obj = objVec[i];
               if(obj is DailyChallengeObj)
               {
                  dailyChallenges.push(obj);
               }
               else if(obj is WeeklyChallengeObj)
               {
                  weeklyChallenges.push(obj);
               }
               else
               {
                  veteranChallenges.push(obj);
               }
            }
            allCategories = new Vector.<Object>();
            if(dailyChallenges.length > 0)
            {
               allCategories.push(LocalizeUtil.localize(Dict.DAILY_CHALLENGES) + "(" + dailyChallenges.length.toString() + ")");
               allCategories = allCategories.concat(dailyChallenges);
            }
            if(weeklyChallenges.length > 0)
            {
               allCategories.push(LocalizeUtil.localize(DictChallenge.WEEKLY_CHALLENGES) + "(" + weeklyChallenges.length.toString() + ")");
               allCategories = allCategories.concat(weeklyChallenges);
            }
            if(veteranChallenges.length > 0)
            {
               allCategories.push(LocalizeUtil.localize(DictChallenge.CHALLENGES_CAREER) + "(" + veteranChallenges.length.toString() + ")");
               allCategories = allCategories.concat(veteranChallenges);
            }
            this.myScrollList.addItemsByVector(allCategories);
            if(allCategories.length > 0)
            {
               this.myScrollList.addItemsByVector(allCategories);
            }
            else
            {
               this.myScrollList.visible = this.myBG.visible = false;
            }
            if(showChecklist)
            {
               this.myChallengeChecklist.visible = false;
               this.myBG.x = this.myChecklistPanel.x + this.myChecklistPanel.width + 20;
               this.myScrollList.x = this.myBG.x + 20;
            }
            else
            {
               this.myChallengeChecklist.setData(ChallengeService.getInstance().GetChallengeChecklist(),true,false);
               this.myChallengeChecklist.visible = true;
            }
         }
      }
      
      public function displayNoChallengesAvailable() : void
      {
         this.myNoChallengesText.y = this.myScrollList.y + (this.myScrollList.height - this.myNoChallengesText.textHeight) * 0.5;
         this.myBG.visible = this.myScrollList.visible = this.myChecklistPanel.visible = false;
         this.myNoChallengesText.visible = true;
         this.myNoChallengesText.x = 0;
      }
   }
}


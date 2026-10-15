package codo.component.onboarding
{
   import codo.base.BaseSubElement;
   import codo.component.TextField;
   import codo.localization.Dict;
   import codo.objects.OnboardingChecklistChallengeObj;
   import codo.objects.OnboardingChecklistObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class OnboardingChallengeChecklist extends BaseSubElement
   {
      
      public var myLabel:TextField;
      
      private var mListHolder:Sprite;
      
      private var mUseSmallRenderer:Boolean = false;
      
      private var mAnimateProgress:Boolean = false;
      
      public function OnboardingChallengeChecklist()
      {
         super();
         this.myLabel.width = 463;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myLabel.text = LocalizeUtil.localize(Dict.ONBOARDING_CHECKLIST);
         this.mListHolder = addChild(new Sprite()) as Sprite;
         this.mListHolder.y = this.myLabel.height;
         deactive();
      }
      
      public function set useSmallRenderer(useSmall:Boolean) : void
      {
         this.mUseSmallRenderer = useSmall;
      }
      
      public function set animateProgress(doAnim:Boolean) : void
      {
         this.mAnimateProgress = doAnim;
      }
      
      public function setData(data:Vector.<OnboardingChecklistObj>, useVerticalDisplay:Boolean = false) : void
      {
         var item:OnboardingChallengesChecklistListItem = null;
         var column:int = 0;
         var row:int = 0;
         var highlightChal:OnboardingChecklistChallengeObj = null;
         var chals:Array = null;
         var chalIdx:int = 0;
         var chal:OnboardingChecklistChallengeObj = null;
         var NUM_COLS:int = 2;
         var i:int = 0;
         var len:int = int(data.length);
         var linkage:String = "codo.shared.onboarding.OnboardingChallengesChecklistListItem";
         var cls:Class = getDefinitionByName(linkage) as Class;
         var itemWidth:int = this.mUseSmallRenderer ? 463 : 537;
         var foundHighlightChallenge:Boolean = false;
         while(this.mListHolder.numChildren > 0)
         {
            this.mListHolder.removeChildAt(0);
         }
         while(i < len)
         {
            item = this.mListHolder.addChild(new cls()) as OnboardingChallengesChecklistListItem;
            item.animateProgress = this.mAnimateProgress;
            item.useSmallRenderer = this.mUseSmallRenderer;
            highlightChal = null;
            if(!foundHighlightChallenge && data[i] != null)
            {
               chals = data[i].challenges;
               for(chalIdx = 0; chalIdx < chals.length; chalIdx++)
               {
                  chal = chals[chalIdx];
                  if(!chal.getFinished())
                  {
                     foundHighlightChallenge = true;
                     highlightChal = chal;
                     break;
                  }
               }
            }
            item.setHighlightChallenge(highlightChal);
            item.setData(data[i]);
            if(useVerticalDisplay)
            {
               item.y = (item.height + 12) * i;
            }
            else
            {
               column = i % NUM_COLS;
               row = i / NUM_COLS;
               item.x = itemWidth * column;
               item.y = (item.height + 20) * row;
            }
            i++;
         }
         active();
      }
   }
}


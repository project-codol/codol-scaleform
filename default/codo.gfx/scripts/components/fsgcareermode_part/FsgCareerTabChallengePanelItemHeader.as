package components.fsgcareermode_part
{
   import codo.localization.DictChallenge;
   import codo.utils.LocalizeUtil;
   import flash.text.TextField;
   import fsg.shared.widgets.FsgTabChallengePanelItemHeader;
   
   public class FsgCareerTabChallengePanelItemHeader extends FsgTabChallengePanelItemHeader
   {
      
      public var myDescriptionTF:TextField;
      
      public function FsgCareerTabChallengePanelItemHeader()
      {
         super();
      }
      
      override public function setDescriptionText(txt:String, targetVal:uint = 0) : void
      {
         this.myDescriptionTF.text = LocalizeUtil.replaceConversionString(txt,[targetVal]);
      }
      
      override public function setWidth(widthVal:uint) : void
      {
      }
      
      override protected function isSelectable() : Boolean
      {
         return false;
      }
      
      override public function setReward(value:uint, isInXP:Boolean = true) : void
      {
         var valueLabel:String = isInXP ? "XP" : "GP";
         var valueTxt:String = "<font color=\'#3FA9F5\'>" + value + "</font> ".concat(valueLabel);
         myRewardTF.text = DictChallenge.CHALLENGE_REWARD_BASE;
         myRewardValueTF.htmlText = valueTxt;
      }
   }
}


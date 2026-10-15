package fsg.shared.widgets
{
   import codo.localization.DictChallenge;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   public class FsgTabChallengePanelItemHeader extends Sprite
   {
      
      private var m_selected:Boolean;
      
      public var myTitleTF:TextField;
      
      public var myRewardTF:TextField;
      
      public var myRewardNumTF:TextField;
      
      public var myRewardValueTF:TextField;
      
      public var myBkg:MovieClip;
      
      public function FsgTabChallengePanelItemHeader()
      {
         var i:uint = 0;
         var len:uint = 0;
         var field:TextField = null;
         super();
         this.selectedState = false;
         if(this.myRewardNumTF != null)
         {
            this.myRewardTF.autoSize = this.myRewardNumTF.autoSize = TextFieldAutoSize.RIGHT;
            i = 0;
            for(len = uint(this.numChildren); i < len; )
            {
               if(this.getChildAt(i) is TextField)
               {
                  field = this.getChildAt(i) as TextField;
                  TextFieldEx.setVerticalAlign(field,TextFieldEx.VALIGN_CENTER);
               }
               i++;
            }
         }
      }
      
      public function get selectedState() : Boolean
      {
         return this.m_selected;
      }
      
      public function set selectedState(isSelected:Boolean) : void
      {
         if(!this.isSelectable())
         {
            return;
         }
         var FRAME_UNSELECTED:uint = 1;
         var FRAME_SELECTED:uint = 2;
         var TITLE_TEXT_COLOR_SELECTED:uint = 0;
         var TITLE_TEXT_COLOR_UNSELECTED:uint = 16777215;
         this.myBkg.gotoAndStop(isSelected ? FRAME_SELECTED : FRAME_UNSELECTED);
         this.myTitleTF.textColor = this.myRewardTF.textColor = this.myRewardValueTF.textColor = isSelected ? TITLE_TEXT_COLOR_SELECTED : TITLE_TEXT_COLOR_UNSELECTED;
         this.m_selected = isSelected;
      }
      
      public function setWidth(widthVal:uint) : void
      {
         var TEXT_PADDING:uint = 5;
         this.myBkg.width = widthVal;
         this.myRewardValueTF.x = widthVal - (this.myRewardValueTF.textWidth + TEXT_PADDING);
      }
      
      public function get titleText() : String
      {
         return this.myTitleTF.text;
      }
      
      public function set titleText(txt:String) : void
      {
         this.myTitleTF.text = txt.toUpperCase();
      }
      
      public function get descriptionText() : String
      {
         return this.myTitleTF.text;
      }
      
      public function setDescriptionText(txt:String, targetVal:uint = 0) : void
      {
      }
      
      public function setReward(value:uint, isInXP:Boolean = true) : void
      {
         this.myRewardTF.text = LocalizeUtil.localize(DictChallenge.CHALLENGE_REWARD_BASE).toUpperCase();
         this.myRewardNumTF.text = value.toString();
         this.myRewardValueTF.text = isInXP ? "XP" : "GP";
         this.myRewardTF.x = this.myRewardNumTF.x - this.myRewardTF.textWidth - 3;
      }
      
      protected function isSelectable() : Boolean
      {
         return true;
      }
   }
}


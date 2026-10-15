package codo.component.social
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.localization.DictClan;
   import codo.objects.InputBoxSettings;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.display.MovieClip;
   
   public class LevelPicker extends MovieClip
   {
      
      public var myPrestigeLabel:TextField;
      
      public var myLevelLabel:TextField;
      
      public var myPrestigeInput:InputBox;
      
      public var myLevelInput:InputBox;
      
      public function LevelPicker()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var prestigeInputSetting:InputBoxSettings = new InputBoxSettings();
         prestigeInputSetting.width = 35;
         prestigeInputSetting.height = 22;
         prestigeInputSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         prestigeInputSetting.showSearchIcon = false;
         prestigeInputSetting.showClearButton = false;
         prestigeInputSetting.showHint = false;
         prestigeInputSetting.regExp = /^[0-9]*$/;
         this.myPrestigeInput.settings = prestigeInputSetting;
         var levelInputSetting:InputBoxSettings = new InputBoxSettings();
         levelInputSetting.width = 35;
         levelInputSetting.height = 22;
         levelInputSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         levelInputSetting.showSearchIcon = false;
         levelInputSetting.showClearButton = false;
         levelInputSetting.showHint = false;
         levelInputSetting.regExp = /^[0-9]*$/;
         this.myLevelInput.settings = levelInputSetting;
         var labelStyle:TextStyle = new TextStyle();
         labelStyle.font = GlobalGuide.FONT_FACE_BOLD;
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myPrestigeLabel.textStyle = labelStyle;
         this.myPrestigeLabel.text = DictClan.LEVEL_PICKER_PRESTIGE;
         this.myLevelLabel.textStyle = labelStyle;
         this.myLevelLabel.text = DictClan.LEVEL_PICKER_LEVEL;
         this.myPrestigeInput.x = 0;
         this.myPrestigeLabel.x = this.myPrestigeInput.x + this.myPrestigeInput.width + 2;
         this.myLevelInput.x = this.myPrestigeLabel.x + this.myPrestigeLabel.textWidth + 6;
         this.myLevelLabel.x = this.myLevelInput.x + this.myLevelInput.width + 2;
         this.myPrestigeInput.y = 0;
         this.myPrestigeLabel.y = (this.myPrestigeInput.height - this.myPrestigeLabel.height) * 0.5 + this.myPrestigeInput.y;
         this.myLevelInput.y = (this.myPrestigeLabel.height - this.myLevelInput.height) * 0.5 + this.myPrestigeLabel.y;
         this.myLevelLabel.y = (this.myLevelInput.height - this.myLevelLabel.height) * 0.5 + this.myLevelInput.y;
      }
      
      public function setData(prestige:int, level:int) : void
      {
         this.myPrestigeInput.text = String(prestige);
         this.myLevelInput.text = String(level);
      }
      
      public function getPrestige() : int
      {
         var prestigeValue:int = parseInt(this.myPrestigeInput.text);
         var valid:Boolean = true;
         if(this.myPrestigeInput.text == "")
         {
            prestigeValue = 0;
            valid = false;
         }
         if(isNaN(prestigeValue))
         {
            prestigeValue = 0;
            valid = false;
         }
         if(prestigeValue < 0 || prestigeValue > CFunctionCommonContainer.GetPlayerMaxPrestige())
         {
            prestigeValue = 0;
            valid = false;
         }
         if(!valid)
         {
            this.myPrestigeInput.text = String(prestigeValue);
         }
         return prestigeValue;
      }
      
      public function getLevel() : int
      {
         var levelValue:int = parseInt(this.myLevelInput.text);
         var valid:Boolean = true;
         if(isNaN(levelValue))
         {
            levelValue = 1;
            valid = false;
         }
         if(levelValue < 1 || levelValue > CFunctionCommonContainer.GetPlayerMaxLevel())
         {
            levelValue = 1;
            valid = false;
         }
         if(!valid)
         {
            this.myLevelInput.text = String(levelValue);
         }
         return levelValue;
      }
      
      public function getData() : int
      {
         return this.getPrestige() * 100 + this.getLevel();
      }
   }
}


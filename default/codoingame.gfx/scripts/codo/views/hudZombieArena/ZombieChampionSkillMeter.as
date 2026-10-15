package codo.views.hudZombieArena
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.diagram.CircleDiagram;
   import codo.objects.ZombieChampionAttrLevelObj;
   import codo.objects.ZombieChampionAttrObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ZombieChampionSkillMeter extends MovieClip
   {
      
      private static const METER_WIDTH:Number = 154;
      
      public var mySkillMeter:CircleDiagram;
      
      public var myUpButton:Button;
      
      public var myDownButton:Button;
      
      public var myLabel:TextField;
      
      public var myDescription:TextField;
      
      public var myHotkey:TextField;
      
      public var myCost:TextField;
      
      private var mValue:int;
      
      private var mDelta:int;
      
      private var mLevels:Vector.<ZombieChampionAttrLevelObj>;
      
      private var mID:int;
      
      private var mIncreaseCallback:Function;
      
      private var mDecreaseCallback:Function;
      
      public function ZombieChampionSkillMeter()
      {
         super();
         this.myUpButton.registerClickEvent(this.onUpClicked);
         this.myDownButton.registerClickEvent(this.onDownClicked);
         this.myUpButton.label = "+";
         this.myDownButton.label = "-";
         this.myUpButton.labelUnfocusColor = GlobalGuide.CODO_BLACK;
         this.myUpButton.labelFocusColor = GlobalGuide.WHITE;
         this.myUpButton.forceEndHighlight();
         this.mySkillMeter.setDrawTicks(true);
         this.mySkillMeter.setTextType(CircleDiagram.TEXT_X_OF_Y);
         this.mySkillMeter.setFillColor(GlobalGuide.WHITE);
         this.mySkillMeter.setDeltaFillColor(GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE);
         this.myDescription.wordWrap = true;
         this.myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myDescription.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.alignment = this.myDescription.alignment = TextStyle.HALIGN_CENTER;
         this.myHotkey.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHotkey.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myHotkey.fontColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
         this.myCost.font = GlobalGuide.FONT_FACE_BOLD;
         this.myCost.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.width = this.myDescription.width = this.myHotkey.width = METER_WIDTH + 23;
         this.myLabel.height = this.myHotkey.height = 64;
         this.myDescription.height = 128;
         this.myCost.width = METER_WIDTH;
         this.myUpButton.visible = false;
         this.myDownButton.visible = false;
         this.myHotkey.visible = this.myDescription.visible = this.myCost.visible = false;
      }
      
      public function initData(data:ZombieChampionAttrObj, isDetailPanel:Boolean = false) : void
      {
         var i:uint = 0;
         this.mValue = 0;
         this.mLevels = data.levels;
         this.mID = data.id;
         this.myLabel.fontColor = !isDetailPanel ? GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE : GlobalGuide.WHITE;
         this.myLabel.text = data.name;
         this.myDescription.text = data.description;
         var numLevels:uint = this.mLevels.length;
         this.mySkillMeter.setParams(77,62,new Point(77,77),-90 + 180 / numLevels);
         this.mySkillMeter.setDrawBackground(true);
         if(!isDetailPanel)
         {
            for(i = 0; i < numLevels; i++)
            {
               this.mySkillMeter.flagTickIcon(i,this.mLevels[i].boost);
            }
         }
         this.mySkillMeter.setFillAmount(this.mValue,numLevels);
         this.mySkillMeter.skipAnimation();
      }
      
      public function setValue(value:int, delta:int) : void
      {
         this.mValue = value;
         this.mDelta = delta;
         if(this.mValue >= this.mLevels.length)
         {
            this.myCost.text = "";
         }
         else
         {
            this.myCost.text = LocalizeUtil.param("@UI_HUD_ZOMBIE_CHAMPIONS_SKILL_COST",[this.mLevels[this.mValue].cost.toString()]);
         }
         if(this.mValue == 0)
         {
            this.mySkillMeter.overrideValue("+0%");
         }
         else if(this.mValue <= this.mLevels.length)
         {
            this.mySkillMeter.overrideValue("+" + this.mLevels[this.mValue - 1].value + "%");
         }
         else
         {
            this.mySkillMeter.overrideValue("");
         }
         this.mySkillMeter.setFillAmount(this.mValue,this.mLevels.length,this.mDelta);
         this.mySkillMeter.skipAnimation();
         var totalWidth:Number = this.myCost.textWidth + this.myHotkey.textWidth + 5;
         this.myHotkey.x = this.mySkillMeter.x + METER_WIDTH * 0.5 - totalWidth * 0.5;
         this.myCost.x = this.myHotkey.x + this.myHotkey.textWidth + 5;
      }
      
      public function setIncreaseCallback(func:Function) : void
      {
         this.mIncreaseCallback = func;
         this.myUpButton.visible = true;
         this.myHotkey.visible = this.myDescription.visible = this.myCost.visible = true;
      }
      
      public function setDecreaseCallback(func:Function) : void
      {
         this.mDecreaseCallback = func;
         this.myDownButton.visible = true;
      }
      
      public function getValue() : int
      {
         return this.mValue;
      }
      
      public function getDelta() : int
      {
         return this.mDelta;
      }
      
      public function getLevels() : Vector.<ZombieChampionAttrLevelObj>
      {
         return this.mLevels;
      }
      
      public function setHotKey(key:String) : void
      {
         this.myHotkey.text = key;
      }
      
      private function onUpClicked() : void
      {
         this.mIncreaseCallback(this.mID);
      }
      
      private function onDownClicked() : void
      {
         this.mDecreaseCallback(this.mID);
      }
   }
}


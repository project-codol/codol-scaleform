package codo.views.hudZombieArena
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.objects.ZombieChampionAttrLevelObj;
   import codo.objects.ZombieChampionAttrObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.SoundUtil;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class ZombieChampionsAttributes extends MovieClip
   {
      
      public static const NUM_SKILLS:int = 4;
      
      public static const FRAME_WIDTH:Number = 771;
      
      public static const FRAME_HEIGHT:Number = 455;
      
      public var mySkill0:ZombieChampionSkillMeter;
      
      public var mySkill1:ZombieChampionSkillMeter;
      
      public var mySkill2:ZombieChampionSkillMeter;
      
      public var mySkill3:ZombieChampionSkillMeter;
      
      public var myConfirmButton:Button;
      
      public var myCancelButton:Button;
      
      public var myFrame:MovieClip;
      
      public var myHeader:TextField;
      
      public var myDescription:TextField;
      
      public var myPointsLabel:TextField;
      
      public var myPointsValue:TextField;
      
      private var mSkillClips:Vector.<ZombieChampionSkillMeter>;
      
      private var mBalance:int;
      
      private var mSelectionCost:int;
      
      private var mSelections:Array;
      
      public function ZombieChampionsAttributes()
      {
         super();
         this.mSkillClips = new <ZombieChampionSkillMeter>[this.mySkill0,this.mySkill1,this.mySkill2,this.mySkill3];
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myHeader.width = FRAME_WIDTH;
         this.myHeader.height = 60;
         this.myDescription.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myDescription.alignment = TextStyle.HALIGN_CENTER;
         this.myDescription.width = FRAME_WIDTH - 20;
         this.myPointsLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myPointsValue.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myPointsValue.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myPointsValue.fontColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
         this.myPointsLabel.width = this.myPointsValue.width = 400;
         this.myPointsLabel.height = this.myPointsValue.height = 60;
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myPointsLabel.text = LocalizeUtil.localize("@UI_HUD_ZOMBIE_CHAMPIONS_POINTS_LABEL");
         this.myHeader.text = LocalizeUtil.localize("@UI_HUD_ZOMBIE_CHAMPIONS_SKILLS_LABEL");
         this.myConfirmButton.label = LocalizeUtil.param("@UI_HUD_ZOMBIE_CHAMPIONS_CONFIRM_LABEL",["SPACE"]);
         this.myCancelButton.label = LocalizeUtil.param("@UI_HUD_ZOMBIE_CHAMPIONS_CANCEL_LABEL",["B"]);
         this.myDescription.text = LocalizeUtil.localize("@UI_HUD_ZOMBIE_CHAMPIONS_SKILLS_DESCRIPTION");
         this.myConfirmButton.registerClickEvent(this.onConfirm);
         this.myCancelButton.registerClickEvent(this.onCancel);
         this.mySkill0.setHotKey("Q");
         this.mySkill1.setHotKey("W");
         this.mySkill2.setHotKey("E");
         this.mySkill3.setHotKey("R");
      }
      
      public function cppInitData(data:Vector.<ZombieChampionAttrObj>) : void
      {
         for(var i:int = 0; i < NUM_SKILLS; i++)
         {
            this.mSkillClips[i].initData(data[i]);
            this.mSkillClips[i].setIncreaseCallback(this.tryIncreaseStat);
            this.mSkillClips[i].setDecreaseCallback(this.tryDecreaseStat);
         }
         this.mBalance = 0;
         this.clearSelections();
      }
      
      public function setBalance(balance:int = 0) : void
      {
         this.mBalance = balance;
         this.refreshBalanceText();
      }
      
      public function show(allocations:Array = null) : void
      {
         var i:int = 0;
         if(allocations != null)
         {
            for(i = 0; i < NUM_SKILLS; i++)
            {
               this.mSkillClips[i].setValue(allocations[i],0);
            }
         }
         parent.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         visible = true;
      }
      
      public function hide() : void
      {
         this.clearSelections();
         parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         visible = false;
      }
      
      private function refreshBalanceText() : void
      {
         this.myPointsValue.text = (this.mBalance - this.mSelectionCost).toString();
         this.myPointsValue.x = this.myFrame.x + this.myFrame.width - this.myPointsValue.textWidth - 50;
         this.myPointsLabel.x = this.myPointsValue.x - this.myPointsLabel.textWidth - 5;
      }
      
      private function tryIncreaseStat(id:int) : void
      {
         var nextLevelIdx:int = this.mSkillClips[id].getValue();
         var levels:Vector.<ZombieChampionAttrLevelObj> = this.mSkillClips[id].getLevels();
         if(nextLevelIdx < levels.length)
         {
            if(levels[nextLevelIdx].cost <= this.mBalance - this.mSelectionCost)
            {
               this.mSelectionCost += levels[nextLevelIdx].cost;
               ++this.mSelections[id];
               this.refreshBalanceText();
               this.mSkillClips[id].setValue(nextLevelIdx + 1,this.mSelections[id]);
               SoundUtil.getInstance().playSound("UI_General_Select_Alt_01");
            }
            else
            {
               SoundUtil.getInstance().playSound("ui_buy_fail");
            }
         }
      }
      
      private function tryDecreaseStat(id:int) : void
      {
         var currLevelIdx:int = 0;
         var levels:Vector.<ZombieChampionAttrLevelObj> = null;
         if(this.mSkillClips[id].getDelta() > 0)
         {
            currLevelIdx = this.mSkillClips[id].getValue() - 1;
            levels = this.mSkillClips[id].getLevels();
            this.mSelectionCost -= levels[currLevelIdx].cost;
            --this.mSelections[id];
            this.refreshBalanceText();
            this.mSkillClips[id].setValue(currLevelIdx,this.mSelections[id]);
            SoundUtil.getInstance().playSound("UI_General_Select_Alt_01");
         }
      }
      
      private function clearSelections() : void
      {
         this.mSelectionCost = 0;
         this.mSelections = [0,0,0,0];
      }
      
      private function onKeyDownHandler(cEvt:KeyboardEvent) : void
      {
         switch(cEvt.keyCode)
         {
            case Keyboard.B:
            case Keyboard.ESCAPE:
               this.onCancel();
               break;
            case Keyboard.SPACE:
            case Keyboard.ENTER:
               this.onConfirm();
               break;
            case Keyboard.Q:
               this.tryIncreaseStat(0);
               break;
            case Keyboard.W:
               this.tryIncreaseStat(1);
               break;
            case Keyboard.E:
               this.tryIncreaseStat(2);
               break;
            case Keyboard.R:
               this.tryIncreaseStat(3);
         }
      }
      
      private function onConfirm() : void
      {
         var points:String = this.mSelectionCost > 0 ? this.mySkill0.getValue() + "|" + this.mySkill1.getValue() + "|" + this.mySkill2.getValue() + "|" + this.mySkill3.getValue() : "";
         CFunctionInGameContainer.AS_ZChampCloseAttributes(points);
         this.clearSelections();
      }
      
      private function onCancel() : void
      {
         CFunctionInGameContainer.AS_ZChampCloseAttributes("");
         this.clearSelections();
      }
   }
}


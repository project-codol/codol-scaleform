package codo.component.matchselect
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.objects.MatchSelectModeObj;
   import codo.objects.PlayListObj;
   import codo.style.GlobalGuide;
   import codo.style.MatchSelectGuide;
   import codo.utils.CursorUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class MatchSelectOption extends UIInteractiveComponent implements ISelectable
   {
      
      protected static const FRAME_NORMAL:int = 1;
      
      protected static const FRAME_OVER:int = 2;
      
      protected static const FRAME_SELECTED:int = 3;
      
      protected static const WEWK_DAY_TEXT:Array = ["@SF_UI_MONDAY","@SF_UI_TUESDAY","@SF_UI_WEDNESDAY","@SF_UI_THURSDAY","@SF_UI_FRIDAY","@SF_UI_SATURDAY","@SF_UI_SUNDAY"];
      
      private static const LOCK_PADDING:int = 5;
      
      public var myFeatureTag:MovieClip;
      
      public var myNewTag:MovieClip;
      
      public var myLabel:TextField;
      
      public var myUnlockLevel:TextField;
      
      public var myLockIcon:Sprite;
      
      public var myBackground:MovieClip;
      
      public var myForeground:MovieClip;
      
      protected var mWidth:Number;
      
      protected var mHeight:Number;
      
      protected var mSelected:Boolean = false;
      
      protected var mTagPosition:Array = [316,262];
      
      public function MatchSelectOption()
      {
         super();
         isInteractiveEnabled = true;
         this.myUnlockLevel.textStyle = MatchSelectGuide.stylePlaylistLabel;
         this.myLabel.textStyle = MatchSelectGuide.stylePlaylistLabel;
         this.myUnlockLevel.y = 7;
         this.myLabel.y = 7;
         this.myUnlockLevel.text = "";
         this.myLabel.text = "";
         this.myFeatureTag.visible = this.myNewTag.visible = false;
         this.myFeatureTag.gotoAndStop(1);
         this.myNewTag.gotoAndStop(2);
         this.myLockIcon.visible = false;
         this.width = myHitArea.width;
         this.height = myHitArea.height;
         this.gotoNormalState();
      }
      
      public function set selected(sel:Boolean) : void
      {
         this.mSelected = sel;
         if(this.mSelected)
         {
            this.gotoSelectState();
         }
         else
         {
            this.gotoNormalState();
         }
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      override public function setData(data:*) : void
      {
         var currentLevel:int = 0;
         var currentPrestige:int = 0;
         var maxLevel:uint = 0;
         var openLevels:Array = null;
         var start:int = 0;
         var end:int = 0;
         var lockText:String = null;
         super.setData(data);
         if(data == null)
         {
            visible = false;
            return;
         }
         visible = true;
         if(null != data.name)
         {
            this.myLabel.text = data.name;
         }
         var playListObj:PlayListObj = data as PlayListObj;
         if(playListObj != null)
         {
            if(playListObj.cycleDayIndex >= 0)
            {
               this.myLabel.text = LocalizeUtil.localize(WEWK_DAY_TEXT[playListObj.cycleDayIndex]) + ": " + playListObj.name;
            }
            this.enabled = playListObj.isActive;
            if(this.myBackground != null)
            {
               this.myBackground.visible = playListObj.isActive;
            }
            this.myLockIcon.visible = !playListObj.unlocked || playListObj.dlcLocked;
            if(this.myLockIcon.visible == true && !playListObj.dlcLocked)
            {
               currentLevel = CFunctionCommonContainer.GetPlayerLevel();
               currentLevel += 1;
               currentPrestige = CFunctionCommonContainer.GetPlayerPrestige();
               maxLevel = CFunctionCommonContainer.GetPlayerMaxLevel();
               openLevels = playListObj.unlockedLevels;
               start = int(openLevels[0].start);
               end = int(openLevels[0].end);
               lockText = "";
               if(currentLevel < start && currentPrestige == 0)
               {
                  lockText = String(start);
               }
               else if(currentLevel > end || currentPrestige > 0 && end < maxLevel)
               {
                  lockText = String(end);
               }
               this.myUnlockLevel.text = lockText;
            }
            else
            {
               this.myUnlockLevel.text = "";
            }
         }
         else
         {
            if(null != data.locked)
            {
               this.myLockIcon.visible = data.locked;
            }
            if(this.myLockIcon.visible && null != data.unlockLevel && data.unlockLevel > 0)
            {
               this.myUnlockLevel.text = data.unlockLevel;
            }
            else
            {
               this.myUnlockLevel.text = "";
            }
         }
         this.myUnlockLevel.x = this.myLockIcon.x + this.myLockIcon.width + LOCK_PADDING;
         this.myLabel.x = this.myUnlockLevel.x + this.myUnlockLevel.textWidth + LOCK_PADDING;
         this.refreshTag();
         this.updateLabelPosition();
         this.gotoNormalState();
      }
      
      public function refreshTag() : void
      {
         var playListObj:PlayListObj = null;
         var modeObj:MatchSelectModeObj = null;
         var isNew:Boolean = false;
         var isFeatured:Boolean = false;
         if(enabled)
         {
            playListObj = getData() as PlayListObj;
            if(playListObj != null)
            {
               isNew = playListObj.isNew;
               isFeatured = playListObj.isFeatured;
            }
            else
            {
               modeObj = getData() as MatchSelectModeObj;
               if(modeObj != null)
               {
                  isNew = modeObj.isNew;
                  isFeatured = modeObj.isFeatured;
               }
            }
         }
         this.myFeatureTag.visible = isFeatured;
         this.myNewTag.visible = isNew;
         var tags:Array = [this.myNewTag,this.myFeatureTag];
         var posIndex:int = 0;
         for(var i:int = 0; i < tags.length; i++)
         {
            if(Boolean(tags[i].visible))
            {
               tags[i].x = this.mTagPosition[posIndex];
               posIndex++;
            }
         }
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      public function draw() : void
      {
         myHitArea.width = this.mWidth;
         myHitArea.height = this.mHeight;
         this.myLabel.width = myHitArea.width - this.myLabel.x - GlobalGuide.COMPONENT_PADDING;
         this.updateLabelPosition();
      }
      
      protected function updateLabelPosition() : void
      {
         this.myLabel.x = this.myLockIcon.visible ? this.myUnlockLevel.x + this.myUnlockLevel.textWidth + GlobalGuide.COMPONENT_PADDING : GlobalGuide.COMPONENT_PADDING;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mSelected)
         {
            this.gotoOverState();
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mSelected)
         {
            this.gotoNormalState();
         }
      }
      
      protected function gotoNormalState() : void
      {
         this.myForeground.gotoAndStop(FRAME_NORMAL);
         this.myLabel.fontColor = enabled ? 12905727 : 6453121;
      }
      
      protected function gotoOverState() : void
      {
         this.myForeground.gotoAndStop(FRAME_OVER);
         this.myLabel.fontColor = enabled ? 12905727 : 6453121;
      }
      
      protected function gotoSelectState() : void
      {
         this.myForeground.gotoAndStop(FRAME_SELECTED);
         this.myLabel.fontColor = GlobalGuide.WHITE;
      }
   }
}


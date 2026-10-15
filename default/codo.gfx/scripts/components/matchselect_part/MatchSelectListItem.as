package components.matchselect_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.SE_ID;
   import codo.localization.Dict;
   import codo.objects.MatchSelectOptionObj;
   import codo.utils.LocalizeUtil;
   import components.list_part.ListItemRendererBase;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.shared.BehaviourTooltip;
   
   public class MatchSelectListItem extends ListItemRendererBase
   {
      
      protected static var INERT_LOCKED_ICON:int = 1;
      
      protected static var HIGHLIGHTED_LOCKED_ICON:int = 2;
      
      public var myNewTag:MovieClip;
      
      public var myFeaturedTag:MovieClip;
      
      public var myIconLock:MovieClip;
      
      public var myNameText:MovieClip;
      
      public var myBgFocus:MovieClip;
      
      public var myBgNormal:MovieClip;
      
      protected var m_clickable:BehaviourClickable;
      
      protected var m_audio:BehaviourAudio;
      
      protected var m_bNew:Boolean;
      
      protected var m_bFeatured:Boolean;
      
      protected var m_tooltip:BehaviourTooltip;
      
      public function MatchSelectListItem()
      {
         super();
         this.m_clickable = new BehaviourClickable(this);
         this.m_audio = new BehaviourAudio(this.m_clickable,SE_ID.MISSION_ROLLOVER,SE_ID.MISSION_PROCEED);
         tipEnable = false;
         this.m_bNew = false;
         this.m_bFeatured = false;
         this.myIconLock.myLockText.myLockTF.text = "";
         this.initTextField();
      }
      
      protected function initTextField() : void
      {
         (this.myNameText.myTextTF as TextField).autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function setIsNew(mState:Boolean) : void
      {
         if(this.myNewTag != null)
         {
            this.myNewTag.visible = mState;
            if(mState)
            {
               this.myNewTag.myNewText.myTextTF.text = Dict.NEW;
               this.myNewTag.gotoAndPlay(2);
            }
         }
         this.m_bNew = mState;
      }
      
      public function setIsFeatured(mState:Boolean) : void
      {
         if(this.myFeaturedTag != null)
         {
            this.myFeaturedTag.visible = mState;
            if(mState)
            {
               this.myFeaturedTag.myFeaturedText.myTextTF.text = Dict.FEATURED;
               this.myFeaturedTag.gotoAndPlay(2);
            }
         }
         this.m_bFeatured = mState;
      }
      
      final override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.setIsNew(this.m_bNew);
         this.setIsFeatured(this.m_bFeatured);
      }
      
      override protected function onGetData() : void
      {
         var sndName:String = null;
         var optionObj:MatchSelectOptionObj = _data as MatchSelectOptionObj;
         if(optionObj != null)
         {
            if(optionObj.tooltip != null)
            {
               this.setTooltip(optionObj.tooltip);
            }
         }
         this.updateLock();
         this.updateNew();
         this.updateFeatured();
         this.myNameText.myTextTF.text = _data.name;
         visible = true;
         if(this.myIconLock.visible)
         {
            sndName = SE_ID.GENERAL_LOCKED;
         }
         else
         {
            sndName = SE_ID.MISSION_PROCEED;
         }
         this.m_audio.overrideClickAudio(sndName);
      }
      
      protected function updateLock() : void
      {
         var toolTipMessage:String = null;
         var currentLevel:int = 0;
         var currentPrestige:int = 0;
         var lockText:String = null;
         var optionObj:MatchSelectOptionObj = _data as MatchSelectOptionObj;
         if(optionObj != null)
         {
            this.myIconLock.visible = optionObj.locked;
            if(this.myIconLock.visible)
            {
               if(optionObj.unlockLevel == MatchSelectOptionObj.UNLOCK_LEVEL_NONE)
               {
                  toolTipMessage = "@SF_UI_COMING_SOON";
               }
               else
               {
                  currentLevel = CFunctionCommonContainer.GetPlayerLevel();
                  currentLevel += 1;
                  currentPrestige = CFunctionCommonContainer.GetPlayerPrestige();
                  lockText = "";
                  if(currentLevel < optionObj.unlockLevel && currentPrestige == 0)
                  {
                     lockText = String(optionObj.unlockLevel);
                  }
                  this.myIconLock.myLockText.myLockTF.text = lockText;
                  if(optionObj.tooltip == null)
                  {
                     toolTipMessage = LocalizeUtil.replace(LocalizeUtil.localize(Dict.LOCKED_MSG),[optionObj.unlockLevel]);
                  }
                  else
                  {
                     toolTipMessage = LocalizeUtil.localize(optionObj.tooltip) + "\n" + LocalizeUtil.replace(LocalizeUtil.localize(Dict.LOCKED_MSG),[optionObj.unlockLevel]);
                  }
               }
               if(toolTipMessage != null)
               {
                  this.setTooltip(toolTipMessage);
               }
            }
         }
         else
         {
            this.myIconLock.visible = false;
         }
      }
      
      protected function updateNew() : void
      {
         var isNew:Boolean = false;
         var optionObj:MatchSelectOptionObj = _data as MatchSelectOptionObj;
         if(optionObj != null)
         {
            isNew = optionObj.isNew;
         }
         if(isNew != this.m_bNew)
         {
            this.setIsNew(isNew);
         }
      }
      
      protected function updateFeatured() : void
      {
         var featured:Boolean = false;
         var optionObj:MatchSelectOptionObj = _data as MatchSelectOptionObj;
         if(optionObj != null)
         {
            featured = optionObj.isFeatured;
         }
         if(featured != this.m_bFeatured)
         {
            this.setIsFeatured(featured);
         }
      }
      
      protected function setTooltip(str:String) : void
      {
         if(this.m_tooltip == null)
         {
            this.m_tooltip = new BehaviourTooltip(this.m_clickable,str,myHitArea as MovieClip,{
               "x":300,
               "y":0
            });
         }
         else
         {
            this.m_tooltip.tipText = str;
         }
      }
      
      override protected function setToNormal(cTween:Boolean = false) : void
      {
         gotoAndStop(1);
         this.setLockNormal();
      }
      
      override protected function setToRollOver(cTween:Boolean = false) : void
      {
         if(currentFrame == 3)
         {
            return;
         }
         gotoAndStop(2);
         this.setLockHighlighted();
      }
      
      override protected function onSelected() : void
      {
         super.onSelected();
         gotoAndStop(3);
         this.setLockNormal();
      }
      
      protected function setLockNormal() : void
      {
         this.myIconLock.gotoAndStop(INERT_LOCKED_ICON);
      }
      
      protected function setLockHighlighted() : void
      {
         this.myIconLock.gotoAndStop(HIGHLIGHTED_LOCKED_ICON);
      }
   }
}


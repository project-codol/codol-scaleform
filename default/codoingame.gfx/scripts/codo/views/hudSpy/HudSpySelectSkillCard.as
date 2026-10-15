package codo.views.hudSpy
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCInGameEvent;
   import codo.constants.SpyModeRoleType;
   import codo.localization.DictSpy;
   import codo.manager.EventManager;
   import codo.objects.SpyModeSkillObj;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudSpySelectSkillCard extends UIInteractiveComponent
   {
      
      public var myIcon:MovieClip;
      
      public var mySkillName:TextField;
      
      public var mySkillDesc:TextField;
      
      public var myButton:MovieClip;
      
      public var myBg:MovieClip;
      
      public var myBorder:MovieClip;
      
      private var mSkillObj:SpyModeSkillObj;
      
      private var mSelected:Boolean;
      
      private var mIndex:int;
      
      private var mSendingCommand:Boolean;
      
      private var mTweenLite:TweenLite;
      
      private var mOrgX:Number;
      
      private var mOrgY:Number;
      
      public function HudSpySelectSkillCard()
      {
         super();
         isInteractiveEnabled = true;
         this.myButton["myText"].text = DictSpy.PRESS_TO_CHOOSE_SKILL;
      }
      
      public function setOrgPosition(orgX:Number, orgY:Number) : void
      {
         x = orgX;
         y = orgY;
         this.mOrgX = orgX;
         this.mOrgY = orgY;
      }
      
      override public function setData(data:*) : void
      {
         mClickable.setEnabled(true);
         this.mSkillObj = data as SpyModeSkillObj;
         var myImage:FsgImageHolder = this.myIcon["myImage"] as FsgImageHolder;
         myImage.setImage(this.mSkillObj.icon);
         this.mySkillName.text = "@" + this.mSkillObj.title;
         this.mySkillDesc.text = "@" + this.mSkillObj.desc;
         this.selected = false;
         this.mSendingCommand = false;
         alpha = 1;
         scaleX = 1;
         scaleY = 1;
      }
      
      public function set index(index:int) : void
      {
         this.mIndex = index;
         var myKey:MovieClip = this.myButton["myKey"] as MovieClip;
         myKey["myText"].text = index.toString();
      }
      
      public function set selected(selected:Boolean) : void
      {
         this.mSelected = selected;
         this.updateState();
      }
      
      override protected function onMouseOver() : void
      {
         if(this.mSendingCommand)
         {
            return;
         }
         super.onMouseOver();
         this.selected = true;
         TweenLite.killTweensOf(this);
         this.mTweenLite = TweenLite.to(this,0.05,{
            "y":this.mOrgY - 20,
            "ease":Linear.easeOut
         });
      }
      
      override protected function onMouseOut() : void
      {
         if(this.mSendingCommand)
         {
            return;
         }
         super.onMouseOut();
         this.selected = false;
         TweenLite.killTweensOf(this);
         this.mTweenLite = TweenLite.to(this,0.05,{
            "y":this.mOrgY,
            "ease":Linear.easeIn
         });
      }
      
      override protected function onMouseClick() : void
      {
         this.choose();
      }
      
      public function choose() : void
      {
         if(visible)
         {
            this.selected = true;
            this.mSendingCommand = true;
            TweenLite.killTweensOf(this);
            x = this.mOrgX;
            y = this.mOrgY;
            scaleX = 1;
            scaleY = 1;
            EventManager.getInstance().broadcast(BCInGameEvent.EVT_HIDE_SPY_SELECT_SKILL_CARDS,this);
            this.mTweenLite = TweenLite.to(this,0.1,{
               "x":this.mOrgX - width * 0.1,
               "y":this.mOrgY - height * 0.1,
               "scaleX":1.2,
               "scaleY":1.2,
               "ease":Linear.easeIn,
               "onComplete":this.onZoomOutOver
            });
         }
      }
      
      private function onZoomOutOver() : void
      {
         this.mTweenLite = TweenLite.to(this,0.3,{
            "alpha":0,
            "ease":Linear.easeOut,
            "onComplete":this.onZoomInOver
         });
      }
      
      private function onZoomInOver() : void
      {
         this.sendCommandToDS();
      }
      
      public function sendCommandToDS() : void
      {
         if(this.mSkillObj == null)
         {
            return;
         }
         CFunctionCommonContainer.ScriptMenuResponse("spy_skill_select",this.mSkillObj.id.toString());
         CFunctionInGameContainer.AS_SpyMode_HideSelectSkillPanel();
      }
      
      private function updateState() : void
      {
         var myKey:MovieClip = null;
         if(this.mSkillObj == null)
         {
            return;
         }
         if(this.mSkillObj.role == SpyModeRoleType.SPY_ROLE_SPY)
         {
            this.myIcon.gotoAndStop(1);
            this.mySkillName.textColor = 16743724;
            this.myButton.gotoAndStop(1);
            myKey = this.myButton["myKey"] as MovieClip;
            myKey["myText"].textColor = 16743724;
            this.myBorder.gotoAndStop(1);
            this.myBg.gotoAndStop(1);
            if(!this.mSelected)
            {
               this.myBg.gotoAndStop(3);
            }
            else
            {
               this.myBg.gotoAndStop(1);
            }
         }
         else
         {
            this.myIcon.gotoAndStop(2);
            this.mySkillName.textColor = 39615;
            this.myButton.gotoAndStop(2);
            myKey = this.myButton["myKey"] as MovieClip;
            myKey["myText"].textColor = 39615;
            this.myBorder.gotoAndStop(2);
            this.myBg.gotoAndStop(2);
            if(!this.mSelected)
            {
               this.myBg.gotoAndStop(3);
            }
            else
            {
               this.myBg.gotoAndStop(2);
            }
         }
      }
   }
}


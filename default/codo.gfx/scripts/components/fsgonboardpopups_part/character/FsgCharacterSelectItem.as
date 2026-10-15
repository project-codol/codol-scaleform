package components.fsgonboardpopups_part.character
{
   import codo.component.TextField;
   import codo.constants.OnboardingSound;
   import codo.objects.OnboardCharacterOptionObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import com.greensock.plugins.GlowFilterPlugin;
   import com.greensock.plugins.TweenPlugin;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class FsgCharacterSelectItem extends Sprite
   {
      
      private static const NAME_PADDING:Number = 60;
      
      private static const NAME_OFFSET_X:Number = 27;
      
      private static const ANIMATION_SPEED:Number = 0.2;
      
      private static const BASE_SCALE:Number = 0.75;
      
      private static const NAME_WIDTH:Number = 356;
      
      public var myHitArea:Sprite;
      
      public var myButtonPanel:FsgCharacterSelectViewItemButtonPanel;
      
      public var myLibraryImg:Sprite;
      
      public var myNameArrow:Sprite;
      
      public var myFocusArrow:Sprite;
      
      public var myCharacterNameBG:MovieClip;
      
      public var myCharacterName:TextField;
      
      private var mClickable:BehaviourClickable;
      
      private var mCharacterDepth:uint = 0;
      
      private var mAudio:BehaviourAudio;
      
      private var mIsSelected:Boolean = false;
      
      private var mItemData:OnboardCharacterOptionObj;
      
      private var mClickCallback:Function;
      
      private var mMouseOverCallback:Function;
      
      private var mMouseOutCallback:Function;
      
      private var mPanelAnimationCompleteCallback:Function;
      
      public function FsgCharacterSelectItem()
      {
         super();
         TweenPlugin.activate([GlowFilterPlugin]);
         this.mClickable = new BehaviourClickable(this.myHitArea);
         this.mAudio = new BehaviourAudio(this.mClickable);
         scaleX = scaleY = BASE_SCALE;
         this.myButtonPanel.visible = false;
         this.myLibraryImg.mouseEnabled = false;
         this.myLibraryImg.filters = [new GlowFilter(GlobalGuide.CODO_BLUE_HIGHLIGHT,0,10,10,1)];
         this.myCharacterName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myCharacterName.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myCharacterName.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myCharacterName.width = NAME_WIDTH;
         this.myCharacterName.alpha = 0;
         this.myCharacterNameBG.alpha = 0;
         this.myFocusArrow.alpha = 0;
         this.myNameArrow.alpha = 0;
         this.myFocusArrow.visible = false;
         this.myNameArrow.visible = false;
         this.mAudio.overrideClickAudio(OnboardingSound.CHARACTER_SELECT_OPEN);
         this.mAudio.overrideMouseOverAudio(OnboardingSound.CHARACTER_SELECT_MOUSEOVER);
      }
      
      public function set data(dataObj:OnboardCharacterOptionObj) : void
      {
         this.mItemData = dataObj;
         this.mCharacterDepth = dataObj.characterDepth;
         this.myCharacterName.text = LocalizeUtil.localize(dataObj.characterName).toUpperCase();
         this.myCharacterNameBG.width = this.myCharacterName.textWidth + NAME_PADDING;
         this.myCharacterNameBG.x = this.myHitArea.x + (this.myHitArea.width - this.myCharacterNameBG.width) / 2;
         this.myCharacterName.x = this.myCharacterNameBG.x + NAME_OFFSET_X;
         this.mClickable.addClickCallback(this.mClickCallback,this);
         this.mClickable.addMouseOverCallback(this.onItemMouseOver);
         this.mClickable.addMouseOutCallback(this.onItemMouseOut);
      }
      
      override public function get width() : Number
      {
         return this.myHitArea.width;
      }
      
      public function fade(doFadeOut:Boolean = true) : void
      {
         var endAlpha:Number = doFadeOut ? 0.2 : 1;
         TweenLite.to(this,ANIMATION_SPEED,{
            "alpha":endAlpha,
            "ease":Cubic.easeOut,
            "overwrite":0
         });
      }
      
      private function onItemMouseOver() : void
      {
         if(this.mIsSelected)
         {
            return;
         }
         this.mMouseOverCallback(this);
         TweenLite.to(this.myLibraryImg,ANIMATION_SPEED,{"glowFilter":{
            "blurX":30,
            "blurY":30,
            "alpha":1
         }});
         TweenLite.to(this.myCharacterNameBG,ANIMATION_SPEED,{"alpha":1});
         TweenLite.to(this.myCharacterName,ANIMATION_SPEED,{"alpha":1});
         TweenLite.to(this.myNameArrow,ANIMATION_SPEED,{"alpha":1});
         TweenLite.to(this.myFocusArrow,ANIMATION_SPEED,{"alpha":1});
         var endScale:Number = BASE_SCALE + 0.075;
         TweenLite.to(this,ANIMATION_SPEED,{
            "scaleX":endScale,
            "scaleY":endScale,
            "ease":Cubic.easeOut,
            "overwrite":0
         });
      }
      
      private function onItemMouseOut() : void
      {
         if(this.mIsSelected)
         {
            return;
         }
         this.mMouseOutCallback(this);
         TweenLite.to(this.myLibraryImg,ANIMATION_SPEED,{"glowFilter":{
            "blurX":10,
            "blurY":10,
            "alpha":0
         }});
         TweenLite.to(this.myCharacterNameBG,ANIMATION_SPEED,{"alpha":0});
         TweenLite.to(this.myCharacterName,ANIMATION_SPEED,{"alpha":0});
         TweenLite.to(this.myNameArrow,ANIMATION_SPEED,{"alpha":0});
         TweenLite.to(this.myFocusArrow,ANIMATION_SPEED,{"alpha":0});
         TweenLite.to(this,ANIMATION_SPEED,{
            "scaleX":BASE_SCALE,
            "scaleY":BASE_SCALE,
            "ease":Cubic.easeOut,
            "overwrite":0
         });
      }
      
      public function get index() : uint
      {
         return this.mItemData.index;
      }
      
      public function set index(val:uint) : void
      {
         this.mItemData.index = val;
      }
      
      public function get SKU() : int
      {
         return this.mItemData.characterItemSKU;
      }
      
      public function get characterDepth() : uint
      {
         return this.mCharacterDepth;
      }
      
      public function get isSelected() : Boolean
      {
         return this.mIsSelected;
      }
      
      public function set isSelected(isSelected:Boolean) : void
      {
         this.mIsSelected = isSelected;
      }
      
      public function enable() : void
      {
         this.mClickable.setEnabled(true);
         this.myHitArea.mouseEnabled = true;
      }
      
      public function disable() : void
      {
         this.mClickable.setEnabled(false);
         this.myHitArea.mouseEnabled = false;
      }
      
      private function onBioPanelShown() : void
      {
         TweenLite.to(this.myButtonPanel,ANIMATION_SPEED,{
            "alpha":1,
            "overwrite":1
         });
         this.mPanelAnimationCompleteCallback();
      }
      
      private function onBioPanelHidden() : void
      {
         TweenLite.to(this,ANIMATION_SPEED,{
            "scaleX":BASE_SCALE,
            "scaleY":BASE_SCALE,
            "ease":Cubic.easeOut,
            "overwrite":0
         });
         this.mClickable.setEnabled(true);
         this.myHitArea.mouseEnabled = true;
      }
      
      public function set mouseOverCallback(callback:Function) : void
      {
         this.mMouseOverCallback = callback;
      }
      
      public function set mouseOutCallback(callback:Function) : void
      {
         this.mMouseOutCallback = callback;
      }
      
      public function set clickCallback(callback:Function) : void
      {
         this.mClickCallback = callback;
      }
      
      public function set panelAnimationCompleteCallback(callback:Function) : void
      {
         this.mPanelAnimationCompleteCallback = callback;
      }
      
      public function configItemCallbacks(confirmCallback:Function, cancelCallback:Function) : void
      {
         this.myButtonPanel.config(confirmCallback,cancelCallback);
      }
   }
}


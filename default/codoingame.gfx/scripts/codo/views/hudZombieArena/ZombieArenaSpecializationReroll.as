package codo.views.hudZombieArena
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.ContentContainer;
   import codo.component.TextField;
   import codo.localization.DictHud;
   import codo.objects.ZombieArenaSpecializationObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.SoundUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Expo;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import fsg.util.FsgImageHolder;
   
   public class ZombieArenaSpecializationReroll extends MovieClip
   {
      
      private static const FRAME_WIDTH:Number = 669;
      
      private static const FRAME_HEIGHT:Number = 325;
      
      private static const LABEL_WIDTH:Number = 150;
      
      private static const FOCUS_ALPHA:Number = 1;
      
      private static const UNFOCUS_ALPHA:Number = 0.4;
      
      private static const FLASH_DURATION:Number = 0.07;
      
      public var myFrame:ContentContainer;
      
      public var mySpecialization0:ZombieArenaSpecializationDisplay;
      
      public var mySpecialization1:ZombieArenaSpecializationDisplay;
      
      public var myHeader:TextField;
      
      public var myHeaderBG:MovieClip;
      
      public var mySpecializationLabel0:TextField;
      
      public var mySpecializationLabel1:TextField;
      
      public var myCurrentKey:TextField;
      
      public var myRerollKey:TextField;
      
      public var myCurrentHitArea:MovieClip;
      
      public var myRerollHitArea:MovieClip;
      
      public var myCurrentButtonBG:MovieClip;
      
      public var myRerollButtonBG:MovieClip;
      
      public var myImageMount:MovieClip;
      
      public var myArrow:MovieClip;
      
      private var mFlipAnimation:TimelineLite;
      
      private var mIsZSurv:Boolean;
      
      private var mHideTimeout:uint;
      
      public function ZombieArenaSpecializationReroll()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myFrame.hudMode();
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myHeader.alignment = TextStyle.HALIGN_CENTER;
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myHeader.width = this.myFrame.width;
         this.myHeader.height = this.myFrame.height;
         this.mySpecializationLabel0.alignment = TextStyle.HALIGN_CENTER;
         this.mySpecializationLabel1.alignment = TextStyle.HALIGN_CENTER;
         this.mySpecializationLabel0.font = GlobalGuide.FONT_FACE_BOLD;
         this.mySpecializationLabel1.font = GlobalGuide.FONT_FACE_BOLD;
         this.mySpecializationLabel0.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.mySpecializationLabel1.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.mySpecializationLabel0.width = LABEL_WIDTH;
         this.mySpecializationLabel1.width = LABEL_WIDTH;
         this.myCurrentKey.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myRerollKey.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myCurrentKey.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         this.myRerollKey.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         this.myCurrentKey.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myRerollKey.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myCurrentKey.height = 80;
         this.myRerollKey.height = 80;
         this.myRerollKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+melee");
         this.myCurrentKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+tact");
         this.myRerollButtonBG.alpha = UNFOCUS_ALPHA;
         this.myCurrentButtonBG.alpha = UNFOCUS_ALPHA;
         this.visible = false;
      }
      
      public function setData(data:Object, isZSurv:Boolean) : void
      {
         clearTimeout(this.mHideTimeout);
         this.mIsZSurv = isZSurv;
         this.myFrame.visible = this.myHeader.visible = this.myHeaderBG.visible = this.myCurrentButtonBG.visible = this.myRerollButtonBG.visible = !this.mIsZSurv;
         this.myArrow.visible = this.mIsZSurv;
         var skill:ZombieArenaSpecializationObj = new ZombieArenaSpecializationObj(data.skills[0].type,data.skills[0].label,data.skills[0].description,data.skills[0].image);
         this.mySpecialization0.setData(skill);
         this.mySpecializationLabel0.text = data.skills[0].roleLabel;
         skill = new ZombieArenaSpecializationObj(data.skills[1].type,data.skills[1].label,data.skills[1].description,data.skills[1].image);
         this.mySpecialization1.alpha = 0;
         this.mySpecialization1.setData(skill);
         this.mySpecializationLabel1.text = data.skills[1].roleLabel;
         this.animateRoll(data.randomSkillImages);
      }
      
      public function animateRoll(randomSkillImages:Array) : void
      {
         var image:FsgImageHolder = null;
         this._clearImages();
         this.mySpecializationLabel1.visible = this.myCurrentKey.visible = this.myRerollKey.visible = false;
         this.myHeader.text = LocalizeUtil.localize(DictHud.ZOMBIE_ARENA_SPECIALIZATION_REROLL_HEADER1);
         this.mFlipAnimation = new TimelineLite();
         var imgClass:Class = getDefinitionByName("hudZombieArenaGamblerIcon") as Class;
         var duration:Number = 0.05;
         for(var i:int = 0; i < randomSkillImages.length; i++)
         {
            image = new imgClass();
            image.width = image.height = 67;
            image.setImage(randomSkillImages[i]);
            image.alpha = 0;
            this.myImageMount.addChild(image);
            duration += 0.017;
            this.mFlipAnimation.append(new TweenLite(image,duration,{
               "alpha":1,
               "onStart":this.playRollSound,
               "ease":Expo.easeOut
            }));
            this.mFlipAnimation.append(new TweenLite(image,0,{"alpha":0}));
         }
         var onCompleteFunc:Function = !this.mIsZSurv ? this.onRollAnimComplete : this.onRollAnimCompleteZSurv;
         this.mFlipAnimation.append(new TweenLite(this.mySpecialization1,0.01,{
            "alpha":1,
            "onComplete":onCompleteFunc
         }));
         this.mFlipAnimation.append(new TweenLite(this.mySpecialization1,FLASH_DURATION,{"colorTransform":{"exposure":2}}));
         this.mFlipAnimation.append(new TweenLite(this.mySpecialization1,FLASH_DURATION,{"colorTransform":{"exposure":1}}));
         this.mFlipAnimation.play();
      }
      
      private function _clearImages() : void
      {
         while(this.myImageMount.numChildren > 0)
         {
            this.myImageMount.removeChildAt(0);
         }
      }
      
      private function onRollAnimComplete() : void
      {
         this._clearImages();
         this.mySpecializationLabel1.visible = this.myCurrentKey.visible = this.myRerollKey.visible = true;
         this.myHeader.text = LocalizeUtil.localize(DictHud.ZOMBIE_ARENA_SPECIALIZATION_REROLL_HEADER2);
         CFunctionInGameContainer.AS_ZombieArenaGamblerRollComplete();
         SoundUtil.getInstance().playSound("zmb_ui_gambler_pick");
         this.myRerollHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.handleAttackClicked);
         this.myCurrentHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDefenderClicked);
         this.myRerollHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.handleAttackerHover);
         this.myRerollHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleAttackerUnhover);
         this.myCurrentHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.handleDefenderHover);
         this.myCurrentHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleDefenderUnhover);
      }
      
      private function onRollAnimCompleteZSurv() : void
      {
         this._clearImages();
         this.mySpecializationLabel1.visible = true;
         SoundUtil.getInstance().playSound("zmb_ui_gambler_pick");
         this.mHideTimeout = setTimeout(this.hideTimeout,3000);
      }
      
      private function hideTimeout() : void
      {
         CFunctionInGameContainer.AS_ZombieArenaHandleSelection(1);
         clearTimeout(this.mHideTimeout);
      }
      
      private function playRollSound() : void
      {
         SoundUtil.getInstance().playSound("zmb_ui_gambler_roll");
      }
      
      private function handleAttackClicked(e:MouseEvent) : void
      {
         this.clearListeners();
         CFunctionInGameContainer.AS_ZombieArenaHandleSelection(1);
      }
      
      private function handleDefenderClicked(e:MouseEvent) : void
      {
         this.clearListeners();
         CFunctionInGameContainer.AS_ZombieArenaHandleSelection(0);
      }
      
      private function handleAttackerHover() : void
      {
         this.myRerollButtonBG.alpha = FOCUS_ALPHA;
      }
      
      private function handleAttackerUnhover() : void
      {
         this.myRerollButtonBG.alpha = UNFOCUS_ALPHA;
      }
      
      private function handleDefenderHover() : void
      {
         this.myCurrentButtonBG.alpha = FOCUS_ALPHA;
      }
      
      private function handleDefenderUnhover() : void
      {
         this.myCurrentButtonBG.alpha = UNFOCUS_ALPHA;
      }
      
      private function clearListeners() : void
      {
         this.myRerollHitArea.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleAttackClicked);
         this.myCurrentHitArea.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleDefenderClicked);
         this.myRerollHitArea.removeEventListener(MouseEvent.MOUSE_OVER,this.handleAttackerHover);
         this.myRerollHitArea.removeEventListener(MouseEvent.MOUSE_OUT,this.handleAttackerUnhover);
         this.myCurrentHitArea.removeEventListener(MouseEvent.MOUSE_OVER,this.handleDefenderHover);
         this.myCurrentHitArea.removeEventListener(MouseEvent.MOUSE_OUT,this.handleDefenderUnhover);
      }
   }
}


package codo.views.hudZombieArena
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.SoundUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Expo;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import fsg.util.FsgImageHolder;
   
   public class ZombieArenaGamblerHUD extends MovieClip
   {
      
      private static const SHOW_DURATION:Number = 0.15;
      
      private static const FLASH_DURATION:Number = 0.07;
      
      public var myImage:FsgImageHolder;
      
      public var myTitle:TextField;
      
      public var myDescription:TextField;
      
      public var myImageMount:MovieClip;
      
      private var mHideTimeout:uint;
      
      private var mFlipAnimation:TimelineLite;
      
      public function ZombieArenaGamblerHUD()
      {
         super();
         this.myTitle.alignment = TextStyle.HALIGN_CENTER;
         this.myTitle.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myTitle.fontColor = GlobalGuide.WHITE;
         this.myTitle.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myTitle.width = 400;
         this.myTitle.height = 40;
         this.myDescription.wordWrap = true;
         this.myDescription.multiline = true;
         this.myDescription.alignment = TextStyle.HALIGN_CENTER;
         this.myDescription.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myDescription.fontColor = GlobalGuide.WHITE;
         this.myDescription.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myDescription.width = 400;
         this.visible = false;
      }
      
      public function animateRoll(data:Object) : void
      {
         var image:FsgImageHolder = null;
         clearTimeout(this.mHideTimeout);
         this.visible = true;
         this._clearImages();
         this.myImage.alpha = this.myTitle.alpha = this.myDescription.alpha = 0;
         this.mFlipAnimation = new TimelineLite();
         var imgClass:Class = getDefinitionByName("hudZombieArenaGamblerIcon") as Class;
         var randomSkillImages:Array = data.randomSkillImages;
         var duration:Number = 0.05;
         for(var i:int = 0; i < randomSkillImages.length; i++)
         {
            image = new imgClass();
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
         this.myImage.setImage(data.image);
         this.myTitle.text = data.title;
         this.myDescription.text = data.desc;
         this.mFlipAnimation.append(new TweenLite(this.myImage,0.01,{
            "alpha":1,
            "onComplete":this.onRollAnimComplete
         }));
         this.mFlipAnimation.append(new TweenLite(this.myImage,FLASH_DURATION,{"colorTransform":{"exposure":2}}));
         this.mFlipAnimation.append(new TweenLite(this.myImage,FLASH_DURATION,{"colorTransform":{"exposure":1}}));
         this.mFlipAnimation.append(new TweenLite(this.myTitle,SHOW_DURATION,{"alpha":1}));
         this.mFlipAnimation.append(new TweenLite(this.myDescription,SHOW_DURATION,{"alpha":1}));
         this.mFlipAnimation.play();
      }
      
      private function hideTimeout() : void
      {
         this.visible = false;
         clearTimeout(this.mHideTimeout);
      }
      
      private function _clearImages() : void
      {
         while(this.myImageMount.numChildren > 0)
         {
            this.myImageMount.removeChildAt(0);
         }
      }
      
      private function playRollSound() : void
      {
         SoundUtil.getInstance().playSound("zmb_ui_gambler_roll");
      }
      
      private function onRollAnimComplete() : void
      {
         this._clearImages();
         CFunctionInGameContainer.AS_ZombieArenaGamblerRollComplete();
         SoundUtil.getInstance().playSound("zmb_ui_gambler_pick");
         this.mHideTimeout = setTimeout(this.hideTimeout,3000);
      }
   }
}


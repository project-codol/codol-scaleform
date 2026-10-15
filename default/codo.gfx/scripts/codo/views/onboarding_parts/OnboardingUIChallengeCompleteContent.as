package codo.views.onboarding_parts
{
   import codo.base.BaseSubElement;
   import codo.component.TextField;
   import codo.constants.GameInfo;
   import codo.localization.DictCareer;
   import codo.objects.OnboardingChecklistChallengeObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Linear;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.utils.setTimeout;
   
   public class OnboardingUIChallengeCompleteContent extends BaseSubElement
   {
      
      public var myTitleTF:TextField;
      
      public var myCompleteHeaderTF:TextField;
      
      public var myChallengeNameTF:TextField;
      
      public var myCard:Sprite;
      
      public var myParts:Sprite;
      
      public var myTitleMask:Sprite;
      
      public var myHeaderMask:Sprite;
      
      private var mTextBar:Sprite;
      
      private var mTextBarMask:Sprite;
      
      private var mOnComplete:Function;
      
      public function OnboardingUIChallengeCompleteContent()
      {
         super();
         var glow:GlowFilter = new GlowFilter(806783,0.5,15,15);
         var txtStyle:TextStyle = GlobalGuide.styleTextDescription;
         var bar:Shape = new Shape();
         var bar2:Shape = new Shape();
         var LOCALIZE:Function = LocalizeUtil.localize;
         txtStyle.multiLine = txtStyle.wordWrap = false;
         txtStyle.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myTitleTF.textStyle = txtStyle;
         txtStyle.font = GlobalGuide.FONT_FACE_BOLD;
         txtStyle.fontSize = 80;
         this.myCompleteHeaderTF.textStyle = txtStyle;
         this.myCompleteHeaderTF.filters = [glow];
         txtStyle.fontSize = 22;
         txtStyle.fontColor = 9292781;
         this.myChallengeNameTF.textStyle = txtStyle;
         this.myTitleTF.text = isDebugMode ? "任务" : LOCALIZE(DictCareer.CAREER_CATEGORY_CHALLENGE);
         this.myCompleteHeaderTF.text = isDebugMode ? "已完成!" : LOCALIZE(DictCareer.CAREER_CHALLENGE_COMPLETED);
         this.mTextBarMask = addChildAt(new Sprite(),0) as Sprite;
         this.mTextBar = addChildAt(new Sprite(),0) as Sprite;
         bar.graphics.beginFill(3643636,0.2);
         bar.graphics.drawRect(0,0,GameInfo.DEFAULT_WIDTH,50);
         bar.graphics.endFill();
         bar2.graphics.beginFill(16777215);
         bar2.graphics.drawRect(0,0,GameInfo.DEFAULT_WIDTH,80);
         bar2.graphics.endFill();
         this.mTextBar.addChild(bar);
         this.mTextBarMask.addChild(bar2);
         this.mTextBar.y = this.mTextBarMask.y = this.myCard.y + this.myCard.height * 0.5 + 15;
         this.mTextBar.mask = this.mTextBarMask;
         this.myCard.scaleX = this.myCard.scaleY = 0;
         this.myTitleTF.alpha = this.myCompleteHeaderTF.alpha = this.myChallengeNameTF.alpha = 0;
         deactive();
      }
      
      public function set onCompleteCallback(callback:Function) : void
      {
         this.mOnComplete = callback;
      }
      
      public function setChallenge(challengeData:OnboardingChecklistChallengeObj) : void
      {
         this.myChallengeNameTF.text = challengeData.name;
         this.myTitleTF.x = (GameInfo.DEFAULT_WIDTH - this.myTitleTF.textWidth) * 0.5;
         this.myCompleteHeaderTF.x = (GameInfo.DEFAULT_WIDTH - this.myCompleteHeaderTF.textWidth) * 0.5;
         this.myChallengeNameTF.x = (GameInfo.DEFAULT_WIDTH - this.myChallengeNameTF.textWidth) * 0.5;
      }
      
      public function animateIn() : void
      {
         super.active();
         this.myTitleMask.height = this.myHeaderMask.height = 0;
         this.mTextBar.scaleX = this.mTextBar.x = 0;
         TweenLite.to(this.myParts,0.2,{
            "alpha":0,
            "ease":Linear.easeIn
         });
         TweenLite.to(this.myTitleMask,0.4,{
            "height":44,
            "ease":Linear.easeIn
         });
         TweenLite.to(this.myHeaderMask,0.4,{
            "height":100,
            "ease":Linear.easeIn,
            "delay":0.1,
            "onComplete":this.showCard
         });
         this.myTitleTF.alpha = 0.6;
         this.myCompleteHeaderTF.alpha = 1;
         this.myCard.scaleX = this.myCard.scaleY = this.myCard.alpha = this.myParts.alpha = 0;
      }
      
      public function animateOut() : void
      {
         TweenLite.to(this.mTextBarMask,0.2,{
            "x":GameInfo.DEFAULT_WIDTH + 20,
            "ease":Linear.easeIn
         });
         TweenLite.to(this.myTitleMask,0.4,{
            "height":0,
            "ease":Linear.easeIn
         });
         TweenLite.to(this.myHeaderMask,0.4,{
            "height":0,
            "ease":Linear.easeIn,
            "delay":0.1,
            "onComplete":this.mOnComplete
         });
         TweenLite.to(this.myParts,0.2,{
            "alpha":0,
            "ease":Linear.easeIn
         });
         TweenLite.to(this.myCard,0.3,{
            "alpha":0,
            "scaleX":0,
            "scaleY":0,
            "ease":Back.easeIn,
            "delay":0.1
         });
         TweenLite.to(this.myChallengeNameTF,0.4,{
            "alpha":0,
            "ease":Linear.easeIn,
            "onComplete":this.onChallengeRevealed,
            "delay":0.1
         });
      }
      
      private function showCard() : void
      {
         this.myChallengeNameTF.alpha = 0;
         TweenLite.to(this.myCard,0.3,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "ease":Back.easeOut
         });
         TweenLite.to(this.mTextBar,0.2,{
            "scaleX":1,
            "ease":Linear.easeIn
         });
         TweenLite.to(this.myChallengeNameTF,0.4,{
            "alpha":1,
            "ease":Linear.easeIn,
            "onComplete":this.onChallengeRevealed,
            "delay":0.1
         });
         TweenLite.to(this.myParts,0.2,{
            "alpha":1,
            "ease":Linear.easeIn
         });
      }
      
      private function onChallengeRevealed() : void
      {
         setTimeout(this.animateOut,2000);
      }
   }
}


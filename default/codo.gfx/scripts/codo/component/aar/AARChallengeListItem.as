package codo.component.aar
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.diagram.CircleDiagram;
   import codo.localization.DictChallenge;
   import codo.objects.DailyChallengeObj;
   import codo.objects.MatchResultsChallengeObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class AARChallengeListItem extends UIInteractiveComponent
   {
      
      public var myBackground:MovieClip;
      
      public var myChallengeName:TextField;
      
      public var myChallengeDescription:TextField;
      
      public var myChallengeReward:TextField;
      
      public var myCompleteLabel:TextField;
      
      public var myPieChart:CircleDiagram;
      
      public var myColorBar:Sprite;
      
      public var mySmallColorBar:Sprite;
      
      public var myCompleteModule:MovieClip;
      
      public var myIcon:MovieClip;
      
      public var myLargeIcon:MovieClip;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      public function AARChallengeListItem()
      {
         super();
         this.mWidth = 461;
         this.mHeight = 153;
         this.myCompleteLabel = this.myCompleteModule["myCompleteLabel"];
         this.myCompleteLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myCompleteLabel.fontColor = 16776528;
         this.myCompleteLabel.text = LocalizeUtil.localize(DictChallenge.CHALLENGES_COMPLETED);
         this.myCompleteLabel.width = 128;
         this.myChallengeName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myChallengeName.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myChallengeDescription.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myChallengeDescription.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myChallengeReward.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myChallengeReward.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myChallengeName.width = this.mWidth;
         this.myChallengeDescription.width = 320;
         this.myChallengeReward.width = this.mWidth;
         this.myChallengeReward.height = 40;
         this.myChallengeName.height = 40;
         this.myCompleteModule.visible = false;
         this.myIcon.gotoAndStop(3);
         this.myLargeIcon.gotoAndStop(3);
         this.myPieChart.setParams(47.5,39.5,new Point(47.5,47.5));
         this.myPieChart.setTextType(CircleDiagram.TEXT_X_OF_Y);
      }
      
      override public function setData(data:*) : void
      {
         var challenge:MatchResultsChallengeObj = null;
         super.setData(data);
         challenge = data as MatchResultsChallengeObj;
         if(challenge == null)
         {
            visible = false;
            return;
         }
         visible = true;
         this.myChallengeName.text = LocalizeUtil.localize(challenge.name);
         var rewardText:String = challenge.getRewardText();
         this.myChallengeReward.text = rewardText;
         var challengeColor:Number = GlobalGuide.COMMON_CHALLENGE_COLOR;
         var dailyChallenge:DailyChallengeObj = data as DailyChallengeObj;
         if(dailyChallenge != null)
         {
            challengeColor = dailyChallenge.isPvp ? GlobalGuide.PVP_CHALLENGE_COLOR : GlobalGuide.PVE_CHALLENGE_COLOR;
         }
         else
         {
            challengeColor = GlobalGuide.COMMON_CHALLENGE_COLOR;
         }
         if(challenge.getFinished())
         {
            gotoAndStop(2);
            this.myCompleteModule.visible = true;
            this.myChallengeReward.fontSize = GlobalGuide.FONT_SIZE_LARGE;
            this.myChallengeReward.alignment = TextStyle.HALIGN_CENTER;
            this.myChallengeName.fontColor = 692168;
            this.myChallengeName.alignment = TextStyle.HALIGN_CENTER;
         }
         else
         {
            gotoAndStop(1);
            this.myCompleteModule.visible = false;
            this.myChallengeReward.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
            this.myChallengeReward.alignment = TextStyle.HALIGN_LEFT;
            this.myChallengeName.fontColor = GlobalGuide.WHITE;
            this.myChallengeName.alignment = TextStyle.HALIGN_LEFT;
            this.myChallengeDescription.text = challenge.description;
            this.myPieChart.setFillColor(challengeColor);
            this.myPieChart.setFillAmount(challenge.progress,challenge.target,challenge.gainedValue);
            this.myPieChart.playAnimation();
         }
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
   }
}


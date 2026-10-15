package codo.views.hudSpy
{
   import codo.localization.DictHud;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class ScoreNotificationPanel extends MovieClip
   {
      
      private static const SCORE_SOURCE_STAY_ALIVE:int = 0;
      
      private static const SCORE_SOURCE_ASSIST:int = 1;
      
      private static const SCORE_SOURCE_KILL_ENEMY:int = 2;
      
      private static const SCORE_SOURCE_CHECK_BODY:int = 3;
      
      private static const SCORE_SOURCE_MAKE_DAMAGE:int = 4;
      
      private static const SCORE_SOURCE_LIVE_TO_END:int = 5;
      
      public var myScore1:MovieClip;
      
      public var myScore2:MovieClip;
      
      public var myScore3:MovieClip;
      
      public var myScore4:MovieClip;
      
      public var myScore5:MovieClip;
      
      private var mEntries:Array;
      
      private var mAnchors:Array = [108,81,54,27,0];
      
      public function ScoreNotificationPanel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mEntries = [this.myScore1,this.myScore2,this.myScore3,this.myScore4,this.myScore5];
         for(var i:int = 0; i < this.mEntries.length; i++)
         {
            this.mEntries[i].visible = false;
         }
      }
      
      public function cppShowScoreNotification(data:Array) : void
      {
         var score:int = 0;
         var source:int = 0;
         var mc:MovieClip = null;
         for(var i:int = 0; i < data.length; i++)
         {
            score = int(data[i].score);
            source = int(data[i].source);
            mc = this.mEntries.pop();
            TweenLite.killTweensOf(mc);
            mc["myText"].text = this.getNotificationText(source,score);
            mc.alpha = 1;
            mc.visible = true;
            this.mEntries.unshift(mc);
            TweenLite.to(mc,0.5,{
               "delay":2,
               "alpha":0,
               "onCompleteCallback":this.onScoreEntryAnimComplete,
               "onCompleteParams":[mc]
            });
         }
         for(var j:int = 0; j < this.mEntries.length; j++)
         {
            this.mEntries[j].y = this.mAnchors[j];
         }
      }
      
      private function onScoreEntryAnimComplete(mc:MovieClip) : void
      {
         mc.visible = false;
      }
      
      private function getNotificationText(source:int, score:int) : String
      {
         var strSource:String = "";
         switch(source)
         {
            case SCORE_SOURCE_STAY_ALIVE:
               strSource = LocalizeUtil.localize(DictHud.SPY_SCORE_SOURCE_STAY_ALIVE);
               break;
            case SCORE_SOURCE_ASSIST:
               strSource = LocalizeUtil.localize(DictHud.SPY_SCORE_SOURCE_ASSIST);
               break;
            case SCORE_SOURCE_KILL_ENEMY:
               strSource = LocalizeUtil.localize(DictHud.SPY_SCORE_SOURCE_SKILL_ENEMY);
               break;
            case SCORE_SOURCE_CHECK_BODY:
               strSource = LocalizeUtil.localize(DictHud.SPY_SCORE_SOURCE_CHECK_BODY);
               break;
            case SCORE_SOURCE_MAKE_DAMAGE:
               strSource = LocalizeUtil.localize(DictHud.SPY_SCORE_SOURCE_MAKE_DAMAGE);
               break;
            case SCORE_SOURCE_LIVE_TO_END:
               strSource = LocalizeUtil.localize(DictHud.SPY_SCORE_SOURCE_ALIVE_TO_END);
         }
         return strSource + "+" + score.toString();
      }
   }
}


package codo.views.hudDMZ
{
   import codo.constants.GameInfo;
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class PlayerMatchResult extends MovieClip
   {
      
      public var myHeader:TextField;
      
      public var myKill:TextField;
      
      public var myDamageLabel:TextField;
      
      public var myRewardLabel:TextField;
      
      public var myDamage:TextField;
      
      public var myReward:TextField;
      
      public function PlayerMatchResult()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myHeader.text = LocalizeUtil.localize(DictDmz.RESPAWNING);
         this.myDamageLabel.text = LocalizeUtil.localize(DictDmz.MAKE_DAMAGE_LABEL);
         this.myRewardLabel.text = LocalizeUtil.localize(DictDmz.REWARD_LABEL);
      }
      
      public function setKills(kills:int) : void
      {
         var strKills:String = kills.toString();
         this.myKill.text = LocalizeUtil.param(DictDmz.NUM_KILLS,[strKills]);
         var index:int = this.myKill.text.indexOf(strKills);
         var textFormat:TextFormat = this.myKill.getTextFormat();
         textFormat.font = GameInfo.GAME_FONT_AENCY_FB;
         textFormat.size = 93;
         this.myKill.setTextFormat(textFormat,index,index + strKills.length);
      }
   }
}


package codo.views.hudDMZ
{
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PlayerCounter extends MovieClip
   {
      
      public var myScoreLabel:TextField;
      
      public var myAliveLabel:TextField;
      
      public function PlayerCounter()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myScoreLabel.text = LocalizeUtil.localize(DictDmz.GEAR_SCORE);
         this.myAliveLabel.text = LocalizeUtil.localize(DictDmz.ALIVE);
      }
   }
}


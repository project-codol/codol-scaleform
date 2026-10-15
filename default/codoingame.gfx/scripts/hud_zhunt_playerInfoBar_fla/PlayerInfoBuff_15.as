package hud_zhunt_playerInfoBar_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5272")]
   public dynamic class PlayerInfoBuff_15 extends MovieClip
   {
      
      public var myBG:MovieClip;
      
      public var myIcon:MovieClip;
      
      public var myText:TextField;
      
      public function PlayerInfoBuff_15()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         gotoAndPlay(2);
      }
   }
}


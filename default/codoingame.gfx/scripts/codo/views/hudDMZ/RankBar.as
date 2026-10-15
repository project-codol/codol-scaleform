package codo.views.hudDMZ
{
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class RankBar extends MovieClip
   {
      
      public var myRankLabel:TextField;
      
      public function RankBar()
      {
         super();
         this.myRankLabel.text = LocalizeUtil.localize(DictDmz.RANK);
      }
   }
}


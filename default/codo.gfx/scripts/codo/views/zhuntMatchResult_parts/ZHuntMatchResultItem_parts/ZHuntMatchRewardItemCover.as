package codo.views.zhuntMatchResult_parts.ZHuntMatchResultItem_parts
{
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class ZHuntMatchRewardItemCover extends MovieClip
   {
      
      public var myIcon:FsgImageHolder;
      
      public function ZHuntMatchRewardItemCover()
      {
         super();
      }
      
      public function set icon(icon:String) : void
      {
         this.myIcon.setImage(icon);
      }
   }
}


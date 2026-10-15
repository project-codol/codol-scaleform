package codo.views.helpMenu_parts.zhunt
{
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class FsgHelpMenuZhuntReward extends MovieClip
   {
      
      public var myIcon:FsgImageHolder;
      
      public function FsgHelpMenuZhuntReward()
      {
         super();
      }
      
      public function set icon(icon:String) : void
      {
         this.myIcon.setImage(icon);
      }
   }
}


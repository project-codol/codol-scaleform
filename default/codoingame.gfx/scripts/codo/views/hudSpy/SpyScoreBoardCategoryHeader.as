package codo.views.hudSpy
{
   import codo.component.TextField;
   import codo.style.SpyHudGuide;
   import flash.display.MovieClip;
   
   public class SpyScoreBoardCategoryHeader extends MovieClip
   {
      
      public var myCategoryTF:TextField;
      
      public function SpyScoreBoardCategoryHeader()
      {
         super();
         this.myCategoryTF.textStyle = SpyHudGuide.SpyScoreboardCategoryHeader;
      }
      
      public function set text(val:String) : void
      {
         this.myCategoryTF.text = val;
      }
   }
}


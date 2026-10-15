package codo.views.hudSpy
{
   import codo.component.TextField;
   import codo.localization.DictSpy;
   import codo.style.SpyHudGuide;
   import flash.display.MovieClip;
   
   public class SpyAutopsyListHeader extends MovieClip
   {
      
      public var myHeaderTF:TextField;
      
      public function SpyAutopsyListHeader()
      {
         super();
         this.myHeaderTF.textStyle = SpyHudGuide.SpyScoreboardCategoryHeader;
         this.myHeaderTF.text = DictSpy.AUTOPSY_LIST_HEADER;
      }
   }
}


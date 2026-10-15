package codo.views.hudZombieArena
{
   import codo.common.CFunctionCommonContainer;
   import codo.objects.ZombieChampionObj;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class ZombieChampionHealthbar extends MovieClip
   {
      
      public var myImage:FsgImageHolder;
      
      public function ZombieChampionHealthbar()
      {
         super();
      }
      
      public function cppSetChampionData(championID:uint) : void
      {
         var champion:ZombieChampionObj = CFunctionCommonContainer.AS_GetZombieChampionForClassID(championID) as ZombieChampionObj;
         this.myImage.setImage(champion.bustImageURL);
      }
   }
}


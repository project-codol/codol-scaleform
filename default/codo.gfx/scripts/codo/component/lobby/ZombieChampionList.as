package codo.component.lobby
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.event.ParaEvent;
   import codo.objects.ZombieChampionObj;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   
   public class ZombieChampionList extends MovieClip
   {
      
      public static const EVENT_CHAMPION_SELECTED:String = "evt_champion_selected";
      
      public var myChampion0:ZombieChampionListItem;
      
      public var myChampion1:ZombieChampionListItem;
      
      public var myChampion2:ZombieChampionListItem;
      
      public var myChampion3:ZombieChampionListItem;
      
      public var myHeader:TextField;
      
      private var mChampions:Vector.<ZombieChampionListItem>;
      
      public function ZombieChampionList()
      {
         super();
         this.mChampions = new <ZombieChampionListItem>[this.myChampion0,this.myChampion1,this.myChampion2,this.myChampion3];
      }
      
      public function init() : void
      {
         var currentChampion:ZombieChampionObj = null;
         var champion:ZombieChampionObj = null;
         var currentChampionID:uint = CFunctionCommonContainer.AS_GetSelectedChampionClassID();
         for(var i:int = 0; i < this.mChampions.length; i++)
         {
            champion = CFunctionCommonContainer.AS_GetZombieChampionForClassID(ZombieChampionObj.ORDERED_CLASSES[i]) as ZombieChampionObj;
            champion.index = i;
            champion.useLargeImage = true;
            this.mChampions[i].setData(champion);
            this.mChampions[i].registerClickEvent(this.onChampionClicked,champion);
            if(currentChampionID == champion.id)
            {
               currentChampion = champion;
            }
         }
         if(currentChampion == null)
         {
            currentChampion = this.myChampion0.getData() as ZombieChampionObj;
         }
         this.onChampionClicked(currentChampion);
      }
      
      public function show() : void
      {
         var listItemX:Number = NaN;
         var i:int = 0;
         for(i = 0; i < this.mChampions.length; i++)
         {
            TweenLite.killTweensOf(this.mChampions[i],true);
            listItemX = this.mChampions[i].x;
            this.mChampions[i].alpha = 0;
            this.mChampions[i].x = listItemX - 50;
            TweenLite.to(this.mChampions[i],0.2,{
               "alpha":1,
               "x":listItemX,
               "delay":i * 0.05,
               "ease":Cubic.easeOut
            });
         }
         this.visible = true;
      }
      
      private function onChampionClicked(champion:ZombieChampionObj) : void
      {
         var championCompare:ZombieChampionObj = null;
         var len:int = int(this.mChampions.length);
         for(var i:int = 0; i < len; i++)
         {
            championCompare = this.mChampions[i].getData() as ZombieChampionObj;
            this.mChampions[i].setToggled(champion.id == championCompare.id);
         }
         dispatchEvent(new ParaEvent(EVENT_CHAMPION_SELECTED,champion));
      }
   }
}


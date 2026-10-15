package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.localization.DictWarGod;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.WarGodGuide;
   import flash.display.MovieClip;
   
   public class WarGodPlacementProgressBar extends MovieClip implements IWarGodUIElement
   {
      
      public var myBM0:MovieClip;
      
      public var myBM1:MovieClip;
      
      public var myBM2:MovieClip;
      
      public var myBM3:MovieClip;
      
      public var myBM4:MovieClip;
      
      public var myBM5:MovieClip;
      
      public var myBM6:MovieClip;
      
      public var myBM7:MovieClip;
      
      public var myBM8:MovieClip;
      
      public var myBM9:MovieClip;
      
      public var myTextIndicator:TextField;
      
      private var myMatchIndicator:Array;
      
      public function WarGodPlacementProgressBar()
      {
         super();
         this.myTextIndicator.textStyle = WarGodGuide.styleWarGodProgressTextIndicator;
         this.myTextIndicator.width = 1022;
         this.myTextIndicator.height = 25;
         this.myTextIndicator.x = 0;
         this.myTextIndicator.y = -45;
         this.myMatchIndicator = [this.myBM0,this.myBM1,this.myBM2,this.myBM3,this.myBM4,this.myBM5,this.myBM6,this.myBM7,this.myBM8,this.myBM9];
         this.myTextIndicator.text = DictWarGod.PLACEMENT_MATCH_PROGRESS_LABEL;
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var i:int = 0;
         var numPlacementMatchComplete:int = playerObj.numPlacementMatchCompleted;
         i = 0;
         while(i < numPlacementMatchComplete && i < this.myMatchIndicator.length)
         {
            this.myMatchIndicator[i].gotoAndStop(WarGodGuide.MATCH_INDICATOR_MATCHED_FRAME);
            i++;
         }
         while(i < this.myMatchIndicator.length)
         {
            this.myMatchIndicator[i].gotoAndStop(WarGodGuide.MATCH_INDICATOR_UNMATCH_FRAME);
            i++;
         }
         if(numPlacementMatchComplete >= 0 && numPlacementMatchComplete < this.myMatchIndicator.length)
         {
            this.myMatchIndicator[numPlacementMatchComplete].gotoAndStop(WarGodGuide.MATCH_INDICATOR_PENDING_FRAME);
         }
      }
   }
}


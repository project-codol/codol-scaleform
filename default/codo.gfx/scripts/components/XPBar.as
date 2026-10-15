package components
{
   import codo.event.ParaEvent;
   import codo.objects.EXPLevelObj;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import com.greensock.easing.Linear;
   import components.interfaces.IUIComponent;
   import flash.display.Sprite;
   
   public class XPBar extends Sprite implements IUIComponent
   {
      
      public static const EVT_COMPLETE:String = "evt_complete";
      
      public static const EVT_NODE_START:String = "evt_node_start";
      
      private static const TWEEN_SPD_PER_BAR:Number = 0.8;
      
      public var myBar:Sprite;
      
      public var myBarMask:Sprite;
      
      private var _currentRatio:Number = 0;
      
      private var _currentSpeed:Number = 1;
      
      private var _increaseExpLvObjs:Vector.<EXPLevelObj>;
      
      private var _currentPlayingNodeIndex:uint = 0;
      
      private var mUpdateCallback:Function;
      
      public function XPBar()
      {
         super();
         this.onInit();
      }
      
      protected function onInit() : void
      {
         this.myBar.mask = this.myBarMask;
      }
      
      public function set updateCallback(callback:Function) : void
      {
         this.mUpdateCallback = callback;
      }
      
      public function set XPData(cDat:Vector.<EXPLevelObj>) : void
      {
         this._increaseExpLvObjs = cDat;
      }
      
      public function play() : void
      {
         if(this._increaseExpLvObjs != null)
         {
            this._currentPlayingNodeIndex = 0;
            this.nextExp();
         }
      }
      
      private function nextExp() : void
      {
         var tempEXPLevelObj:EXPLevelObj = null;
         var tempNextEXPLevelObj:EXPLevelObj = null;
         var tempCurrent:Number = NaN;
         var exactlyOne:Boolean = false;
         var tempTarget:Number = 1;
         var ease:Function = Linear.easeNone;
         if(this._currentPlayingNodeIndex < this._increaseExpLvObjs.length)
         {
            tempEXPLevelObj = new EXPLevelObj(this._increaseExpLvObjs[this._currentPlayingNodeIndex]);
            if(this._currentPlayingNodeIndex == 0)
            {
               tempNextEXPLevelObj = new EXPLevelObj(this._increaseExpLvObjs[this._currentPlayingNodeIndex + 1]);
               if(tempNextEXPLevelObj != null && tempNextEXPLevelObj.displayRank == tempEXPLevelObj.displayRank)
               {
                  tempCurrent = tempEXPLevelObj.current / tempEXPLevelObj.total;
                  tempTarget = tempNextEXPLevelObj.current / tempNextEXPLevelObj.total;
                  ++this._currentPlayingNodeIndex;
                  ease = Cubic.easeInOut;
               }
               else
               {
                  tempCurrent = tempEXPLevelObj.current / tempEXPLevelObj.total;
                  tempTarget = 1;
                  exactlyOne = tempNextEXPLevelObj != null && tempNextEXPLevelObj.current == 0;
                  ease = !exactlyOne ? Cubic.easeIn : Cubic.easeInOut;
               }
            }
            else if(this._currentPlayingNodeIndex == this._increaseExpLvObjs.length - 1)
            {
               tempTarget = tempEXPLevelObj.current / tempEXPLevelObj.total;
               tempCurrent = 0;
               ease = Cubic.easeOut;
            }
            else
            {
               tempCurrent = 0;
            }
            this.dispatchEvent(new ParaEvent(EVT_NODE_START,{"index":this._currentPlayingNodeIndex}));
            ++this._currentPlayingNodeIndex;
            this._currentRatio = tempCurrent;
            this.myBarMask.scaleX = tempCurrent;
            TweenLite.killTweensOf(this.myBarMask);
            TweenLite.to(this.myBarMask,tempCurrent != tempTarget ? TWEEN_SPD_PER_BAR : 0,{
               "scaleX":tempTarget,
               "ease":ease,
               "onUpdate":this.onTweenUpdateHandle,
               "onComplete":this.onTweenCompleteHandle
            });
         }
      }
      
      private function onTweenUpdateHandle() : void
      {
         this._currentRatio = this.myBarMask.scaleX;
         if(this.mUpdateCallback != null)
         {
            this.mUpdateCallback(this.myBarMask.scaleX);
         }
      }
      
      private function onTweenCompleteHandle() : void
      {
         if(this._currentPlayingNodeIndex >= this._increaseExpLvObjs.length)
         {
            this.dispatchEvent(new ParaEvent(EVT_COMPLETE));
         }
         else
         {
            this.nextExp();
         }
      }
      
      public function destroy() : void
      {
      }
   }
}


package codo.component.social
{
   import codo.component.Button;
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.objects.RightClickCustomData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PlayerActionButton extends Button
   {
      
      private const CONTEXT_MENU_ANCHOR_OFFSET:int = 60;
      
      public var myTab:MovieClip;
      
      private var mType:String = "full";
      
      private var mName:String;
      
      private var mID:String;
      
      private var mCustomData:RightClickCustomData;
      
      public function PlayerActionButton()
      {
         super();
         this.endHighlight();
         myHitArea.addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         this.myTab.gotoAndStop(OVER_STATE_FRAME);
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         this.myTab.gotoAndStop(mUpStateFrame);
      }
      
      public function setType(value:String) : void
      {
         this.mType = value;
      }
      
      public function setNameAndID(playerName:String, playerID:String) : void
      {
         this.mName = playerName;
         this.mID = playerID;
      }
      
      public function set customData(data:RightClickCustomData) : void
      {
         this.mCustomData = data;
      }
      
      private function onClickHandler(e:MouseEvent) : void
      {
         e.stopPropagation();
         var anchor1:Point = localToGlobal(new Point(myHitArea.x - this.CONTEXT_MENU_ANCHOR_OFFSET / scaleX,myHitArea.y));
         var anchor2:Point = localToGlobal(new Point(myHitArea.x + myHitArea.width,myHitArea.y + myHitArea.height));
         EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_PLAYER_CONTEXT_MENU,[this.mType,this.mID,this.mName,anchor1,anchor2,this.mCustomData]);
      }
   }
}


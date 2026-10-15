package codo.component.matchselect
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.style.GlobalGuide;
   import codo.style.MatchSelectGuide;
   import flash.display.Sprite;
   
   public class RoomItem extends UIInteractiveComponent implements ISelectable
   {
      
      public var myLockIcon:Sprite;
      
      public var myRoomName:TextField;
      
      public var myRoomPlayer:TextField;
      
      private var mSelected:Boolean = false;
      
      public function RoomItem()
      {
         super();
         isInteractiveEnabled = true;
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myRoomName.textStyle = MatchSelectGuide.styleRoomName;
         this.myRoomName.width = 265;
         this.myRoomName.height = 34;
         this.myRoomName.enableTruncate(true);
         this.myRoomPlayer.textStyle = MatchSelectGuide.styleRoomPlayerNum;
         this.myRoomPlayer.width = 55;
         this.myRoomPlayer.height = 34;
         this.myRoomPlayer.x = 305;
         this.myRoomPlayer.y = 0;
         gotoAndStop(1);
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(data == null)
         {
            visible = false;
            return;
         }
         visible = true;
         this.myLockIcon.visible = data.password != "";
         this.myRoomName.text = data.name;
         this.myRoomPlayer.text = String(data.currentPlayers);
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      public function set selected(sel:Boolean) : void
      {
         this.mSelected = sel;
         if(sel)
         {
            gotoAndStop(2);
            this.myRoomName.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
            this.myRoomPlayer.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         }
         else
         {
            gotoAndStop(1);
            this.myRoomName.fontColor = GlobalGuide.WHITE;
            this.myRoomPlayer.fontColor = GlobalGuide.WHITE;
         }
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
   }
}


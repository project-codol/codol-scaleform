package components.fsggamelobby_part
{
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.manager.EventManager;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import fsg.gamelobby.dsRoomInfo;
   
   public class LobbyDevPanel extends MovieClip
   {
      
      public var myLocalServerButton:MovieClip;
      
      public var myRefreshButton:MovieClip;
      
      public var myDedicatedServerButton:MovieClip;
      
      public var myRooms:MovieClip;
      
      private var m_iSelectedRoom:int = -1;
      
      public function LobbyDevPanel()
      {
         super();
         this.myLocalServerButton.myServerText.myText.text = "LS";
         this.myDedicatedServerButton.myServerText.myText.text = "DS";
      }
      
      public function initListener() : void
      {
         this.myLocalServerButton.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.myLocalServerButton.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.myLocalServerButton.addEventListener(MouseEvent.CLICK,this.onStartLocalServer);
         this.myRefreshButton.myHitArea.addEventListener(MouseEvent.CLICK,this.onRefreshDSBtnClickHandle);
         this.myDedicatedServerButton.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.myDedicatedServerButton.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.myDedicatedServerButton.addEventListener(MouseEvent.CLICK,this.onStartDedicatedServer);
         EventManager.getInstance().listen(BCEvent.ON_DEDICATED_SERVER_LISTED,this.onDedicatedServerListedHandle);
         this.myRooms.myDSRoomHolder.addEventListener(MouseEvent.MOUSE_WHEEL,this.onListWheelHandle);
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         e.currentTarget.gotoAndStop(2);
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         e.currentTarget.gotoAndStop(1);
      }
      
      private function onRefreshDSBtnClickHandle(cEvt:MouseEvent) : void
      {
         var roomInfo:DSRoomInfo = null;
         var obj:Object = null;
         this.m_iSelectedRoom = -1;
         if(ScaleformUtil.isScaleform)
         {
            EventManager.getInstance().broadcast(BCEvent.LIST_DEDICATED_SERVER,false);
         }
         else
         {
            roomInfo = new dsRoomInfo();
            obj = new Object();
            obj.hostName = "host name";
            obj.currentPlayers = 1;
            obj.currentMaxPlayers = 19;
            obj.name = "room name";
            obj.isFree = true;
            roomInfo.setInfo(obj,this.myRooms.myDSRoomHolder.numChildren);
            roomInfo.y = this.myRooms.myDSRoomHolder.numChildren * roomInfo.height;
            roomInfo.addClickCallback(this.selectRoom);
            this.myRooms.myDSRoomHolder.addChild(roomInfo);
         }
      }
      
      private function onDedicatedServerListedHandle(cEvt:ParaEvent) : void
      {
         var roomInfo:DSRoomInfo = null;
         while(this.myRooms.myDSRoomHolder.numChildren > 0)
         {
            this.myRooms.myDSRoomHolder.removeChildAt(0);
         }
         var data:Object = cEvt.myPara;
         for(var i:int = 0; i < data.length; i++)
         {
            roomInfo = new dsRoomInfo();
            roomInfo.setInfo(data[i],i);
            roomInfo.y = roomInfo.height * i;
            roomInfo.addClickCallback(this.selectRoom);
            this.myRooms.myDSRoomHolder.addChild(roomInfo);
         }
      }
      
      private function onStartLocalServer(e:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCEvent.START_MATCH,{
            "useDS":false,
            "index":-1
         });
      }
      
      private function onStartDedicatedServer(e:MouseEvent) : void
      {
         if(this.m_iSelectedRoom != -1)
         {
            EventManager.getInstance().broadcast(BCEvent.START_MATCH,{
               "useDS":true,
               "index":this.m_iSelectedRoom
            });
         }
      }
      
      private function selectRoom(i:int) : void
      {
         var roomInfo:DSRoomInfo = null;
         var iLen:int = int(this.myRooms.myDSRoomHolder.numChildren);
         for(var index:int = 0; index < iLen; index++)
         {
            roomInfo = this.myRooms.myDSRoomHolder.getChildAt(index);
            roomInfo.select(i == index);
         }
         this.m_iSelectedRoom = i;
      }
      
      private function onListWheelHandle(cEvt:MouseEvent) : void
      {
         if(this.myRooms.myDSRoomHolder.height > 147)
         {
            this.myRooms.myDSRoomHolder.y += cEvt.delta * 10;
            if(this.myRooms.myDSRoomHolder.y > 0)
            {
               this.myRooms.myDSRoomHolder.y = 0;
            }
            else if(this.myRooms.myDSRoomHolder.y < 147 - this.myRooms.myDSRoomHolder.height)
            {
               this.myRooms.myDSRoomHolder.y = 147 - this.myRooms.myDSRoomHolder.height;
            }
         }
      }
   }
}


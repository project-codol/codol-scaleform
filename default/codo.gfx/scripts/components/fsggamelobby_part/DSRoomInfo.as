package components.fsggamelobby_part
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class DSRoomInfo extends MovieClip
   {
      
      public var myHostName:TextField;
      
      public var myRoomCapacityCurrent:TextField;
      
      public var myRoomCapacityMax:TextField;
      
      public var myRoomName:TextField;
      
      public var myRoomStatus:MovieClip;
      
      public var myBackground:MovieClip;
      
      private var m_index:int;
      
      private var m_clickedCallback:Function;
      
      private var m_selected:Boolean;
      
      public function DSRoomInfo()
      {
         super();
      }
      
      public function setInfo(data:Object, index:int) : void
      {
         this.myHostName.text = data.hostName;
         this.myRoomCapacityCurrent.text = data.currentPlayers.toString();
         this.myRoomCapacityMax.text = " / " + data.currentMaxPlayers.toString();
         this.myRoomName.text = data.name;
         this.myRoomStatus.gotoAndStop(Boolean(data.isFree) ? 1 : 2);
         this.m_index = index;
         this.m_selected = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      public function addClickCallback(func:Function) : void
      {
         this.m_clickedCallback = func;
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         this.myBackground.gotoAndStop(2);
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         this.myBackground.gotoAndStop(this.m_selected ? 3 : 1);
      }
      
      private function onMouseClick(e:MouseEvent) : void
      {
         if(this.m_clickedCallback != null)
         {
            this.m_clickedCallback(this.m_index);
         }
         this.m_selected = true;
      }
      
      public function select(flag:Boolean) : void
      {
         if(this.m_selected != flag)
         {
            this.myBackground.gotoAndStop(flag ? 3 : 1);
         }
         this.m_selected = flag;
      }
   }
}


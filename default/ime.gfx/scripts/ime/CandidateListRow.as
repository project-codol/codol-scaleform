package ime
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CandidateListRow extends MovieClip
   {
      
      public var bkGround_mc:MovieClip;
      
      public var currentState:String = "UnSelected";
      
      public var Value:TextField;
      
      public var ID:TextField;
      
      public var controller:Object;
      
      public var TextColor:Number = 2105376;
      
      public var TextColorSelected:Number = 16777215;
      
      private var _selected:Boolean = false;
      
      public function CandidateListRow()
      {
         super();
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandle);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandle);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.pressHandler);
         this.addEventListener(MouseEvent.MOUSE_UP,this.releaseHandler);
      }
      
      public function setController(_controller:Object = null) : void
      {
         this.controller = _controller;
      }
      
      private function onMouseOverHandle(cEvt:MouseEvent) : void
      {
         this.GotoOnState();
      }
      
      private function onMouseOutHandle(cEvt:MouseEvent) : void
      {
         if(this._selected == false)
         {
            this.GotoOffState();
         }
      }
      
      internal function pressHandler(event:MouseEvent) : *
      {
         MovieClip(parent).ClickedOnCandidateList = true;
         this.controller.SelectItem(this.name);
      }
      
      internal function releaseHandler(event:MouseEvent) : *
      {
      }
      
      public function set selected(cSwi:Boolean) : void
      {
         if(this._selected != cSwi)
         {
            this._selected = cSwi;
         }
      }
      
      public function GotoOffState() : *
      {
         if(this.bkGround_mc != null)
         {
            this.controller.DisplayInfo(name);
            this.bkGround_mc.gotoAndStop(1);
            this.Value.textColor = this.ID.textColor = this.TextColor;
         }
         this.currentState = "UnSelected";
      }
      
      public function GotoOnState() : *
      {
         if(this.bkGround_mc != null)
         {
            this.controller["DisplayInfo"](name);
            this.bkGround_mc.gotoAndStop(2);
            this.Value.textColor = this.ID.textColor = this.TextColorSelected;
         }
         this.currentState = "Selected";
      }
   }
}


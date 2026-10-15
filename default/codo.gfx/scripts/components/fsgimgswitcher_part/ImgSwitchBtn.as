package components.fsgimgswitcher_part
{
   import codo.event.ParaEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ImgSwitchBtn extends MovieClip
   {
      
      public static const EVT_CLICK:String = "evt_click";
      
      private static const TF_COLOR_NORMAL:uint = 8355711;
      
      private static const TF_COLOR_FOCUS:uint = 16777215;
      
      public var myNumTF:TextField;
      
      public var myBg:MovieClip;
      
      private var _selected:Boolean = false;
      
      public function ImgSwitchBtn()
      {
         super();
         this.myBg.gotoAndStop(1);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandle);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandle);
         this.addEventListener(MouseEvent.CLICK,this.onMouseClickHandle);
      }
      
      public function set text(cTxt:String) : void
      {
      }
      
      public function set selected(cSwi:Boolean) : void
      {
         this._selected = cSwi;
         if(this._selected == true)
         {
            this.myBg.gotoAndStop(2);
            this.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandle);
         }
         else
         {
            this.myBg.gotoAndStop(1);
            this.addEventListener(MouseEvent.CLICK,this.onMouseClickHandle);
         }
      }
      
      private function onMouseClickHandle(cEvt:MouseEvent) : void
      {
         if(this._selected == false)
         {
            this.dispatchEvent(new ParaEvent(EVT_CLICK));
         }
      }
      
      private function onMouseOverHandle(cEvt:MouseEvent) : void
      {
         if(this._selected == false)
         {
            this.myBg.gotoAndStop(3);
         }
      }
      
      private function onMouseOutHandle(cEvt:MouseEvent) : void
      {
         if(this._selected == false)
         {
            this.myBg.gotoAndStop(1);
         }
      }
   }
}


package components.fsgimgswitcher_part
{
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.utils.CursorUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import fsg.util.FsgAudioUtil;
   
   public class ImgSwitcher extends Sprite
   {
      
      public static const EVT_CHANGED:String = "evt_changed";
      
      private static const IMG_BTN_NAME:String = "myImg_";
      
      private static const MAX_BTN:uint = 5;
      
      private static const AUTO_PAGE_FLIP_INTERVAL:uint = 5000;
      
      private static const AUTO_PAGE_FLIP_STEP:uint = 50;
      
      public var myProgressBar:Sprite;
      
      private var _imgBtns:Vector.<ImgSwitchBtn> = new Vector.<ImgSwitchBtn>(0);
      
      private var _selectedImgBtn:ImgSwitchBtn;
      
      private var _imgCount:uint = 5;
      
      private var _imgWidth:uint;
      
      private var _autoPageFlipTimer:Timer;
      
      private var _autoPageFlipTimeCount:uint = 0;
      
      private var _btnGap:uint;
      
      public function ImgSwitcher()
      {
         super();
         this.myProgressBar.visible = false;
         this._autoPageFlipTimer = new Timer(AUTO_PAGE_FLIP_STEP);
         this._autoPageFlipTimer.addEventListener(TimerEvent.TIMER,this.onAutoFlipTimerHandle);
         for(var i:uint = 0; i < MAX_BTN; i++)
         {
            this._imgBtns.push(this[IMG_BTN_NAME + i]);
            this._imgBtns[i].text = String(i + 1);
            this._imgBtns[i].addEventListener(ImgSwitchBtn.EVT_CLICK,this.onImgBtnClickHandle);
            this._imgBtns[i].addEventListener(MouseEvent.MOUSE_OVER,this.onImgBtnMouseHandle);
            this._imgBtns[i].addEventListener(MouseEvent.MOUSE_OUT,this.onImgBtnMouseHandle);
         }
         this._btnGap = this._imgBtns[1].x - (this._imgBtns[0].x + this._imgBtns[0].width);
         this._selectedImgBtn = this._imgBtns[0];
         this._selectedImgBtn.selected = true;
         this.imgWidth = this.myProgressBar.width + 2;
      }
      
      public function set autoPageFlipEnable(cSwi:Boolean) : void
      {
         if(cSwi == true)
         {
            this._autoPageFlipTimer.start();
         }
         else
         {
            this._autoPageFlipTimer.stop();
         }
      }
      
      public function set imgWidth(cSize:uint) : void
      {
         this._imgWidth = cSize;
         this.myProgressBar.width = this._imgWidth - 2;
         this.refreshBtnPos();
      }
      
      public function set imgCount(cCount:uint) : void
      {
         this._imgCount = cCount;
         for(var i:uint = 0; i < MAX_BTN; i++)
         {
            this._imgBtns[i].visible = i < this._imgCount;
         }
         if(this._imgCount > 1)
         {
            this._autoPageFlipTimeCount = 0;
            this._autoPageFlipTimer.start();
         }
         else
         {
            this._autoPageFlipTimer.stop();
         }
         this.refreshBtnPos();
      }
      
      public function set selectedIndex(cIndex:uint) : void
      {
         if(this._selectedImgBtn != null)
         {
            this._selectedImgBtn.selected = false;
         }
         this._selectedImgBtn = this._imgBtns[cIndex];
         this._selectedImgBtn.selected = true;
      }
      
      private function onImgBtnClickHandle(cEvt:ParaEvent) : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT);
         this._autoPageFlipTimeCount = 0;
         var tempIndex:uint = uint((cEvt.target as ImgSwitchBtn).name.split(IMG_BTN_NAME)[1]);
         this.selectedIndex = tempIndex;
         this.dispatchEvent(new ParaEvent(EVT_CHANGED,{"index":tempIndex}));
      }
      
      private function onAutoFlipTimerHandle(cEvt:TimerEvent) : void
      {
         this._autoPageFlipTimeCount += AUTO_PAGE_FLIP_STEP;
         this.myProgressBar.scaleX = this._autoPageFlipTimeCount / AUTO_PAGE_FLIP_INTERVAL;
         if(this._autoPageFlipTimeCount >= AUTO_PAGE_FLIP_INTERVAL)
         {
            this.switchToNextImg();
         }
      }
      
      private function switchToNextImg() : void
      {
         var tempSelectedIndex:uint = 0;
         if(this._selectedImgBtn != null)
         {
            this._autoPageFlipTimeCount = 0;
            tempSelectedIndex = uint(this._selectedImgBtn.name.split(IMG_BTN_NAME)[1]);
            if(tempSelectedIndex >= this._imgCount - 1)
            {
               tempSelectedIndex = 0;
            }
            else
            {
               tempSelectedIndex++;
            }
            this.selectedIndex = tempSelectedIndex;
            this.dispatchEvent(new ParaEvent(EVT_CHANGED,{"index":tempSelectedIndex}));
         }
      }
      
      private function onImgBtnMouseHandle(cEvt:MouseEvent) : void
      {
         if(cEvt.type == MouseEvent.MOUSE_OVER)
         {
            this.autoPageFlipEnable = false;
            CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         }
         else
         {
            this.autoPageFlipEnable = true;
            CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         }
      }
      
      private function refreshBtnPos() : void
      {
         var tempTotalWidth:uint = this._imgCount * this[IMG_BTN_NAME + 0].width + (this._imgCount - 1) * this._btnGap;
         var tempPosX:int = (this._imgWidth - 2) / 2 - tempTotalWidth / 2;
         for(var i:uint = 0; i < this._imgCount; i++)
         {
            this._imgBtns[i].x = tempPosX;
            tempPosX += this._imgBtns[i].width + this._btnGap;
         }
      }
   }
}


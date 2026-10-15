package components.combobox_part
{
   import codo.event.ParaEvent;
   import components.CodoGrowButton;
   import flash.events.Event;
   import flash.text.TextFieldType;
   
   public class ComboBoxBtn extends CodoGrowButton
   {
      
      private static const COLOR_TEXT:Array = [16777215,15984074];
      
      public static const EVT_IPT_CHANGED:String = "evt_ipt_changed";
      
      private var _originTFColor:uint;
      
      private var _focusTFColor:int = -1;
      
      public function ComboBoxBtn()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.onStyleChangeForMatchType();
      }
      
      public function set inputAble(cSwi:Boolean) : void
      {
         if(cSwi == true)
         {
            this.addChild(this.myLabel);
            this.myLabel.type = TextFieldType.INPUT;
            this.myLabel.selectable = true;
            this.myLabel.mouseEnabled = true;
            this.myLabel.addEventListener(Event.CHANGE,this.onLabelIptChangeHandle);
         }
         else
         {
            this.addChild(this.myHitArea);
            this.myLabel.type = TextFieldType.DYNAMIC;
            this.myLabel.selectable = false;
            this.myLabel.mouseEnabled = false;
            this.myLabel.removeEventListener(Event.CHANGE,this.onLabelIptChangeHandle);
         }
      }
      
      override public function set data(cDat:*) : void
      {
         if(this.myLabel != null && cDat != null)
         {
            if(cDat is String)
            {
               this.myLabel.text = cDat;
            }
            else
            {
               this.myLabel.text = cDat.name || cDat.label || "";
            }
         }
      }
      
      [Inspectable(type="Color",defaultValue="#ffffff")]
      public function set textFocusColour(cUint:int) : void
      {
         this._focusTFColor = cUint;
         this._originTFColor = this.myLabel.textColor;
      }
      
      public function get inputAble() : Boolean
      {
         var tempResult:Boolean = false;
         if(this.myLabel.type == TextFieldType.INPUT)
         {
            tempResult = true;
         }
         return tempResult;
      }
      
      private function onLabelIptChangeHandle(cEvt:Event) : void
      {
         this.dispatchEvent(new ParaEvent(EVT_IPT_CHANGED,{"text":this.myLabel.text}));
      }
      
      override protected function setToNormal(cTween:Boolean = true) : void
      {
         if(this._focusTFColor != -1)
         {
            this.myLabel.textColor = this._originTFColor;
         }
         this.myBgNormal.visible = true;
         this.myBgFocus.visible = false;
      }
      
      override protected function setToRollOver(cTween:Boolean = true) : void
      {
         if(this._focusTFColor != -1)
         {
            this.myLabel.textColor = this._focusTFColor;
         }
         this.myBgNormal.visible = false;
         this.myBgFocus.visible = true;
      }
      
      override public function onStyleChangeForMatchType() : void
      {
         if(this.myBgNormal.totalFrames > 1)
         {
            this.myLabel.textColor = COLOR_TEXT[this.currentMatchType];
            this.myBgNormal.gotoAndStop(this.currentMatchType + 1);
            this.myBgFocus.gotoAndStop(this.currentMatchType + 1);
         }
      }
   }
}


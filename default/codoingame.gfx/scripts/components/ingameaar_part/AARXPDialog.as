package components.ingameaar_part
{
   import codo.event.ParaEvent;
   import codo.localization.DictInGame;
   import codo.objects.AARXPDetailsObj;
   import components.BaseButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import shaui.component.core.UIComponent;
   
   public class AARXPDialog extends UIComponent
   {
      
      public static var HIDE_DETAILS:String = "hide_details";
      
      public var myTitleTF:TextField;
      
      public var myCloseBtn:HudDialogCloseBtn;
      
      public var myIntroTF:TextField;
      
      public var myBkg:Sprite;
      
      public var mySep0:Sprite;
      
      public var mySep1:Sprite;
      
      public var mySep2:Sprite;
      
      public var myItem0:AARXPModItem;
      
      public var myItem1:AARXPModItem;
      
      protected var _seps:Vector.<Sprite>;
      
      protected var _items:Vector.<AARXPModItem>;
      
      protected var _bkgMaxHeight:Number;
      
      protected var _closeBtnMaxY:Number;
      
      public function AARXPDialog()
      {
         super();
         this._seps = new <Sprite>[this.mySep0,this.mySep1,this.mySep2];
         this._items = new <AARXPModItem>[this.myItem0,this.myItem1];
         this._bkgMaxHeight = this.myBkg.height;
         this._closeBtnMaxY = this.myCloseBtn.y;
         this.myTitleTF.text = DictInGame.XP_MODIFIERS;
         this.myIntroTF.text = DictInGame.XP_MODIFIERS_INTRO;
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         this.myCloseBtn.addEventListener(BaseButton.EVT_CLICK,this.onCloseClick);
      }
      
      private function onCloseClick(event:Event) : void
      {
         this.dispatchEvent(new ParaEvent(HIDE_DETAILS));
      }
      
      public function SetXPDetails(data:AARXPDetailsObj) : void
      {
         var item:AARXPModItem = null;
         var i:int = 0;
         var index:int = 0;
         if(data.aasScale < 1)
         {
            item = this._items[index++];
            item.SetModType(AARXPModItem.TYPE_AAS);
         }
         if(data.leagueScale < 1)
         {
            item = this._items[index++];
            item.SetModType(AARXPModItem.TYPE_LEAGUE);
         }
         for(i = 0; i < this._items.length; i++)
         {
            this._items[i].visible = i < index;
         }
         for(i = 0; i < this._seps.length; i++)
         {
            this._seps[i].visible = i <= index;
         }
         var rowHeight:Number = this._seps[1].y - this._seps[0].y;
         var reduction:Number = (this._items.length - index) * rowHeight;
         this.myBkg.height = this._bkgMaxHeight - reduction;
         this.myCloseBtn.y = this._closeBtnMaxY - reduction;
      }
   }
}


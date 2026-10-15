package codo.views.hud.popups
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.CallToActionButton;
   import codo.constants.HUDPopupComponentTypes;
   import codo.localization.DictVIP;
   import codo.utils.LocalizeUtil;
   import codo.utils.SoundUtil;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.HudVIPSelectVIPCharacterPopup_parts.HudVIPSelectVIPCharacterCard;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class HudVIPSelectVIPCharacterPopup extends HUDPopupComponent
   {
      
      private const MSG_SELECTED:int = 1;
      
      public var myTitle:TextField;
      
      public var myHint:TextField;
      
      public var myCharacter1:HudVIPSelectVIPCharacterCard;
      
      public var myCharacter2:HudVIPSelectVIPCharacterCard;
      
      public var myCharacter3:HudVIPSelectVIPCharacterCard;
      
      public var mySelectBtn1:CallToActionButton;
      
      public var mySelectBtn2:CallToActionButton;
      
      public var mySelectBtn3:CallToActionButton;
      
      public var myBg:MovieClip;
      
      private var mCharacters:Vector.<HudVIPSelectVIPCharacterCard>;
      
      public function HudVIPSelectVIPCharacterPopup()
      {
         super();
         this.myBg.width = 1060;
         this.myBg.height = 560;
         this.myTitle.text = DictVIP.SELECT_VIP_CHARACTER_TITLE;
         this.myHint.text = DictVIP.YOU_HAS_BEEN_SELECTED_AS_VIP;
         this.mySelectBtn1.label = "[1]" + LocalizeUtil.localize(DictVIP.SELECT);
         this.mySelectBtn2.label = "[2]" + LocalizeUtil.localize(DictVIP.SELECT);
         this.mySelectBtn3.label = "[3]" + LocalizeUtil.localize(DictVIP.SELECT);
         this.mySelectBtn1.index = 1;
         this.mySelectBtn2.index = 2;
         this.mySelectBtn3.index = 3;
         this.mySelectBtn1.width = 135;
         this.mySelectBtn1.height = 34;
         this.mySelectBtn2.width = 135;
         this.mySelectBtn2.height = 34;
         this.mySelectBtn3.width = 135;
         this.mySelectBtn3.height = 34;
         this.mySelectBtn1.setClickCallback(this.onSelectCharacter);
         this.mySelectBtn2.setClickCallback(this.onSelectCharacter);
         this.mySelectBtn3.setClickCallback(this.onSelectCharacter);
         this.mCharacters = new <HudVIPSelectVIPCharacterCard>[this.myCharacter1,this.myCharacter2,this.myCharacter3];
         this.myCharacter1.visible = false;
         this.myCharacter2.visible = false;
         this.myCharacter3.visible = false;
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.VIP_SELECT_VIP_CHARACTER;
      }
      
      override protected function showView() : void
      {
         var i:int = 0;
         var data:Object = null;
         super.showView();
         for(i = 0; i < 3; i++)
         {
            data = CFunctionInGameContainer.AS_GetVIPSelectCharacterInfo(i);
            if(!data)
            {
               break;
            }
            this.mCharacters[i].visible = true;
            this.mCharacters[i].setData(data);
         }
      }
      
      private function onSelectCharacter(button:CallToActionButton) : void
      {
         Notify(this.MSG_SELECTED,{"index":button.index.toString()});
         SoundUtil.getInstance().playSound("mp_capture_flag");
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         var input:String = String.fromCharCode(cEvt.charCode).toUpperCase();
         if(input == "1" || input == "2" || input == "3")
         {
            Notify(this.MSG_SELECTED,{"index":input});
            SoundUtil.getInstance().playSound("mp_capture_flag");
         }
      }
   }
}


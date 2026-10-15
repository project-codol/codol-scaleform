package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class EmoteSettingKey extends MovieClip
   {
      
      public static const STATE_UNEQUIPPED:int = 0;
      
      public static const STATE_EQUIPPED:int = 1;
      
      public static const STATE_SELECTED:int = 2;
      
      public static const STATE_UNSELECTED:int = 3;
      
      public var myTakeOffBtn:CloseButton;
      
      public var myKey:flash.text.TextField;
      
      private var mIndex:int;
      
      private var mForceHideTakeoffButton:Boolean;
      
      private var mState:int;
      
      public function EmoteSettingKey()
      {
         super();
         this.myTakeOffBtn.setClickCallback(this.onTakeOffEmote);
         this.state = STATE_UNEQUIPPED;
         this.mForceHideTakeoffButton = false;
      }
      
      public function set index(index:int) : void
      {
         this.mIndex = index;
         switch(index)
         {
            case 0:
               this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+forward").toUpperCase();
               break;
            case 1:
               this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+moveleft").toUpperCase();
               break;
            case 2:
               this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+back").toUpperCase();
               break;
            case 3:
               this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+moveright").toUpperCase();
               break;
            default:
               this.myKey.text = "";
         }
      }
      
      public function set forceHideTakeoffButton(forceHideTakeoffButton:Boolean) : void
      {
         this.mForceHideTakeoffButton = forceHideTakeoffButton;
      }
      
      public function set state(state:int) : void
      {
         this.mState = state;
         this.myTakeOffBtn.visible = false;
         switch(this.mState)
         {
            case STATE_UNEQUIPPED:
               alpha = 0.6;
               gotoAndStop(1);
               break;
            case STATE_EQUIPPED:
               alpha = 1;
               gotoAndStop(2);
               if(!this.mForceHideTakeoffButton)
               {
                  this.myTakeOffBtn.visible = true;
               }
               break;
            case STATE_SELECTED:
               alpha = 1;
               gotoAndStop(3);
               if(!this.mForceHideTakeoffButton)
               {
                  this.myTakeOffBtn.visible = true;
               }
               break;
            case STATE_UNSELECTED:
               alpha = 0.3;
               gotoAndStop(4);
               if(!this.mForceHideTakeoffButton)
               {
                  this.myTakeOffBtn.visible = true;
               }
         }
      }
      
      private function onTakeOffEmote() : void
      {
         var emote:int = CFunctionCommonContainer.AS_GetEquippedEmote(this.mIndex);
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(emote);
         EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTERLOADOUT_UNEQUIP_ITEM_BY_ITEM,{"data":prod});
      }
   }
}


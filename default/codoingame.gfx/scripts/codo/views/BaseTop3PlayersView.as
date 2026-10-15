package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.EmoteSettings;
   import codo.utils.LocalizeUtil;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BaseTop3PlayersView extends BaseView
   {
      
      public var myEmoteSettings:EmoteSettings;
      
      protected var mSelectedEmoteIndex:int;
      
      protected var mSelectedEmoteTimeout:Boolean;
      
      protected var mWaitForSelectEmoteTimer:Timer;
      
      public function BaseTop3PlayersView()
      {
         super();
         this.mWaitForSelectEmoteTimer = new Timer(2000,1);
         this.mWaitForSelectEmoteTimer.addEventListener(TimerEvent.TIMER,this.onSelectEmoteTimeout);
         this.myEmoteSettings.visible = false;
         this.myEmoteSettings.chooseHintVisibility = true;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.mSelectedEmoteIndex = -1;
         this.mSelectedEmoteTimeout = false;
         this.mWaitForSelectEmoteTimer.start();
         this.myEmoteSettings.forceHideTakeoffButton = true;
         this.myEmoteSettings.updateEmoteSetting();
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         var key:String = null;
         if(this.mSelectedEmoteTimeout)
         {
            return;
         }
         if(cEvt.type == KeyboardEvent.KEY_DOWN)
         {
            key = String.fromCharCode(cEvt.charCode).toUpperCase();
            if(key == LocalizeUtil.localizeFirstKeyBindingForCommand("+forward").toUpperCase())
            {
               this.mSelectedEmoteIndex = 0;
               this.myEmoteSettings.selectEmote(this.mSelectedEmoteIndex);
            }
            else if(key == LocalizeUtil.localizeFirstKeyBindingForCommand("+moveleft").toUpperCase())
            {
               this.mSelectedEmoteIndex = 1;
               this.myEmoteSettings.selectEmote(this.mSelectedEmoteIndex);
            }
            else if(key == LocalizeUtil.localizeFirstKeyBindingForCommand("+back").toUpperCase())
            {
               this.mSelectedEmoteIndex = 2;
               this.myEmoteSettings.selectEmote(this.mSelectedEmoteIndex);
            }
            else if(key == LocalizeUtil.localizeFirstKeyBindingForCommand("+moveright").toUpperCase())
            {
               this.mSelectedEmoteIndex = 3;
               this.myEmoteSettings.selectEmote(this.mSelectedEmoteIndex);
            }
         }
      }
      
      protected function selectEmote(index:int) : void
      {
         var emote:int = CFunctionCommonContainer.AS_GetEquippedEmote(index);
         if(emote == 0)
         {
            return;
         }
         CFunctionCommonContainer.ScriptMenuResponse("emote_select","emote_" + (index + 1).toString());
         this.myEmoteSettings.selectEmote(index);
      }
      
      protected function onSelectEmoteTimeout(event:TimerEvent) : void
      {
         var MAX_EMOTE_SLOTS:int = 0;
         var emote:int = 0;
         var index:int = 0;
         this.mWaitForSelectEmoteTimer.stop();
         if(this.mSelectedEmoteTimeout)
         {
            return;
         }
         this.mSelectedEmoteTimeout = true;
         if(this.mSelectedEmoteIndex < 0)
         {
            MAX_EMOTE_SLOTS = 4;
            for(index = 0; index < MAX_EMOTE_SLOTS; index++)
            {
               emote = CFunctionCommonContainer.AS_GetEquippedEmote(index);
               if(emote != 0)
               {
                  this.mSelectedEmoteIndex = index;
                  break;
               }
            }
         }
         if(this.mSelectedEmoteIndex >= 0)
         {
            this.selectEmote(this.mSelectedEmoteIndex);
         }
      }
   }
}


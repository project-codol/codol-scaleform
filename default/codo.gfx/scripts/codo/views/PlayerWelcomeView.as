package codo.views
{
   import codo.base.BaseView;
   import codo.constants.DataID;
   import codo.constants.UITourVOSoundAliases;
   import codo.objects.ResultObj;
   import codo.services.LoginService;
   import codo.views.uitour.UIPlayerWelcome;
   
   public class PlayerWelcomeView extends BaseView
   {
      
      public var myUIWelcome:UIPlayerWelcome;
      
      public function PlayerWelcomeView()
      {
         super();
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myUIWelcome.configureGamerTagInput(this.onSubmitName);
         playSound(UITourVOSoundAliases.PICK_YOUR_CALLSIGN);
         this.myUIWelcome.show();
      }
      
      private function onSubmitName() : void
      {
         this.myUIWelcome.mGamerTagInputTF.myTextClip.selectable = false;
         DataManager.request(DataID.CREATE_CHARACTER,{"userName":this.myUIWelcome.requestedGamerTag},this.onCreateCharacterNameComplete);
      }
      
      private function onCreateCharacterNameComplete(cRes:Object) : void
      {
         var err:String = null;
         var isSuccess:Boolean = cRes.result == ResultObj.RESULT_SUCCESS;
         if(!isSuccess)
         {
            this.myUIWelcome.mGamerTagInputTF.myTextClip.selectable = true;
            err = LoginService.getInstance().getLogonErrorMsg(cRes.data.type,cRes.data.id,cRes.data.errorCode);
            this.myUIWelcome.showOrHideErrorMsg(err,cRes.data.errorCode);
         }
         else
         {
            this.myUIWelcome.showOrHideErrorMsg(null);
            this.myUIWelcome.myCallToActionButton.enabled = false;
            this.myUIWelcome.mGamerTagInputTF.enabled = false;
            playSound(UITourVOSoundAliases.CALLSIGN_SUCCESS);
         }
      }
   }
}


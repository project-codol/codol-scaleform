package codo.views.persistent
{
   import codo.component.LoginRewardCounterButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4809")]
   public dynamic class LoginRewardCounterButton extends codo.component.LoginRewardCounterButton
   {
      
      public function LoginRewardCounterButton()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setTab_myItemNameTF_LoginRewardCounterButton_myItemNameTF_0();
      }
      
      internal function __setTab_myItemNameTF_LoginRewardCounterButton_myItemNameTF_0() : *
      {
         myItemNameTF.tabIndex = 1;
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}


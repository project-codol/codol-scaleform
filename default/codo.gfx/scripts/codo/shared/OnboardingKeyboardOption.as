package codo.shared
{
   import codo.component.OnboardingKeyboardOption;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5525")]
   public dynamic class OnboardingKeyboardOption extends codo.component.OnboardingKeyboardOption
   {
      
      public function OnboardingKeyboardOption()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}


package codo.social
{
   import codo.component.social.SocialTabButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1813")]
   public dynamic class socialTabButton extends SocialTabButton
   {
      
      public function socialTabButton()
      {
         super();
         addFrameScript(4,this.frame5,9,this.frame10,14,this.frame15);
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      internal function frame15() : *
      {
         stop();
      }
   }
}


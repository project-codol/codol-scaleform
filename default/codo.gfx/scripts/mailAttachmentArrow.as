package
{
   import codo.component.social.ArrowButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3711")]
   public dynamic class mailAttachmentArrow extends ArrowButton
   {
      
      public function mailAttachmentArrow()
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


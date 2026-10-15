package codo.social
{
   import codo.component.social.DeleteButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2209")]
   public dynamic class deleteButton extends DeleteButton
   {
      
      public function deleteButton()
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


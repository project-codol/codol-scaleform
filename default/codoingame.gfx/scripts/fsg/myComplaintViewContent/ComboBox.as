package fsg.myComplaintViewContent
{
   import fsg.shared.ComboBox;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4011")]
   public dynamic class ComboBox extends fsg.shared.ComboBox
   {
      
      public function ComboBox()
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


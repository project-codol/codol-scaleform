package panelBkg
{
   import flash.display.BitmapData;
   
   [Embed(source="/_assets/2707_panelBkg.png_panelBkg.png.png")]
   public dynamic class png extends BitmapData
   {
      
      public function png(w:int = 256, h:int = 64)
      {
         super(w,h);
      }
   }
}


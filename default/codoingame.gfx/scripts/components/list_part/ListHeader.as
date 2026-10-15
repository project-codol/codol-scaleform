package components.list_part
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class ListHeader extends MovieClip
   {
      
      public var txt_header:TextField;
      
      public var bkg:Sprite;
      
      private var barLineWidthDiff:Number;
      
      public function ListHeader()
      {
         super();
         this.barLineWidthDiff = 0;
      }
      
      public function SetCustomWidth(width:Number) : void
      {
      }
      
      public function SetLabel(label:String) : void
      {
         this.txt_header.text = label;
      }
   }
}


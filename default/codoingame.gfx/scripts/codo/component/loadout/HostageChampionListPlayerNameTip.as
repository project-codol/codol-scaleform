package codo.component.loadout
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HostageChampionListPlayerNameTip extends MovieClip
   {
      
      private static const TOP_BOTTOM_PADDING:int = 12;
      
      private static const EACH_LINE_HEIGHT:int = 24;
      
      public var myNameTF:TextField;
      
      public var myBg:MovieClip;
      
      public function HostageChampionListPlayerNameTip()
      {
         super();
         mouseEnabled = mouseChildren = false;
      }
      
      public function setNames(names:Array) : void
      {
         var nameStr:String = "";
         for(var i:int = 0; i < names.length; i++)
         {
            nameStr += names[i];
            if(i < names.length - 1)
            {
               nameStr += "\n";
            }
         }
         this.myNameTF.text = nameStr;
         this.myNameTF.height = names.length * EACH_LINE_HEIGHT;
         this.myBg.height = this.myNameTF.height + 2 * TOP_BOTTOM_PADDING;
      }
      
      public function getNames() : String
      {
         return this.myNameTF.text;
      }
   }
}


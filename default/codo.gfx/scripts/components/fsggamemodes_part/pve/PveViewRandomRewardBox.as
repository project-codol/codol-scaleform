package components.fsggamemodes_part.pve
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class PveViewRandomRewardBox extends MovieClip
   {
      
      public static const STYLE_GOLD:uint = 0;
      
      public static const STYLE_BRONZE:uint = 1;
      
      public var myBoxBronze:Sprite;
      
      public var myBoxGold:Sprite;
      
      public function PveViewRandomRewardBox()
      {
         super();
         this.style = STYLE_GOLD;
      }
      
      public function set style(id:int) : void
      {
         this.myBoxGold.visible = id == STYLE_GOLD ? true : false;
         this.myBoxBronze.visible = !this.myBoxGold.visible;
      }
   }
}


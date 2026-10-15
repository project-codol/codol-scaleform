package codo.component.matchselect
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MatchSelectBonusTab extends MovieClip
   {
      
      public static const TYPE_2BONUS:int = 0;
      
      public static const TYPE_1BONUS:int = 1;
      
      public static const FRAME_XPGP:int = 1;
      
      public static const FRAME_XP:int = 2;
      
      public var myLabel:TextField;
      
      public var myBonus1:TextField;
      
      public var myUnit1:TextField;
      
      public var myBonus2:TextField;
      
      public var myUnit2:TextField;
      
      public function MatchSelectBonusTab()
      {
         super();
      }
      
      public function setType(value:int) : void
      {
         if(value == TYPE_2BONUS)
         {
            gotoAndStop(FRAME_XPGP);
            this.myBonus2.visible = this.myUnit2.visible = true;
         }
         else
         {
            gotoAndStop(FRAME_XP);
            this.myBonus2.visible = this.myUnit2.visible = false;
         }
      }
      
      public function setLabel(value:String) : void
      {
         this.myLabel.text = value;
      }
      
      public function setBonus1(value:String, unit:String) : void
      {
         this.myBonus1.text = value;
         this.myUnit1.text = unit;
      }
      
      public function setBonus2(value:String, unit:String) : void
      {
         this.myBonus2.text = value;
         this.myUnit2.text = unit;
      }
   }
}


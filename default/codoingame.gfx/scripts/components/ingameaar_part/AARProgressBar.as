package components.ingameaar_part
{
   import flash.display.Sprite;
   import shaui.component.core.UIComponent;
   
   public class AARProgressBar extends UIComponent
   {
      
      public var myBarEarned:Sprite;
      
      public var myBarCurrent:Sprite;
      
      public var myBarBase:Sprite;
      
      public function AARProgressBar()
      {
         super();
         this.myBarEarned.visible = false;
         this.SetBarData(0);
      }
      
      public function SetBarData(percentComplete:Number, percentEarned:Number = 0) : void
      {
         this.myBarEarned.visible = percentEarned > 0;
         this.myBarCurrent.width = uint(this.myBarBase.width * percentComplete);
         this.myBarEarned.width = uint(this.myBarBase.width * percentEarned);
         this.myBarEarned.x = this.myBarCurrent.x + this.myBarCurrent.width;
      }
   }
}


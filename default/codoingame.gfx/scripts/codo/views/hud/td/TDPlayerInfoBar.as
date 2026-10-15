package codo.views.hud.td
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TDPlayerInfoBar extends HUDComponent
   {
      
      public var myHealthLabelBlackMask:MovieClip;
      
      public var myHealth:MovieClip;
      
      public var myHealthTarget:MovieClip;
      
      public var myCash:TextField;
      
      public var myCashCostHint:MovieClip;
      
      public var myHealthLabelBlack:TextField;
      
      public var myHealthLabelWhite:TextField;
      
      public function TDPlayerInfoBar()
      {
         super();
         this.myCashCostHint.visible = false;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_PLAYINFO_BAR;
      }
      
      public function cppSetHealthInfo(health:Number, regenTarget:Number, maxHealth:Number) : void
      {
         this.myHealth.scaleX = this.myHealthLabelBlackMask.scaleX = health / maxHealth;
         this.myHealthTarget.visible = regenTarget > 0;
         if(this.myHealthTarget.visible)
         {
            this.myHealthTarget.scaleX = regenTarget / maxHealth;
         }
         this.myHealthLabelBlack.text = this.myHealthLabelWhite.text = health.toString() + "/" + maxHealth.toString();
      }
      
      public function cppShowCashCostHint(value:Number) : void
      {
         this.myCashCostHint.x = this.myCash.x + this.myCash.textWidth;
         this.myCashCostHint.visible = true;
         this.myCashCostHint.myValue.label.text = "-$" + value;
         this.myCashCostHint.gotoAndPlay(1);
      }
   }
}


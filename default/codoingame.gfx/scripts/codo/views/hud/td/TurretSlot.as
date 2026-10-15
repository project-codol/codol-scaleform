package codo.views.hud.td
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import fsg.util.FsgImageHolder;
   
   public class TurretSlot extends MovieClip
   {
      
      public static const STATE_NONE:uint = 1;
      
      public static const STATE_EMPTY:uint = 2;
      
      public static const STATE_LOCK:uint = 3;
      
      public static const STATE_UNPLACE:uint = 4;
      
      public static const STATE_PLACED:uint = 5;
      
      public static const STATE_NOHEALTH:uint = 6;
      
      public static const TIER_COLORS:Array = [11579568,356352,22420,6160532,10962946];
      
      public static const STYLE_COLORS:Dictionary = new Dictionary();
      
      public static const MAX_HEALTH_BAR_WIDTH:Number = 41;
      
      STYLE_COLORS["yellow"] = 1;
      STYLE_COLORS["blue"] = 2;
      STYLE_COLORS["orange"] = 3;
      STYLE_COLORS["green"] = 4;
      STYLE_COLORS["red"] = 5;
      STYLE_COLORS["brown"] = 6;
      
      private var m_state:uint;
      
      private var m_health:uint;
      
      public function TurretSlot()
      {
         super();
         this.m_state = STATE_NONE;
         this.m_health = 0;
         this.gotoAndStop(this.m_state);
      }
      
      public function setData(state:uint, data:Object) : void
      {
         var colorTransform:ColorTransform = null;
         if(this.m_state != state)
         {
            this.gotoAndStop(state);
            this.m_state = state;
         }
         if(state > STATE_LOCK)
         {
            colorTransform = new ColorTransform();
            colorTransform.color = TIER_COLORS[data.tier - 1];
            this["myTurretBG"].transform.colorTransform = colorTransform;
            this["myMark"].gotoAndStop(STYLE_COLORS[data.styleColor]);
            (this["myImage"] as FsgImageHolder).setImage(data.icon);
         }
      }
      
      public function setHealth(health:Number) : void
      {
         if(this.m_state == STATE_PLACED && this.m_health != health)
         {
            this["myHealth"].width = MAX_HEALTH_BAR_WIDTH * health;
            this.m_health = health;
         }
      }
   }
}


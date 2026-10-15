package codo.views.hud.popups.HudTdTurretManageView_parts
{
   import codo.views.hud.td.TurretSlot;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudTdTurretManageTurretInfo extends MovieClip
   {
      
      public var myName:TextField;
      
      public var myHPBarFill:MovieClip;
      
      public var myHPBarBg:MovieClip;
      
      public var myOutline:MovieClip;
      
      public var myIcon:MovieClip;
      
      private var mHPBarFullWidth:Number;
      
      public function HudTdTurretManageTurretInfo()
      {
         super();
         if(this.myHPBarFill != null)
         {
            this.mHPBarFullWidth = this.myHPBarFill.width;
         }
      }
      
      public function setData(data:Object) : void
      {
         var color:uint = uint(TurretSlot.TIER_COLORS[data.tier - 1]);
         this.myName.textColor = 16777215;
         this.myName.text = data.name;
         var colorTransform:ColorTransform = new ColorTransform();
         colorTransform.color = color;
         this.myOutline.transform.colorTransform = colorTransform;
         if(this.myHPBarFill != null)
         {
            if(data.hasOwnProperty("health"))
            {
               this.myHPBarFill.width = data.health * this.mHPBarFullWidth;
            }
            else
            {
               this.myHPBarFill.visible = this.myHPBarBg.visible = false;
            }
         }
         if(this.myIcon != null)
         {
            (this.myIcon.image as FsgImageHolder).setImage(data.icon);
            this.myIcon.gotoAndStop(TurretSlot.STYLE_COLORS[data.styleColor]);
         }
      }
   }
}


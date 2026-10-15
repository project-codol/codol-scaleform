package codo.views.hud.zhuntConsumableUsedNotification
{
   import codo.constants.GameInfo;
   import codo.constants.HUDComponentTypes;
   import codo.localization.DictZHunt;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.HUDComponent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class ZhuntConsumableUsedNotification extends HUDComponent
   {
      
      public var myBg:MovieClip;
      
      public var myIcon:FsgImageHolder;
      
      public var myText:TextField;
      
      public function ZhuntConsumableUsedNotification()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.ZHUNT_CONSUMABLE_USED_NOTIFICATION;
      }
      
      public function cppShow(icon:String, text:String) : void
      {
         TweenLite.killTweensOf(this);
         this.myIcon.setImage(icon);
         this.myIcon.transform.colorTransform = new ColorTransform(1,1,1,1,235,251,219);
         this.myText.text = LocalizeUtil.localize(DictZHunt.USED) + LocalizeUtil.localize("@" + text);
         this.myBg.width = this.myText.textWidth + this.myIcon.width + 80;
         x = GameInfo.stagePosition.x - width;
         var timeLineLite:TimelineLite = new TimelineLite();
         timeLineLite.append(TweenLite.to(this,0.5,{"x":GameInfo.stagePosition.x}));
         timeLineLite.append(TweenLite.to(this,0.5,{
            "delay":2,
            "x":GameInfo.stagePosition.x - width
         }));
         timeLineLite.play();
      }
      
      public function cppHide() : void
      {
         x = GameInfo.stagePosition.x - 2000;
      }
   }
}


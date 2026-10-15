package codo.views.hud.td
{
   import codo.constants.GameInfo;
   import codo.constants.HUDComponentTypes;
   import codo.localization.DictTD;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.HUDComponent;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class HUDTDKeyHint extends HUDComponent
   {
      
      public var myPackageKeyHint:MovieClip;
      
      public var myMapKeyHint:MovieClip;
      
      public var myTeleportKeyHint:MovieClip;
      
      public var myTeleportCDTimer:MovieClip;
      
      public var myInCDHint:MovieClip;
      
      public var myChannelProgressBar:MovieClip;
      
      private var mTween:TweenLite;
      
      public function HUDTDKeyHint()
      {
         super();
         this.myMapKeyHint.key.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+targetMap");
         this.myMapKeyHint.desc.text = DictTD.KEY_HINT_OPEN_MAP;
         this.myPackageKeyHint.key.text = LocalizeUtil.localizeFirstKeyBindingForCommand("toggleloadoutmenu");
         this.myPackageKeyHint.desc.text = DictTD.KEY_HINT_OPEN_PACKAGE;
         this.myTeleportKeyHint.key.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 5");
         this.myTeleportKeyHint.desc.text = DictTD.KEY_HINT_TELEPORT;
         this.myTeleportCDTimer.label.text = DictTD.IN_COLD_DOWN;
         this.myChannelProgressBar.label.text = DictTD.IN_TELEPORTING;
         this.myInCDHint.x = this.myChannelProgressBar.x = GameInfo.stageSize.x * 0.5;
         this.myInCDHint.y = this.myChannelProgressBar.y = GameInfo.stageSize.y - 48;
         this.myInCDHint.visible = this.myChannelProgressBar.visible = false;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_KEY_HINT;
      }
      
      public function showInCDHint(cdSeconds:int) : void
      {
         this.myInCDHint.label.text = LocalizeUtil.replaceConversionString(LocalizeUtil.localize(DictTD.TELEPORT_READY_IN_SECS),[cdSeconds]);
         this.myInCDHint.visible = true;
         this.myInCDHint.alpha = 1;
         if(this.mTween == null)
         {
            this.mTween = new TweenLite(this.myInCDHint,1,{
               "alpha":0,
               "delay":1
            });
         }
         this.mTween.restart(true);
      }
   }
}


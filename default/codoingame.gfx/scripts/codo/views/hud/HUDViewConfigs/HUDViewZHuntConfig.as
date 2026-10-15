package codo.views.hud.HUDViewConfigs
{
   import codo.constants.GameInfo;
   import codo.hud.zhunt.bossHealthBar;
   import codo.hud.zhunt.dialogPanel;
   import codo.hud.zhunt.gameStopwatch;
   import codo.hud.zhunt.missionGuidePanel;
   import codo.hud.zhunt.missionTargetPanel;
   import codo.hud.zhunt.obtainCrateHint;
   import codo.hud.zhunt.playerInfoBar;
   import codo.hud.zhunt.pveWeaponEnergyBar;
   import codo.hud.zhunt.rankPanel;
   import codo.hud.zhunt.spectatingNotification;
   import codo.hud.zhunt.weaponBar;
   import codo.hud.zhunt.zhuntConsumableUsedNotification;
   import codo.views.hud.dotmenuWrapper.GameMessageWindow;
   import codo.views.hud.dotmenuWrapper.HUDMinimap;
   import flash.geom.Point;
   
   public class HUDViewZHuntConfig extends HUDViewBaseConfig
   {
      
      public function HUDViewZHuntConfig()
      {
         super();
      }
      
      override protected function buildConfigArray() : void
      {
         super.buildConfigArray();
         addComponent({
            "cls":weaponBar,
            "anchor":GameInfo.BOTTOM_RIGHT,
            "offset":new Point(0,0),
            "width":433,
            "height":267,
            "zoom":0.8
         });
         addComponent({
            "cls":dialogPanel,
            "anchor":GameInfo.BOTTOM_LEFT,
            "offset":new Point(-410,-300)
         });
         addComponent({
            "cls":playerInfoBar,
            "anchor":GameInfo.BOTTOM_LEFT,
            "offset":new Point(0,0),
            "width":399.45,
            "height":204.75,
            "zoom":0.8
         });
         addComponent({
            "cls":rankPanel,
            "anchor":GameInfo.TOP_RIGHT,
            "offset":new Point(0,20),
            "width":298,
            "height":321,
            "zoom":0.8
         });
         addComponent({
            "cls":gameStopwatch,
            "anchor":GameInfo.TOP_LEFT,
            "offset":new Point(20,20),
            "width":124,
            "height":30
         });
         addComponent({
            "cls":GameMessageWindow,
            "anchor":GameInfo.TOP_LEFT,
            "offset":new Point(X_MARGIN,400)
         });
         addComponent({
            "cls":bossHealthBar,
            "anchor":GameInfo.TOP_CENTER,
            "offset":new Point(-365,60),
            "width":729,
            "height":78
         });
         addComponent({
            "cls":missionTargetPanel,
            "anchor":GameInfo.TOP_CENTER,
            "offset":new Point(0,60),
            "width":216,
            "height":123
         });
         addComponent({
            "cls":HUDMinimap,
            "anchor":GameInfo.TOP_LEFT,
            "offset":new Point(20,30),
            "showCompass":false
         });
         addComponent({
            "cls":pveWeaponEnergyBar,
            "anchor":GameInfo.BOTTOM_CENTER,
            "offset":new Point(-40,-164),
            "width":100,
            "height":100,
            "zoom":0.8
         });
         addComponent({
            "cls":missionGuidePanel,
            "anchor":GameInfo.TOP_LEFT,
            "offset":new Point(10,300),
            "width":272,
            "height":104,
            "zoom":0.95
         });
         addComponent({
            "cls":spectatingNotification,
            "anchor":GameInfo.TOP_CENTER
         });
         addComponent({
            "cls":obtainCrateHint,
            "anchor":GameInfo.TOP_CENTER,
            "offset":new Point(0,180),
            "width":444,
            "height":93,
            "zoom":0.8
         });
         addComponent({
            "cls":zhuntConsumableUsedNotification,
            "anchor":GameInfo.BOTTOM_LEFT,
            "offset":new Point(0,-180)
         });
      }
   }
}


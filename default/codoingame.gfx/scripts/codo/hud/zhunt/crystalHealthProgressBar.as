package codo.hud.zhunt
{
   import codo.views.hud.missionTargetPanel.GeneratorHealthProgressBar;
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5096")]
   public dynamic class crystalHealthProgressBar extends GeneratorHealthProgressBar
   {
      
      public function crystalHealthProgressBar()
      {
         super();
         addFrameScript(20,this.frame21);
      }
      
      internal function frame21() : *
      {
         gotoAndPlay(2);
      }
   }
}


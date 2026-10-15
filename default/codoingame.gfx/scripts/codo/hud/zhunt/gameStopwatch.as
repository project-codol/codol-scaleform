package codo.hud.zhunt
{
   import codo.views.hud.gameStopwatch.GameStopwatch;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5191")]
   public dynamic class gameStopwatch extends GameStopwatch
   {
      
      public function gameStopwatch()
      {
         super();
         addFrameScript(0,this.frame1,21,this.frame22);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame22() : *
      {
         stop();
      }
   }
}


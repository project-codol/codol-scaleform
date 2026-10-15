package
{
   import adobe.utils.*;
   import codo.views.HudChattingView;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3994")]
   public dynamic class hudChattingView extends HudChattingView
   {
      
      public function hudChattingView()
      {
         super();
         this.__setProp_myChannelCB_hudChattingView_myChannelCB_0();
      }
      
      internal function __setProp_myChannelCB_hudChattingView_myChannelCB_0() : *
      {
         try
         {
            myChannelCB["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         myChannelCB.doubleClickAble = false;
         myChannelCB.dragAble = false;
         myChannelCB.dropDown = false;
         myChannelCB.lineSpace = 0;
         myChannelCB.rollAxis = "y";
         myChannelCB.selectAble = true;
         myChannelCB.wheelSpd = 20;
         try
         {
            myChannelCB["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}


package
{
   import adobe.utils.*;
   import codo.views.HudAARView;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2345")]
   public dynamic class hudAARScoreboardView extends HudAARView
   {
      
      public function hudAARScoreboardView()
      {
         super();
         this.__setProp_myEarlyExitButton_hudAARScoreboardView_myEarlyExitButton_0();
      }
      
      internal function __setProp_myEarlyExitButton_hudAARScoreboardView_myEarlyExitButton_0() : *
      {
         try
         {
            myEarlyExitButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         myEarlyExitButton.texDisableColour = "#767676";
         myEarlyExitButton.textFocusColour = "#ffffff";
         try
         {
            myEarlyExitButton["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}


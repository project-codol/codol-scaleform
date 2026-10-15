package
{
   import adobe.utils.*;
   import components.matchselect_part.MatchSelectPvpElems;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol536")]
   public dynamic class matchSelectPvpElems extends MatchSelectPvpElems
   {
      
      public function matchSelectPvpElems()
      {
         super();
         this.__setProp_myGameListPanel_matchSelectPvpElems_myGameListPanel_0();
      }
      
      internal function __setProp_myGameListPanel_matchSelectPvpElems_myGameListPanel_0() : *
      {
         try
         {
            myGameListPanel["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         myGameListPanel.column = 1;
         myGameListPanel.columnSpace = 0;
         myGameListPanel.doubleClickEnabled = true;
         myGameListPanel.lineSpace = 0;
         myGameListPanel.row = 15;
         try
         {
            myGameListPanel["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}


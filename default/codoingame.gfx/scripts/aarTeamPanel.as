package
{
   import adobe.utils.*;
   import components.scoreboard_part.ScoreboardTeamPanel;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1691")]
   public dynamic class aarTeamPanel extends ScoreboardTeamPanel
   {
      
      public function aarTeamPanel()
      {
         super();
         this.__setProp_myList_aarTeamPanel_myList_0();
      }
      
      internal function __setProp_myList_aarTeamPanel_myList_0() : *
      {
         try
         {
            myList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         myList.column = 1;
         myList.columnSpace = 0;
         myList.doubleClickEnabled = false;
         myList.lineSpace = 0;
         myList.row = 12;
         try
         {
            myList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}


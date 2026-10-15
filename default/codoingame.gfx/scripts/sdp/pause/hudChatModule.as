package sdp.pause
{
   import adobe.utils.*;
   import components.chatting_part.HudChatModule;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3584")]
   public dynamic class hudChatModule extends HudChatModule
   {
      
      public function hudChatModule()
      {
         super();
         this.__setProp_myTextArea_hudChatModule_myTextArea_0();
      }
      
      internal function __setProp_myTextArea_hudChatModule_myTextArea_0() : *
      {
         try
         {
            myTextArea["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         myTextArea.scrollBarGap = 2;
         myTextArea.textFieldHeight = 86;
         myTextArea.textFieldWidth = 538;
         try
         {
            myTextArea["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}


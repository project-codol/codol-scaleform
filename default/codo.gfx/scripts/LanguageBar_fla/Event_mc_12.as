package LanguageBar_fla
{
   import adobe.utils.*;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1589")]
   public dynamic class Event_mc_12 extends MovieClip
   {
      
      public function Event_mc_12()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function RollOverHandler(event:MouseEvent) : *
      {
         var bar_mc:Bar_mc = null;
         var listRow_mc:ListRow_mc = null;
         if(parent is Bar_mc)
         {
            bar_mc = Bar_mc(parent);
            parent.parent.parent["ChangeBackgroundColor"](bar_mc.Background_mc.barBackgroundColor,2);
            parent.parent.parent["ChangeBackgroundColor"](bar_mc.Background_mc.barBackgroundBorder,2);
            parent.parent.parent["ChangeTextColor"](bar_mc.tf,2);
            bar_mc.currState = 2;
         }
         else if(parent is ListRow_mc)
         {
            listRow_mc = ListRow_mc(parent);
            parent.parent.parent["ChangeBackgroundColor"](listRow_mc.Background_mc.ListBackgroundColor,2);
            parent.parent.parent["ChangeBackgroundColor"](listRow_mc.Background_mc.ListBackgroundBorder,2);
            parent.parent.parent["ChangeTextColor"](listRow_mc.tf,2);
            listRow_mc.currState = 2;
         }
      }
      
      public function RollOutHandler(event:MouseEvent) : *
      {
         var bar_mc:Bar_mc = null;
         var listRow_mc:ListRow_mc = null;
         if(parent is Bar_mc)
         {
            bar_mc = Bar_mc(parent);
            if(Boolean(this.parent.parent) && bar_mc.currState != 1)
            {
               parent.parent.parent["ChangeBackgroundColor"](bar_mc.Background_mc.barBackgroundColor,1);
               parent.parent.parent["ChangeBackgroundColor"](bar_mc.Background_mc.barBackgroundBorder,1);
               parent.parent.parent["ChangeTextColor"](bar_mc.tf,1);
               bar_mc.currState = 1;
            }
         }
         else if(parent is ListRow_mc)
         {
            listRow_mc = ListRow_mc(parent);
            if(Boolean(this.parent.parent) && listRow_mc.currState != 1)
            {
               parent.parent.parent["ChangeBackgroundColor"](listRow_mc.Background_mc.ListBackgroundColor,1);
               parent.parent.parent["ChangeBackgroundColor"](listRow_mc.Background_mc.ListBackgroundBorder,1);
               parent.parent.parent["ChangeTextColor"](listRow_mc.tf,1);
               listRow_mc.currState = 1;
            }
         }
      }
      
      public function PressHandler(event:MouseEvent) : *
      {
         if(event.target == this)
         {
            parent.parent.parent["SelectItem"](this.parent.name);
         }
      }
      
      internal function frame1() : *
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.PressHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.RollOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.RollOutHandler);
      }
   }
}


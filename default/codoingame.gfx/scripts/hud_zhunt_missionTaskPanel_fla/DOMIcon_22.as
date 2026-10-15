package hud_zhunt_missionTaskPanel_fla
{
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5157")]
   public dynamic class DOMIcon_22 extends MovieClip
   {
      
      public var myDNA:MovieClip;
      
      public var myScanline:MovieClip;
      
      public var mySignal:MovieClip;
      
      public function DOMIcon_22()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,25,this.frame26);
      }
      
      internal function frame1() : *
      {
         this.myScanline.gotoAndPlay(1);
         this.myDNA.gotoAndPlay(1);
         if(this.hasOwnProperty("viewType"))
         {
            this.myScanline.visible = false;
            this.myDNA.visible = false;
            this.mySignal.visible = false;
            if(this.viewType == 1)
            {
               this.myScanline.visible = true;
            }
            else if(this.viewType == 2)
            {
               this.myDNA.visible = true;
            }
            else
            {
               this.mySignal.visible = true;
            }
         }
      }
      
      internal function frame2() : *
      {
         this.myScanline.gotoAndStop(1);
         this.myDNA.gotoAndStop(1);
         if(this.hasOwnProperty("viewType"))
         {
            this.myScanline.visible = false;
            this.myDNA.visible = false;
            this.mySignal.visible = false;
            if(this.viewType == 1)
            {
               this.myScanline.visible = true;
            }
            else if(this.viewType == 2)
            {
               this.myDNA.visible = true;
            }
            else
            {
               this.mySignal.visible = true;
            }
         }
      }
      
      internal function frame3() : *
      {
         this.myScanline.gotoAndStop(1);
         this.myDNA.gotoAndStop(1);
         if(this.hasOwnProperty("viewType"))
         {
            this.myScanline.visible = false;
            this.myDNA.visible = false;
            this.mySignal.visible = false;
            if(this.viewType == 1)
            {
               this.myScanline.visible = true;
            }
            else if(this.viewType == 2)
            {
               this.myDNA.visible = true;
            }
            else
            {
               this.mySignal.visible = true;
            }
         }
      }
      
      internal function frame26() : *
      {
         gotoAndPlay(3);
      }
   }
}


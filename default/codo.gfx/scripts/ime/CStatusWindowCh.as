package ime
{
   import codo.event.ParaEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CStatusWindowCh extends MovieClip
   {
      
      public static const EVT_CLICK:String = "evt_click";
      
      public var BGColor:Number = 14608366;
      
      public var BGColorOnover:Number = 5619932;
      
      public var TextColor:Number = 5592921;
      
      public var TextColorSelected:Number = 65280;
      
      public var parent_mc:MovieClip;
      
      public var inputModeBG:MovieClip;
      
      public var shapeBG:MovieClip;
      
      public var symbolBG:MovieClip;
      
      public var backgroundBorder:MovieClip;
      
      public var inputIcon1:MovieClip;
      
      public var inputIcon2:MovieClip;
      
      public var shapeIcon1:MovieClip;
      
      public var shapeIcon2:MovieClip;
      
      public var symbolIcon1:MovieClip;
      
      public var symbolIcon2:MovieClip;
      
      public var icon:MovieClip;
      
      public var tf:TextField;
      
      public var Background_mc:MovieClip;
      
      public function CStatusWindowCh(mc:MovieClip = null)
      {
         this.parent_mc = mc;
         mouseChildren = false;
         if(mc != null)
         {
            mc.Controller = this;
         }
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onClick);
         super();
      }
      
      public function ChangeBackgroundColor(frameNumber:Number) : void
      {
         if(this.tf != null)
         {
            if(frameNumber == 1 || frameNumber == 3)
            {
               this.tf.textColor = 5592921;
            }
            else if(frameNumber == 2 || frameNumber == 4)
            {
               this.tf.textColor = 16777215;
            }
         }
         if(this.Background_mc != null)
         {
            if(frameNumber == 1 || frameNumber == 3)
            {
               this.Background_mc.gotoAndStop(1);
            }
            else if(frameNumber == 2 || frameNumber == 4)
            {
               this.Background_mc.gotoAndStop(2);
            }
         }
         if(this.icon != null)
         {
            if(frameNumber == 1 || frameNumber == 3)
            {
               this.icon.gotoAndStop(1);
            }
            else if(frameNumber == 2 || frameNumber == 4)
            {
               this.icon.gotoAndStop(2);
            }
         }
      }
      
      public function SetBackgroundColor(color1:Number, color2:Number) : void
      {
         this.BGColorOnover = color2;
         this.BGColor = color1;
         this.ChangeBackgroundColor(currentFrame);
      }
      
      public function SetTextColor(color1:Number, color2:Number) : void
      {
         this.TextColor = color1;
         this.TextColorSelected = color2;
         this.ChangeBackgroundColor(currentFrame);
      }
      
      public function DisplayStatusWindow(bgColor1:Number, bgColor2:Number, textColor1:Number, textColor2:Number) : void
      {
         this.SetBackgroundColor(bgColor1,bgColor2);
         this.SetTextColor(textColor1,textColor2);
         if(currentFrame != 1)
         {
            gotoAndPlay(1);
         }
      }
      
      public function Hide() : void
      {
         if(currentFrame != 2)
         {
            gotoAndPlay("empty");
         }
      }
      
      public function SetInputMode(cToggle:Boolean) : void
      {
         if(cToggle == false)
         {
            if(currentFrame != 1)
            {
               gotoAndPlay(1);
            }
         }
         else if(currentFrame != 3)
         {
            gotoAndPlay(3);
         }
      }
      
      public function SetSymbolMode(cToggle:Boolean) : void
      {
         if(cToggle == false)
         {
            if(currentFrame != 3)
            {
               gotoAndPlay(3);
            }
         }
         else if(currentFrame != 1)
         {
            gotoAndPlay(1);
         }
      }
      
      public function SetShapeMode(cToggle:Boolean) : void
      {
         if(cToggle == false)
         {
            if(currentFrame != 3)
            {
               gotoAndPlay(3);
            }
         }
         else if(currentFrame != 1)
         {
            gotoAndPlay(1);
         }
      }
      
      public function onRollOver(event:MouseEvent) : void
      {
         if(currentFrame == 1)
         {
            gotoAndPlay(2);
         }
         if(currentFrame == 3)
         {
            gotoAndPlay(4);
         }
      }
      
      public function onRollOut(event:MouseEvent) : void
      {
         if(currentFrame == 2)
         {
            gotoAndPlay(1);
         }
         if(currentFrame == 4)
         {
            gotoAndPlay(3);
         }
      }
      
      public function onClick(event:MouseEvent) : void
      {
         this.dispatchEvent(new ParaEvent(EVT_CLICK,{"target":this}));
      }
   }
}


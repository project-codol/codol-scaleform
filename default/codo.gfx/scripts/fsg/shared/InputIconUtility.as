package fsg.shared
{
   import codo.common.CFunctionCommonContainer;
   import codo.event.ParaEvent;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class InputIconUtility extends MovieClip
   {
      
      private static const supportedImages:Vector.<String> = new <String>["input_key_alt","input_key_backspace","input_key_ctrl","input_key_enter","input_key_mouse1_icon","input_key_mouse2_icon","input_key_mouse3","input_key_shift","input_key_space","input_key_tab"];
      
      private static const DEFAULT_IMAGE_SIZE:Number = 128;
      
      public var keyImage:FsgImageHolder;
      
      public var keyText:TextField;
      
      public function InputIconUtility()
      {
         super();
         this.clear();
      }
      
      private static function findBindingImageForCommand(command:String) : String
      {
         var j:uint = 0;
         var keyBindings:Array = CFunctionCommonContainer.GetKeyBindingNamesFromCommand(command);
         loop0:
         for(var i:uint = 0; i < supportedImages.length; )
         {
            j = 0;
            while(true)
            {
               if(j >= keyBindings.length)
               {
                  i++;
                  continue loop0;
               }
               if(supportedImages[i].substr(6) == keyBindings[j].toLowerCase())
               {
                  break;
               }
               j++;
            }
            return supportedImages[i];
         }
         var longpressCommand:String = getLongpressCommand(command);
         if(Boolean(longpressCommand))
         {
            return findBindingImageForCommand(longpressCommand);
         }
         return null;
      }
      
      private static function findBindingImageForKey(key:String) : String
      {
         for(var i:uint = 0; i < supportedImages.length; i++)
         {
            if(supportedImages[i].substr(6) == key.toLowerCase())
            {
               return supportedImages[i];
            }
         }
         return null;
      }
      
      private static function getLongpressCommand(command:String) : String
      {
         if(command == "togglecrouch")
         {
            return "+movedown";
         }
         if(command == "toggleprone")
         {
            return "+prone";
         }
         if(command == "+toggleads_throw")
         {
            return "+speed_throw";
         }
         return null;
      }
      
      public function setForKey(key:String, color:uint = 0) : Boolean
      {
         var imgRef:String = null;
         imgRef = findBindingImageForKey(key);
         if(Boolean(imgRef))
         {
            this.keyImage.visible = false;
            this.keyImage.addEventListener(Event.COMPLETE,this.onImageLoaded);
            this.keyImage.setImage(imgRef);
            this.keyText.text = "";
            return true;
         }
         this.keyImage.clearImage();
         this.keyText.text = LocalizeUtil.localize("@" + key);
         this.keyText.textColor = color;
         return false;
      }
      
      public function setForCommand(command:String, color:uint = 0, allowImage:Boolean = true) : Boolean
      {
         var imgRef:String = null;
         imgRef = allowImage ? findBindingImageForCommand(command) : null;
         if(Boolean(imgRef))
         {
            this.keyImage.visible = false;
            this.keyImage.addEventListener(Event.COMPLETE,this.onImageLoaded);
            this.keyImage.setImage(imgRef);
            this.keyText.text = "";
            return true;
         }
         this.keyImage.clearImage();
         this.keyText.text = LocalizeUtil.localizeFirstKeyBindingForCommand(command);
         this.keyText.textColor = color;
         return false;
      }
      
      public function setImageScale(scale:Number) : void
      {
         this.keyImage.scaleX = scale;
         this.keyImage.scaleY = scale;
         this.keyImage.x = this.keyImage.y = scale * -DEFAULT_IMAGE_SIZE / 2;
      }
      
      public function clear() : void
      {
         this.keyImage.clearImage();
         this.keyText.text = "";
      }
      
      private function onImageLoaded(e:ParaEvent) : void
      {
         this.keyImage.visible = true;
         this.keyImage.removeEventListener(Event.COMPLETE,this.onImageLoaded);
      }
   }
}


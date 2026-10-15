package codo.views.hudPropHunt
{
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PropHuntControlItem extends MovieClip
   {
      
      public var myLabel:TextField;
      
      public var myKey:TextField;
      
      private var mDefaultLabel:String;
      
      private var mToggledLabel:String;
      
      private var mDefaultColor:uint;
      
      public function PropHuntControlItem()
      {
         super();
         this.mDefaultColor = this.myLabel.textColor;
      }
      
      public function setText(label:String, command:String, toggledLabel:String = null) : void
      {
         this.mDefaultLabel = label;
         this.mToggledLabel = toggledLabel;
         this.myLabel.text = label;
         this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand(command);
      }
      
      public function cppSetToggled(toggled:Boolean) : void
      {
         if(toggled)
         {
            this.myLabel.text = this.mToggledLabel;
            this.myLabel.textColor = 633855;
         }
         else
         {
            this.myLabel.text = this.mDefaultLabel;
            this.myLabel.textColor = this.mDefaultColor;
         }
      }
      
      public function cppSetLabelParam(param:String) : void
      {
         var coloredParam:String = "<font color=\'#09abff\'>" + param + "</font>";
         this.myLabel.htmlText = LocalizeUtil.replaceConversionString(LocalizeUtil.localize(this.mDefaultLabel),[coloredParam]);
      }
      
      override public function get width() : Number
      {
         return this.myKey.x + this.myKey.textWidth;
      }
   }
}


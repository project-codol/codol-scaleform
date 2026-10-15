package codo.views.hud.popups.HudSplashPopup_parts
{
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudNftblSplashContent extends HudSplashPopupContent
   {
      
      public var myIcon:FsgImageHolder;
      
      public var myTitle:TextField;
      
      public var myDesc:TextField;
      
      public var myBg:MovieClip;
      
      public function HudNftblSplashContent()
      {
         super();
         this.myBg.x = 0;
         this.myBg.y = 0;
         this.myIcon.x = this.myBg.x + 155;
         this.myIcon.y = this.myBg.y + 18;
         this.myTitle.x = this.myBg.x + 235;
         this.myTitle.y = this.myBg.y + 5;
         this.myDesc.x = this.myBg.x + 240;
         this.myDesc.y = this.myBg.y + 39;
      }
      
      override public function setData(icon:String, title:String, titleColor:int, description:String, param:String) : void
      {
         var textWidth:Number = NaN;
         this.myIcon.setImage(icon);
         this.myTitle.textColor = titleColor;
         LocalizeUtil.setTextFieldColorWithLocalizedString(this.myTitle,title);
         LocalizeUtil.setTextFieldColorWithLocalizedString(this.myDesc,description);
         if(icon == null || icon == "")
         {
            textWidth = Math.max(this.myTitle.textWidth,this.myDesc.textWidth);
            this.myTitle.x = this.myBg.x + (this.myBg.width - textWidth) * 0.5;
         }
         else
         {
            this.myTitle.x = this.myBg.x + 235;
         }
         this.myDesc.x = this.myTitle.x + 5;
         trace(this.myTitle.x);
         this.myTitle.y = this.myBg.y + 5;
         this.myDesc.y = this.myTitle.y + this.myTitle.textHeight + 5;
         var textDemandedHeight:Number = this.myDesc.y + this.myDesc.textHeight + 10 - this.myBg.y;
         this.myBg.height = Math.max(104,textDemandedHeight);
      }
   }
}


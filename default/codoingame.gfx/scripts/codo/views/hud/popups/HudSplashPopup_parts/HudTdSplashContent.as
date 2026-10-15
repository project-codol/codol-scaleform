package codo.views.hud.popups.HudSplashPopup_parts
{
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdSplashContent extends HudSplashPopupContent
   {
      
      private const PADDING_X:Number = 80;
      
      public var myTitle:TextField;
      
      public var myDesc:TextField;
      
      public var myBg:MovieClip;
      
      public function HudTdSplashContent()
      {
         super();
      }
      
      override public function setData(icon:String, title:String, titleColor:int, description:String, param:String) : void
      {
         LocalizeUtil.setTextFieldColorWithLocalizedString(this.myTitle,LocalizeUtil.getLocalizationWithKeyBinding(title));
         LocalizeUtil.setTextFieldColorWithLocalizedString(this.myDesc,LocalizeUtil.getLocalizationWithKeyBinding(description));
         this.myBg.width = this.myTitle.textWidth + 2 * this.PADDING_X;
         if(this.myBg.width < this.myDesc.textWidth + 2 * this.PADDING_X)
         {
            this.myBg.width = this.myDesc.textWidth + 2 * this.PADDING_X;
         }
         this.myTitle.x = (this.myBg.width - this.myTitle.textWidth) * 0.5;
         this.myDesc.x = (this.myBg.width - this.myDesc.textWidth) * 0.5;
      }
   }
}


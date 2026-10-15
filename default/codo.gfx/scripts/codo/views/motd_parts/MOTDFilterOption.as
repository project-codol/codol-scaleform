package codo.views.motd_parts
{
   import codo.component.TextField;
   import codo.component.filter.FilterOption;
   import codo.objects.MOTDMessageObj;
   import codo.style.GlobalGuide;
   import codo.style.MOTDGuide;
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   
   public class MOTDFilterOption extends FilterOption
   {
      
      public static const MOTD_OPTION_MAX_WIDTH:int = 440;
      
      private static const PADDING:int = 10;
      
      public var myDate:TextField;
      
      public var myDescription:TextField;
      
      public var mySender:TextField;
      
      private var mBaseAlpha:Number = 0.5;
      
      public function MOTDFilterOption()
      {
         super();
         myLabel.visible = false;
         this.mySender.textStyle = MOTDGuide.styleMOTDFilterOptionTitle;
         this.myDate.textStyle = MOTDGuide.styleMOTDFilterOptionDate;
         this.myDescription.textStyle = MOTDGuide.styleMOTDFilterOptionDescription;
         myBackground.width = this.myDescription.width = this.mySender.width = MOTD_OPTION_MAX_WIDTH;
         myBackground.height = 58;
         this.mySender.y = this.mySender.x = this.myDescription.x = PADDING;
         this.myDate.y = PADDING - 5;
         this.myDescription.y = myLabel.y + myLabel.textHeight + 4;
         this.myDescription.myTextClip.width = myBackground.width - PADDING * 2;
         myNewTag["myLabelTF"].visible = false;
      }
      
      override public function setData(data:*) : void
      {
         var mailData:MOTDMessageObj = null;
         super.setData(data);
         mailData = mData as MOTDMessageObj;
         if(mailData == null)
         {
            return;
         }
         myNewTag.visible = !mailData.beViewed;
         this.mySender.text = mailData.msgSender;
         this.myDescription.text = mailData.caption;
         this.myDate.text = mailData.formattedTime;
         this.myDate.x = myBackground.width - (this.myDate.textWidth + PADDING);
         myNewTag.x = this.myDate.x;
      }
      
      override public function setAlternatingRowStyleEven() : void
      {
         this.mBaseAlpha = myBackground.alpha = 0.5;
      }
      
      override public function setAlternatingRowStyleOdd() : void
      {
         this.mBaseAlpha = 0.3;
         this.updateHighlightState();
      }
      
      override public function set width(w:Number) : void
      {
         myBackground.width = w;
         this.myDate.x = myBackground.width - (this.myDate.textWidth + PADDING);
         myNewTag.x = this.myDate.x + (this.myDate.textWidth - 2);
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         myNewTag.visible = false;
      }
      
      override public function get height() : Number
      {
         return 58;
      }
      
      public function get formatID() : Number
      {
         var mailData:MOTDMessageObj = mData as MOTDMessageObj;
         return mailData.format;
      }
      
      override protected function updateHighlightState() : void
      {
         TweenMax.killTweensOf(myBackground);
         if(!enabled)
         {
            this.mySender.fontColor = GlobalGuide.CODO_GRAY_LIGHT;
            alpha = 0.5;
         }
         else if(checked || _isFocused)
         {
            TweenMax.to(myBackground,ANIM_DURATION,{
               "alpha":1,
               "colorMatrixFilter":{
                  "colorize":GlobalGuide.CODO_BLUE_HIGHLIGHT,
                  "amount":1
               },
               "ease":Cubic.easeOut
            });
            this.myDescription.fontColor = this.myDate.fontColor = GlobalGuide.WHITE;
         }
         else
         {
            this.myDate.fontColor = GlobalGuide.GRAY_80;
            this.mySender.fontColor = GlobalGuide.WHITE;
            this.myDescription.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            TweenMax.to(myBackground,ANIM_DURATION,{
               "alpha":this.mBaseAlpha,
               "colorMatrixFilter":{
                  "colorize":GlobalGuide.CODO_BLACK,
                  "amount":1
               },
               "ease":Cubic.easeOut
            });
         }
      }
      
      override protected function draw() : void
      {
      }
   }
}


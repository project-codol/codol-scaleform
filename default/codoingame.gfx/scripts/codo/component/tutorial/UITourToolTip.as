package codo.component.tutorial
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.localization.Dict;
   import codo.localization.DictUITutorial;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   
   public class UITourToolTip extends BaseSubElement
   {
      
      public static const ARROW_LEFT:uint = 0;
      
      public static const ARROW_RIGHT:uint = 1;
      
      public static const ARROW_DOWN:uint = 2;
      
      public static const ARROW_UP:uint = 3;
      
      public static const STYLE_2_BTN:uint = 0;
      
      public static const STYLE_1_BTN:uint = 1;
      
      public static const STYLE_0_BTN:uint = 2;
      
      public static const STYLE_0_BTN_NO_ARROW:uint = 3;
      
      private static const LOCALIZE:Function = LocalizeUtil.localize;
      
      private static const REVEAL_DURATION:Number = 0.2;
      
      private static const LEARN_MORE_STR:String = DictUITutorial.UI_TOUR_TOOL_TIP_BUTTON_LEARN_MORE;
      
      private static const DEFAULT_WIDTH:Number = 301;
      
      private static const DEFAULT_HEIGHT:Number = 240;
      
      private static const SLIDE_DURATION:Number = 0.25;
      
      public var myIcon:UITourToolTipIcon;
      
      public var myLearnMoreBtn:Button;
      
      public var myNoThanksBtn:Button;
      
      public var myCoverButton:Button;
      
      public var myCorners:MovieClip;
      
      public var myGeneralTitleTF:TextField;
      
      public var myGeneralTitleBKG:Sprite;
      
      public var myStripe:Sprite;
      
      public var myAnimatedArrow_left:AnimatedArrow;
      
      public var myAnimatedArrow_right:AnimatedArrow;
      
      public var myHeaderTF:TextField;
      
      public var myDescriptionTF:TextField;
      
      public var myMask:MovieClip;
      
      public var myShadow:Sprite;
      
      public var myBkg:Sprite;
      
      private var mClickCallback:Function;
      
      private var mBypassAllAnim:Boolean = false;
      
      private var mBypassArrowAnim:Boolean = false;
      
      private var mActiveArrow:AnimatedArrow;
      
      private var mShownData:UITourToolTipObj;
      
      private var mStyle:uint = 0;
      
      public function UITourToolTip()
      {
         super();
         this.mActiveArrow = this.myAnimatedArrow_left;
         this.myIcon.pulsing = true;
         this.onDeactive();
         this.myCorners.mouseEnabled = this.myMask.mouseEnabled = this.myCorners.mouseChildren = this.myIcon.mouseEnabled = false;
         this.myShadow.alpha = 0;
         this.myNoThanksBtn.registerClickEvent(this.onNoThanksClicked);
         this.myLearnMoreBtn.registerClickEvent(this.onLearnMoreClicked);
         this.formatLabels();
         this.setLabels();
      }
      
      public function setTipStyle(style:uint) : void
      {
         if(this.mStyle == style)
         {
            return;
         }
         this.mStyle = style;
         if(style == STYLE_0_BTN_NO_ARROW)
         {
            this.myAnimatedArrow_left.deactive();
            this.myAnimatedArrow_right.deactive();
            this.myLearnMoreBtn.visible = this.myNoThanksBtn.visible = false;
         }
         else if(style == STYLE_0_BTN)
         {
            this.myLearnMoreBtn.visible = this.myNoThanksBtn.visible = false;
         }
         else if(style == STYLE_1_BTN)
         {
            this.myLearnMoreBtn.visible = true;
            this.myNoThanksBtn.visible = false;
            this.myLearnMoreBtn.label = Dict.CONTINUE;
         }
         else if(style == STYLE_2_BTN)
         {
            this.myLearnMoreBtn.visible = this.myNoThanksBtn.visible = true;
            this.myLearnMoreBtn.label = LEARN_MORE_STR;
         }
      }
      
      private function formatLabels() : void
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         style.autoSize = TextFieldAutoSize.LEFT;
         this.myGeneralTitleTF.textStyle = style;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         style.multiLine = style.wordWrap = true;
         this.myDescriptionTF.textStyle = style;
         this.myHeaderTF.width = this.myDescriptionTF.width = 229;
         this.myDescriptionTF.visible = false;
         style.multiLine = style.wordWrap = false;
         this.myHeaderTF.textStyle = style;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 14;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         this.myNoThanksBtn.width = this.myLearnMoreBtn.width = 115;
         this.myNoThanksBtn.height = this.myLearnMoreBtn.height = 30;
         this.myNoThanksBtn.myLabel.textStyle = this.myLearnMoreBtn.myLabel.textStyle = style;
      }
      
      public function set clickCallback(callback:Function) : void
      {
         this.mClickCallback = callback;
      }
      
      private function onLearnMoreClicked() : void
      {
         this.mClickCallback(true);
      }
      
      private function onNoThanksClicked() : void
      {
         this.mClickCallback(false);
      }
      
      private function setLabels() : void
      {
         var noThanksLabel:String = LOCALIZE(DictUITutorial.UI_TOUR_TOOL_TIP_BUTTON_NO_THANKS);
         var learnMoreLabel:String = LOCALIZE(LEARN_MORE_STR);
         var generalHeader:String = LOCALIZE(DictUITutorial.UI_TOUR_TOOL_TIP_TITLE);
         var PADDING:int = 45;
         var DEFAULT_FLASH_TF_OFFSET:int = 2;
         if(this.useDebugText)
         {
            generalHeader = "WHAT\'S NEW";
            noThanksLabel = "NO THANKS";
            learnMoreLabel = "LEARN MORE";
            this.setTipContent("CONTRACTS ARE REALLY COOL","Completing these special tasks will increase the amount of XP you gain when you play matches.");
         }
         this.myGeneralTitleTF.text = generalHeader;
         this.myNoThanksBtn.label = noThanksLabel;
         this.myLearnMoreBtn.label = learnMoreLabel;
         this.myNoThanksBtn.myLabel.x = (this.myNoThanksBtn.width - this.myNoThanksBtn.myLabel.textWidth) * 0.5 - DEFAULT_FLASH_TF_OFFSET;
         this.myLearnMoreBtn.myLabel.x = (this.myLearnMoreBtn.width - this.myLearnMoreBtn.myLabel.textWidth) * 0.5 - DEFAULT_FLASH_TF_OFFSET;
         this.myLearnMoreBtn.x = this.myNoThanksBtn.x + this.myNoThanksBtn.width + 3;
         this.myGeneralTitleBKG.width = this.myGeneralTitleTF.textWidth + PADDING;
      }
      
      public function showHelpTip(tip:UITourToolTipObj) : void
      {
         if(this.mShownData == tip)
         {
            return;
         }
         this.mShownData = tip;
         if(tip.tooltipSize != null)
         {
            this.setSize(tip.tooltipSize.x,tip.tooltipSize.y);
         }
         x = tip.positionCoordinates.x;
         y = tip.positionCoordinates.y;
         this.setTipStyle(tip.tipStyle);
         this.setTipContent(tip.title,tip.description,tip.arrowDir);
         this.active();
      }
      
      public function getShownData() : UITourToolTipObj
      {
         return this.mShownData;
      }
      
      override public function active() : void
      {
         super.active();
         TweenLite.killTweensOf(this.myShadow);
         TweenLite.killTweensOf(this.myLearnMoreBtn);
         TweenLite.killTweensOf(this.myNoThanksBtn);
         if(this.mBypassAllAnim)
         {
            this.myMask.gotoAndStop(this.myMask.totalFrames - 1);
            this.myShadow.alpha = this.myLearnMoreBtn.alpha = this.myNoThanksBtn.alpha = 1;
         }
         else
         {
            this.myMask.gotoAndPlay(2);
            TweenLite.to(this.myShadow,REVEAL_DURATION,{
               "alpha":1,
               "ease":Cubic.easeOut,
               "delay":1.1
            });
            this.showCorners();
            this.doActivateButtons();
         }
      }
      
      public function set byPassAnimation(doBypass:Boolean) : void
      {
         this.mBypassAllAnim = doBypass;
      }
      
      public function set byPassArrowAnimation(doBypass:Boolean) : void
      {
         this.mBypassArrowAnim = doBypass;
      }
      
      private function setArrowDir(dir:uint) : void
      {
         var newArrow:AnimatedArrow = null;
         if(dir == ARROW_LEFT)
         {
            newArrow = this.myAnimatedArrow_left;
            newArrow.rotation = 90;
            newArrow.x = 0;
            newArrow.y = 19;
            newArrow.scaleX = 0.609;
         }
         else if(dir == ARROW_RIGHT)
         {
            newArrow = this.myAnimatedArrow_right;
         }
         else if(dir == ARROW_DOWN)
         {
            newArrow = this.myAnimatedArrow_left;
            newArrow.rotation = 0;
            newArrow.x = 10;
            newArrow.y = 285;
            newArrow.scaleX = 0.609;
         }
         else if(dir == ARROW_UP)
         {
            newArrow = this.myAnimatedArrow_left;
            newArrow.rotation = -180;
            newArrow.scaleX = -0.609;
            newArrow.x = 10;
            newArrow.y = 48;
         }
         if(this.mActiveArrow != newArrow)
         {
            this.mActiveArrow.deactive();
            this.mActiveArrow = newArrow;
         }
      }
      
      public function doActivateButtons(activateBtns:Boolean = true) : void
      {
         if(this.mStyle == STYLE_0_BTN_NO_ARROW)
         {
            return;
         }
         if(activateBtns)
         {
            if(!this.mBypassArrowAnim)
            {
               this.mActiveArrow.active();
            }
            TweenLite.to(this.myLearnMoreBtn,REVEAL_DURATION,{
               "alpha":1,
               "ease":Cubic.easeOut,
               "delay":0.4
            });
            TweenLite.to(this.myNoThanksBtn,REVEAL_DURATION,{
               "alpha":1,
               "ease":Cubic.easeOut,
               "delay":0.6
            });
         }
         this.myNoThanksBtn.enabled = this.myCoverButton.enabled = this.myLearnMoreBtn.enabled = activateBtns;
      }
      
      override public function deactive() : void
      {
         if(this.mShownData == null)
         {
            return;
         }
         this.onDeactive();
      }
      
      private function onDeactive() : void
      {
         super.deactive();
         this.myShadow.alpha = this.myLearnMoreBtn.alpha = this.myNoThanksBtn.alpha = 0;
         this.doActivateButtons(false);
         this.myMask.gotoAndStop(1);
         this.showCorners(false);
         this.mActiveArrow.deactive();
         this.mShownData = null;
      }
      
      public function setTipContent(title:String, description:String, arrowDir:uint = 0) : void
      {
         this.myHeaderTF.text = LOCALIZE(title);
         this.setArrowDir(arrowDir);
         if(description != null)
         {
            this.myDescriptionTF.visible = true;
            this.myDescriptionTF.text = LOCALIZE(description);
         }
      }
      
      private function showCorners(doShow:Boolean = true) : void
      {
         var halfWidth:Number = NaN;
         var halfHeight:Number = NaN;
         var topLeft:Point = null;
         var topRight:Point = null;
         var btmRight:Point = null;
         var btmLeft:Point = null;
         if(doShow)
         {
            halfWidth = this.myBkg.width * 0.5;
            halfHeight = this.myBkg.height * 0.5;
            topLeft = new Point(-halfWidth + 4,-halfHeight + 5);
            topRight = new Point(halfWidth - 10,-halfHeight - 1);
            btmRight = new Point(halfWidth - 4,halfHeight - 15);
            btmLeft = new Point(-halfWidth + 10,halfHeight - 9);
            TweenLite.to(this.myCorners.myCornerTL,SLIDE_DURATION,{
               "x":topLeft.x,
               "y":topLeft.y,
               "rotation":-90,
               "delay":0.15
            });
            TweenLite.to(this.myCorners.myCornerTR,SLIDE_DURATION,{
               "x":topRight.x,
               "y":topRight.y,
               "rotation":0,
               "delay":0.15
            });
            TweenLite.to(this.myCorners.myCornerBR,SLIDE_DURATION,{
               "x":btmRight.x,
               "y":btmRight.y,
               "rotation":90,
               "delay":0.15
            });
            TweenLite.to(this.myCorners.myCornerBL,SLIDE_DURATION,{
               "x":btmLeft.x,
               "y":btmLeft.y,
               "rotation":-180,
               "delay":0.15
            });
         }
         else
         {
            this.myCorners.myCornerTL.x = 0;
            this.myCorners.myCornerTL.y = 4;
            this.myCorners.myCornerTL.rotation = -135;
            this.myCorners.myCornerTR.x = 0;
            this.myCorners.myCornerTR.y = 4;
            this.myCorners.myCornerTR.rotation = 45;
            this.myCorners.myCornerBR.x = 0;
            this.myCorners.myCornerBR.y = -4;
            this.myCorners.myCornerBR.rotation = 45;
            this.myCorners.myCornerBL.x = 0;
            this.myCorners.myCornerBL.y = 4;
            this.myCorners.myCornerBL.rotation = -135;
         }
      }
      
      private function get useDebugText() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
      
      private function setSize(w:Number, h:Number) : void
      {
         var newScaleX:Number = w / DEFAULT_WIDTH;
         var newScaleY:Number = h / DEFAULT_HEIGHT;
         this.myMask.scaleX *= newScaleX + 2;
         this.myMask.scaleY *= newScaleY + 2;
         this.myBkg.width = w;
         this.myBkg.height = h;
         this.myStripe.width = w;
         this.myStripe.height = h;
         this.myMask.x = this.myBkg.x + this.myBkg.width * 0.5;
         this.myMask.y = this.myBkg.y + this.myBkg.height * 0.5;
         this.myCorners.x = this.myMask.x;
         this.myCorners.y = this.myMask.y + 5;
         this.myHeaderTF.width = this.myDescriptionTF.width = w - 60;
         this.myLearnMoreBtn.x = this.myBkg.x + this.myBkg.width - this.myLearnMoreBtn.width - 20;
         this.myNoThanksBtn.x = this.myLearnMoreBtn.x - this.myNoThanksBtn.width - 10;
      }
   }
}


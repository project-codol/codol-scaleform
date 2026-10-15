package codo.views.hud.td
{
   import codo.constants.GameInfo;
   import codo.utils.MathUtil;
   import codo.views.hud.shared.AnimatedWaypointBase;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TurretWaypoint extends AnimatedWaypointBase
   {
      
      private const ICON_BASE_SIZE:Number = 54;
      
      private const BAR_WIDTH:Number = 192;
      
      private const FRUSTUM_DISTANCE_REVISE:Number = 150;
      
      private const SCALE_DISTANCE_MIN:Number = 100;
      
      private const SCALE_SMALLEST:Number = 0.25;
      
      private const ARROW_SCREEN_MARGIN:Number = 4;
      
      private const DAMAGE_OVERLAY_DURATION:Number = 4000;
      
      public var myUpgradeLabel:TextField;
      
      public var myUpgradeProgressBar:MovieClip;
      
      public var myHpBar:MovieClip;
      
      public var myStars:MovieClip;
      
      public var myUpgradeableMark:MovieClip;
      
      public var myMoneyPopups:MovieClip;
      
      private var mPopups:Array;
      
      private var mPopupIndex:int;
      
      private var mLastTakeDamageTime:int;
      
      private var mHpRatio:Number;
      
      public function TurretWaypoint()
      {
         var popup:MovieClip = null;
         super();
         this.mPopups = new Array();
         for(var i:int = 0; true; i++)
         {
            popup = this.myMoneyPopups.getChildByName("popup".concat(i)) as MovieClip;
            if(popup == null)
            {
               break;
            }
            popup.visible = false;
            this.mPopups.push(popup);
         }
         this.mPopupIndex = 0;
         this.mHpRatio = -1;
         this.mLastTakeDamageTime = -this.DAMAGE_OVERLAY_DURATION;
      }
      
      override public function setData(data:*) : void
      {
         if(data.upgradeProgress > 0)
         {
            this.myUpgradeLabel.visible = this.myUpgradeProgressBar.visible = true;
            this.myUpgradeProgressBar.myBar.width = this.BAR_WIDTH * data.upgradeProgress;
         }
         else
         {
            this.myUpgradeLabel.visible = this.myUpgradeProgressBar.visible = false;
         }
         this.myUpgradeableMark.visible = !this.myUpgradeProgressBar.visible && Boolean(data.canUpgrade);
         this.myStars.visible = data.level > 0;
         this.myStars.gotoAndStop(data.level);
         this.myStars.y = (this.myUpgradeProgressBar.visible ? this.myUpgradeLabel.y : this.myHpBar.y) - this.myStars.height;
         this.myMoneyPopups.y = this.myStars.y;
         var worldDistance:Number = Number(data.drawInfo.worldDistance);
         var additionalScale:Number = (this.FRUSTUM_DISTANCE_REVISE + this.SCALE_DISTANCE_MIN) / (worldDistance + this.FRUSTUM_DISTANCE_REVISE);
         additionalScale = MathUtil.clamp(additionalScale,this.SCALE_SMALLEST,1);
         scaleX *= additionalScale;
         scaleY *= additionalScale;
         this.updateHPBar(data.hpRatio,data.time);
      }
      
      override public function setupScale(w:Number, h:Number) : void
      {
         scaleX = w / this.ICON_BASE_SIZE;
         scaleY = w / this.ICON_BASE_SIZE;
      }
      
      public function doMoneyPopup(amount:int, config:Object) : void
      {
         var popup:MovieClip = null;
         popup = this.mPopups[this.mPopupIndex];
         popup.visible = true;
         popup.gotoAndPlay(1);
         this.myMoneyPopups.setChildIndex(popup,this.myMoneyPopups.numChildren - 1);
         var textField:TextField = popup.label.textField as TextField;
         var textFormat:TextFormat = textField.defaultTextFormat;
         textFormat.size = config.fontSize;
         textField.text = "$" + amount;
         textField.defaultTextFormat = textFormat;
         textField.setTextFormat(textFormat);
         textField.textColor = config.color;
         ++this.mPopupIndex;
         if(this.mPopupIndex >= this.mPopups.length)
         {
            this.mPopupIndex = 0;
         }
      }
      
      private function isHpBarFullOffscreen() : Boolean
      {
         var borderTop:Number = -(this.myHpBar.y + this.myHpBar.height) * scaleY + this.ARROW_SCREEN_MARGIN;
         var borderBottom:Number = GameInfo.stageSize.y - this.myHpBar.y * scaleY - this.ARROW_SCREEN_MARGIN;
         var borderLeft:Number = -this.myHpBar.width * scaleX * 0.5 + this.ARROW_SCREEN_MARGIN;
         var borderRight:Number = this.myHpBar.width * scaleX * 0.5 + GameInfo.stageSize.x - this.ARROW_SCREEN_MARGIN;
         if(y < borderTop || y > borderBottom || x < borderLeft || x > borderRight)
         {
            return true;
         }
         return false;
      }
      
      private function updateHPBar(hpRatio:Number, time:int) : void
      {
         if(hpRatio < this.mHpRatio)
         {
            this.mLastTakeDamageTime = time;
         }
         this.mHpRatio = hpRatio;
         this.myHpBar.myBar.width = this.BAR_WIDTH * hpRatio;
         var takeDamageRecently:Boolean = time - this.mLastTakeDamageTime < this.DAMAGE_OVERLAY_DURATION;
         myArrow.alpha = 1;
         myArrow.visible = takeDamageRecently && this.isHpBarFullOffscreen();
         this.myHpBar.myOverlay.visible = takeDamageRecently;
      }
   }
}


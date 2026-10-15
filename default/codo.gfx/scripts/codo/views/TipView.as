package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.constants.MouseSize;
   import codo.constants.SE_ID;
   import codo.constants.TipType;
   import codo.event.ParaEvent;
   import codo.interfaces.ITipView;
   import codo.objects.ToolTipObject;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import components.tip_part.BaseTip;
   import components.tip_part.GlobalToolTip;
   import components.tip_part.ItemTip;
   import components.tip_part.MainNavigationTip;
   import components.tip_part.RenewTip;
   import components.tip_part.WeaponToolTip;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import fsg.util.FsgAudioUtil;
   import shaui.component.core.UIComponent;
   
   public class TipView extends BaseView implements ITipView
   {
      
      public static var myStaticToolTip:GlobalToolTip;
      
      private static const TIP_DELAY:Number = 0.25;
      
      private static const TIP_FADE:Number = 0.15;
      
      public var myGeneralTip:MainNavigationTip;
      
      public var myItemTip:MovieClip;
      
      public var myOldWeaponTip:ItemTip;
      
      public var myWeaponTip:WeaponToolTip;
      
      public var myRenewTip:RenewTip;
      
      private var _currentTip:*;
      
      private var _currentData:Object;
      
      public function TipView()
      {
         super();
         enable = false;
      }
      
      override protected function onInit() : void
      {
         UIComponent.TIP_VIEW = this;
         this.hideAllTip();
         this._currentTip = this.myGeneralTip;
         this.myItemTip.visible = false;
         this.myWeaponTip.visible = false;
         this.myOldWeaponTip.visible = false;
         myStaticToolTip = new fsgGlobalToolTip() as GlobalToolTip;
         addChild(myStaticToolTip as DisplayObject);
         myStaticToolTip.visible = false;
      }
      
      override protected function onInitListener() : void
      {
         listen(BCEvent.TIP_SHOW,this.onTipShowHandle);
         listen(BCEvent.TIP_HIDE,this.onTipHideHandle);
      }
      
      public function displayTip(cTarget:UIComponent) : void
      {
         if(cTarget.tipEnable == true)
         {
            alpha = 0;
            this.ShowToolTip();
         }
      }
      
      public function displayGlobalToolTip(tipConfig:ToolTipObject) : void
      {
         myStaticToolTip.build(tipConfig);
         this._currentTip = myStaticToolTip;
         TweenLite.killTweensOf(myStaticToolTip);
         TweenLite.to(myStaticToolTip,TIP_FADE,{
            "autoAlpha":1,
            "onComplete":this.onTipVisible
         });
      }
      
      public function hideGlobalToolTip() : void
      {
         TweenLite.killTweensOf(myStaticToolTip);
         TweenLite.to(myStaticToolTip,TIP_FADE,{"autoAlpha":0});
      }
      
      private function ShowToolTip() : void
      {
         TweenLite.killTweensOf(this._currentTip);
         TweenLite.to(this._currentTip,TIP_FADE,{
            "delay":TIP_DELAY,
            "autoAlpha":1,
            "onComplete":this.onTipVisible
         });
      }
      
      private function onTipVisible() : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.TOOLTIP_SHOW);
      }
      
      public function removeTip(cTarget:UIComponent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTipMouseMoveHandle);
         this.onTipMouseOutHandle(cTarget);
         this._currentData = null;
      }
      
      private function onTipShowHandle(cEvt:ParaEvent) : void
      {
         var visibleRect:Rectangle = null;
         var tooltipType:int = 0;
         var topLeft:Point = null;
         var bottomRight:Point = null;
         var visibleRectLocalToCurrentTip:Rectangle = null;
         var tipBounds:Rectangle = null;
         var bValidTooltip:Boolean = false;
         if(cEvt.myPara != null)
         {
            this.hideAllTip();
            this.chooseTipByID(cEvt.myPara.type);
            visibleRect = ScaleformUtil.visibleRect(this._currentTip);
            tooltipType = int(cEvt.myPara.type);
            this._currentTip.x = cEvt.myPara.pos.x;
            this._currentTip.y = cEvt.myPara.pos.y;
            switch(tooltipType)
            {
               case TipType.GENERAL_ALIGN_TOP:
               case TipType.GENERAL_ALIGN_BOTTOM:
                  if(cEvt.myPara.text != null && cEvt.myPara.text != "")
                  {
                     bValidTooltip = true;
                     this._currentTip.setFlipped(tooltipType == TipType.GENERAL_ALIGN_BOTTOM);
                     this._currentTip.textWidth = cEvt.myPara.size.x;
                     this._currentTip.data = cEvt.myPara.text;
                  }
                  break;
               case TipType.TEXT:
                  if(cEvt.myPara.text != null && cEvt.myPara.text != "")
                  {
                     bValidTooltip = true;
                     this._currentTip.setFlipped(false);
                     this._currentTip.textWidth = cEvt.myPara.size.x;
                     this._currentTip.data = cEvt.myPara.text;
                     if(this._currentTip.y + this._currentTip.height > visibleRect.height)
                     {
                        this._currentTip.setFlipped(true);
                        this._currentTip.x = cEvt.myPara.altPos.x;
                        this._currentTip.y = cEvt.myPara.altPos.y;
                        this._currentTip.textWidth = cEvt.myPara.size.x;
                        this._currentTip.data = cEvt.myPara.text;
                     }
                  }
                  break;
               case TipType.ITEM_TIP:
                  if(cEvt.myPara.data != null)
                  {
                     bValidTooltip = true;
                     this._currentTip.data = cEvt.myPara.data;
                     this._currentTip.offsetFlippedTip(cEvt.myPara.parentHeight);
                  }
                  break;
               case TipType.GENERAL_ITEM:
               case TipType.RENEW_TIP:
                  bValidTooltip = true;
            }
            topLeft = this._currentTip.globalToLocal(visibleRect.topLeft);
            bottomRight = this._currentTip.globalToLocal(visibleRect.bottomRight);
            visibleRectLocalToCurrentTip = new Rectangle(topLeft.x,topLeft.y,bottomRight.x - topLeft.x,bottomRight.y - topLeft.y);
            tipBounds = this._currentTip.getBounds(this._currentTip);
            if(!visibleRectLocalToCurrentTip.containsRect(tipBounds))
            {
               if(tipBounds.left < visibleRectLocalToCurrentTip.left)
               {
                  if(this._currentTip.offsetX != null)
                  {
                     this._currentTip.offsetX(visibleRectLocalToCurrentTip.left - tipBounds.left);
                  }
               }
               else if(tipBounds.right > visibleRectLocalToCurrentTip.right)
               {
                  if(this._currentTip.offsetX != null)
                  {
                     this._currentTip.offsetX(visibleRectLocalToCurrentTip.right - tipBounds.right);
                  }
               }
            }
            if(Boolean(cEvt.myPara.hasOwnProperty("showPointer")))
            {
               MovieClip(this._currentTip.myPointer).visible = cEvt.myPara.showPointer as Boolean;
            }
            if(Boolean(cEvt.myPara.hasOwnProperty("toolTipFormat")) && cEvt.myPara.toolTipFormat != null)
            {
               this._currentTip.toolTipFormat = cEvt.myPara.toolTipFormat as TextFormat;
            }
            if(bValidTooltip)
            {
               this.ShowToolTip();
            }
         }
      }
      
      private function onTipHideHandle(cEvt:ParaEvent) : void
      {
         this.hideAllTip();
      }
      
      private function onTipMouseOutHandle(cTarget:UIComponent) : void
      {
         TweenLite.killTweensOf(this._currentTip);
         TweenLite.to(this._currentTip,TIP_FADE,{"autoAlpha":0});
      }
      
      private function onTipMouseMoveHandle(cEvt:MouseEvent) : void
      {
         if(this._currentData != null && this._currentData.mouseFollow == true)
         {
            this.tryTipMouseFollow(this._currentTip);
         }
      }
      
      private function chooseTipByID(cTipID:uint) : void
      {
         switch(cTipID)
         {
            case TipType.GENERAL_ALIGN_TOP:
            case TipType.GENERAL_ALIGN_BOTTOM:
            case TipType.TEXT:
               this._currentTip = this.myGeneralTip;
               break;
            case TipType.GENERAL_ITEM:
               this._currentTip = this.myItemTip;
               break;
            case TipType.ITEM_TIP:
               this._currentTip = this.myWeaponTip;
               break;
            case TipType.RENEW_TIP:
               this._currentTip = this.myRenewTip;
         }
      }
      
      private function hideAllTip() : void
      {
         for(var i:uint = 0; i < numChildren; i++)
         {
            TweenLite.killTweensOf(getChildAt(i));
            if(getChildAt(i) is BaseTip || getChildAt(i) is ItemTip || getChildAt(i) is RenewTip || getChildAt(i) is WeaponToolTip)
            {
               getChildAt(i).visible = false;
               getChildAt(i).alpha = 0;
            }
         }
      }
      
      private function tryTipMouseFollow(cTarget:DisplayObject) : void
      {
         var posXOffset:Number = NaN;
         var posYOffset:Number = NaN;
         posXOffset = -60;
         posYOffset = 0;
         var targetX:int = stage.mouseX + (MouseSize.WIDTH + posXOffset);
         var targetY:int = stage.mouseY + (MouseSize.HEIGHT + posYOffset);
         if(targetX + cTarget.width + GameInfo.widthExtra > stage.stageWidth && cTarget == this.myItemTip)
         {
            targetX = stage.stageWidth - GameInfo.widthExtra - cTarget.width;
         }
         else if(targetX + cTarget.width / 2 + GameInfo.widthExtra > stage.stageWidth && cTarget != this.myItemTip)
         {
            targetX = stage.stageWidth - GameInfo.widthExtra - cTarget.width / 2;
         }
         if(targetY + cTarget.height + GameInfo.heightExtra > stage.stageHeight)
         {
            targetY = stage.stageHeight - cTarget.height - GameInfo.heightExtra;
         }
         cTarget.x = targetX;
         cTarget.y = targetY;
      }
   }
}


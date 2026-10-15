package fsg.shared
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.Dict;
   import codo.objects.ProductObj;
   import codo.objects.SKUObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class CurrencyButton extends MovieClip
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 1;
      
      private static const DISABLED_STATE_FRAME:int = 3;
      
      private static const CPCURRENCY_FRAME:int = 1;
      
      private static const GPCURRENCY_FRAME:int = 2;
      
      private static const PRESTIGE_ICON_X:int = 33;
      
      public var myHitArea:MovieClip;
      
      public var myText:MovieClip;
      
      public var myImgHolder:FsgImageHolder;
      
      public var myLock:MovieClip;
      
      public var myIcon:MovieClip;
      
      public var myBackground:MovieClip;
      
      private var m_useEquipLevel:Boolean;
      
      private var m_animated:BehaviourAnimatedClickable;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_audio:BehaviourAudio;
      
      private var m_clickCallback:CallbackList;
      
      private var m_tooltip:BehaviourTooltip;
      
      public function CurrencyButton()
      {
         super();
         if(this.myImgHolder != null)
         {
            this.myImgHolder.visible = false;
         }
         this.myLock.visible = false;
         this.myLock.myTextTF.text = " ";
         this.m_useEquipLevel = false;
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_animated = new BehaviourAnimatedClickable(this,this.m_clickable,UP_STATE_FRAME,OVER_STATE_FRAME,DOWN_STATE_FRAME,DISABLED_STATE_FRAME);
         this.m_audio = new BehaviourAudio(this.m_clickable);
         this.m_clickCallback = new CallbackList();
      }
      
      public function get audio() : BehaviourAudio
      {
         return this.m_audio;
      }
      
      public function get tooltip() : BehaviourTooltip
      {
         return this.m_tooltip;
      }
      
      public function addClickCallback(callback:Function, userData:Object = null) : void
      {
         this.m_clickCallback.addCallback(callback,userData);
      }
      
      public function removeCallback(callback:Function, userData:Object = null) : void
      {
         this.m_clickCallback.removeCallback(callback,userData);
      }
      
      public function useEquipLevel(val:Boolean) : void
      {
         this.m_useEquipLevel = val;
         this.myLock.gotoAndStop(val ? 2 : 1);
      }
      
      public function setEnabled(cEnable:Boolean) : void
      {
         if(cEnable && !this.myLock.visible)
         {
            this.m_clickable.addClickCallback(this.m_clickCallback.call);
         }
         else
         {
            this.m_clickable.removeClickCallback(this.m_clickCallback.call);
         }
         this.m_animated.setEnabled(cEnable && !this.myLock.visible);
         this.m_audio.setEnabled(cEnable && !this.myLock.visible);
      }
      
      public function setData(product:ProductObj, sku:SKUObj) : void
      {
         var strText:String = null;
         var sizeObj:Object = null;
         this.myText.myTextTF.text = sku.price.toString();
         this.myIcon.gotoAndStop(sku.currency == Dict.CP ? CPCURRENCY_FRAME : GPCURRENCY_FRAME);
         var level:int = this.m_useEquipLevel ? product.equipLevel : sku.requirementLevel;
         var displayLevel:String = CFunctionCommonContainer.GetDisplayLevel(level);
         this.myLock.myTextTF.text = displayLevel;
         this.myLock.visible = !product.purchasable || !sku.purchasable;
         if(this.myLock.visible && sku.requirementPrestige > 0)
         {
            if(this.myImgHolder != null)
            {
               this.myImgHolder.visible = true;
               this.myImgHolder.setImage(FsgUtil.getPrestigeIcon(sku.requirementPrestige));
               this.myImgHolder.x = PRESTIGE_ICON_X;
            }
         }
         else if(this.myImgHolder != null)
         {
            this.myImgHolder.visible = false;
         }
         if(!this.myLock.visible && Boolean(this.m_tooltip))
         {
            this.m_tooltip.dispose();
            this.m_tooltip = null;
         }
         else if(this.myLock.visible)
         {
            if(sku.requirementPrestige > 0)
            {
               strText = LocalizeUtil.replace(LocalizeUtil.localize(Dict.LOCKED_PRESTIGE_PURCHASEBUTTON_TOOLTIP),[sku.requirementPrestige,this.myLock.myTextTF.text,LocalizeUtil.localize(sku.currency) + this.myText.myTextTF.text]);
            }
            else
            {
               strText = LocalizeUtil.replace(LocalizeUtil.localize(Dict.LOCKED_PURCHASEBUTTON_TOOLTIP),[this.myLock.myTextTF.text,LocalizeUtil.localize(sku.currency) + this.myText.myTextTF.text]);
            }
            sizeObj = {
               "x":300,
               "y":0
            };
            if(!this.m_tooltip)
            {
               this.m_tooltip = new BehaviourTooltip(this.m_clickable,strText,this.myHitArea,sizeObj);
            }
            else
            {
               this.m_tooltip.setData(strText,sizeObj);
            }
         }
         this.setEnabled(true);
         this.myText.visible = !this.myLock.visible;
      }
   }
}


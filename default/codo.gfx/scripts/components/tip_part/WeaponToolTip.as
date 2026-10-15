package components.tip_part
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.ComponentCSS;
   import codo.event.ParaEvent;
   import codo.utils.DebugUtil;
   import codo.utils.ScaleformUtil;
   import components.fsgcustomise_part.FsgWeaponStatSettingDetailed;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class WeaponToolTip extends BaseView
   {
      
      private static const PROPERTY_AMOUNT:uint = 6;
      
      private static const COLOR_TEXT:Array = [ComponentCSS.FSG_COLOR_BLUE,ComponentCSS.FSG_COLOR_BLUE];
      
      public var myHeader:MovieClip;
      
      public var myDescription:MovieClip;
      
      public var myToolTipStats:FsgWeaponStatSettingDetailed;
      
      public var myAttribute0:MovieClip;
      
      public var myAttribute1:MovieClip;
      
      public var myAttribute2:MovieClip;
      
      public var myBackground1:MovieClip;
      
      public var myBackground2:MovieClip;
      
      private var m_cachedHeaderY:int;
      
      private var m_cachedDescY:int;
      
      private var m_cachedToolTipY:int;
      
      private var m_cachedAttributeY:int;
      
      public function WeaponToolTip()
      {
         super();
         this.onInit();
         this.onStyleChangeForMatchType();
         this.myToolTipStats.visible = false;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.m_cachedHeaderY = this.myHeader.y;
         this.m_cachedDescY = this.myDescription.y;
         this.m_cachedToolTipY = this.myToolTipStats.y;
         this.m_cachedAttributeY = this.myAttribute0.y;
         var dataReady:Boolean = CFunctionCommonContainer.IsWeaponDataReady() as Boolean;
         if(!dataReady)
         {
            listen(BCEvent.EVT_WEAPON_DATA_READY,this.onWeaponDataReady);
         }
         else
         {
            this.myToolTipStats.visible = true;
         }
      }
      
      private function onWeaponDataReady(evt:ParaEvent) : void
      {
         var isWeaponDataReady:Boolean = false;
         isWeaponDataReady = evt.myPara as Boolean;
         this.myToolTipStats.visible = isWeaponDataReady;
         if(isWeaponDataReady)
         {
            unlisten(BCEvent.EVT_WEAPON_DATA_READY,this.onWeaponDataReady);
         }
      }
      
      public function set data(cDat:Object) : void
      {
         var descText:String = null;
         var gap:Number = NaN;
         this.myHeader.myWeaponHeaderText.text = cDat.data.name;
         this.myDescription.myWeaponBodyText.text = cDat.data.description;
         var isEquipped:Boolean = cDat.isEquippedWeapon != null && cDat.isEquippedWeapon == true ? true : false;
         this.myToolTipStats.populateToolTip(cDat.data,this.myAttribute0,this.myAttribute1,this.myAttribute2,isEquipped);
         if(ScaleformUtil.IsLogItemIDEnabled())
         {
            descText = "";
            descText = DebugUtil.concatenateDebugSkuInfoToString(descText,cDat.data);
            this.myDescription.myWeaponBodyText.text = descText;
         }
         else
         {
            this.myDescription.myWeaponBodyText.text = cDat.data.description;
         }
         this.myDescription.myWeaponBodyText.autoSize = TextFieldAutoSize.LEFT;
         var tmpY:Number = y + height;
         var tmpX:Number = x + width;
         var visibleRect:Rectangle = ScaleformUtil.visibleRect();
         this.myHeader.y = this.m_cachedHeaderY;
         this.myDescription.y = this.m_cachedDescY;
         this.myToolTipStats.y = this.m_cachedToolTipY;
         this.myAttribute0.y = this.myAttribute1.y = this.myAttribute2.y = this.m_cachedAttributeY;
         if(x < visibleRect.x)
         {
            x = visibleRect.x;
         }
         else if(tmpX > visibleRect.x + visibleRect.width)
         {
            x = visibleRect.x + visibleRect.width - width;
         }
         if(tmpY > visibleRect.height)
         {
            this.myBackground2.height = this.myHeader.height + this.myDescription.height + this.myAttribute0.height + this.myToolTipStats.height + 30;
            gap = 264 - this.myBackground2.height;
            this.myHeader.y = 20 + gap;
            this.myDescription.y = 35 + gap;
            this.myAttribute0.y = this.myDescription.y + this.myDescription.height + 5;
            this.myAttribute1.y = this.myAttribute2.y = this.myAttribute0.y;
            this.myToolTipStats.y = this.myAttribute0.y + this.myAttribute0.height + 5;
            this.myBackground1.visible = false;
            this.myBackground2.visible = true;
            y -= 264;
         }
         else
         {
            this.myBackground1.height = this.myHeader.height + this.myDescription.height + this.myAttribute0.height + this.myToolTipStats.height + 30;
            this.myAttribute0.y = this.myDescription.y + this.myDescription.height + 5;
            this.myAttribute1.y = this.myAttribute2.y = this.myAttribute0.y;
            this.myToolTipStats.y = this.myAttribute0.y + this.myAttribute0.height + 5;
            this.myBackground1.visible = true;
            this.myBackground2.visible = false;
         }
      }
      
      public function offsetFlippedTip(yOffset:Number) : void
      {
         if(this.myBackground2.visible)
         {
            y -= yOffset;
         }
      }
   }
}


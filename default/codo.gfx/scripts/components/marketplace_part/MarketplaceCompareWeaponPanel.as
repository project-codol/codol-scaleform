package components.marketplace_part
{
   import codo.component.ScrollingTextField;
   import codo.component.TextField;
   import codo.component.factory.GlobalFactory;
   import codo.objects.ItemBuffListObj;
   import codo.objects.ItemBuffObj;
   import codo.objects.ProductObj;
   import codo.objects.WeaponStatsObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class MarketplaceCompareWeaponPanel extends MovieClip
   {
      
      private static const DESCRIPTION_WIDTH:Number = 381;
      
      private static const DESCRIPTION_HEIGHT:Number = 122;
      
      private static const ATT_WIDTH:Number = 400;
      
      private static const BACKGROUND_HEIGHT:Number = 494.35;
      
      public var myDescription:ScrollingTextField;
      
      public var myAttribute0:MovieClip;
      
      public var myAttribute1:MovieClip;
      
      public var myAttribute2:MovieClip;
      
      public var myBuffs:MovieClip;
      
      public var myBackground:MovieClip;
      
      private var mData:ProductObj;
      
      public function MarketplaceCompareWeaponPanel()
      {
         var labelStyle:TextStyle = null;
         super();
         this.myDescription.myText.textStyle = GlobalGuide.styleTextDescription;
         this.myDescription.myText.fontColor = GlobalGuide.GRAY_80;
         this.myDescription.width = DESCRIPTION_WIDTH;
         this.myDescription.height = DESCRIPTION_HEIGHT;
         labelStyle = new TextStyle();
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myAttribute0.myAttributeValue.textStyle = labelStyle;
         this.myAttribute0.myAttributeValue.width = ATT_WIDTH;
         this.myAttribute0.myAttributeValue.x = 0;
         labelStyle.fontColor = GlobalGuide.GRAY_80;
         this.myAttribute0.myAttributeTitle.textStyle = labelStyle;
         this.myAttribute0.myAttributeTitle.width = ATT_WIDTH;
         labelStyle.alignment = TextStyle.HALIGN_CENTER;
         this.myAttribute1.myAttributeTitle.textStyle = labelStyle;
         this.myAttribute2.myAttributeTitle.textStyle = labelStyle;
         this.myAttribute1.myAttributeTitle.width = ATT_WIDTH;
         this.myAttribute2.myAttributeTitle.width = ATT_WIDTH;
         var valueStyle:TextStyle = new TextStyle();
         valueStyle.font = GlobalGuide.FONT_FACE_NUMBERS;
         valueStyle.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         valueStyle.alignment = TextStyle.HALIGN_CENTER;
         this.myAttribute1.myAttributeValue.textStyle = valueStyle;
         this.myAttribute1.myAttributeValue.x = 0;
         this.myAttribute2.myAttributeValue.x = 0;
         this.myAttribute2.myAttributeValue.textStyle = valueStyle;
         this.myAttribute1.myAttributeValue.width = ATT_WIDTH;
         this.myAttribute2.myAttributeValue.width = ATT_WIDTH;
         if(false == ScaleformUtil.isScaleform)
         {
            this.myDescription.text = "Item Description Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim.";
            this.myAttribute0.myAttributeTitle.text = "FIRE TYPE";
            this.myAttribute0.myAttributeValue.text = "SEMI-AUTO";
            this.myAttribute1.myAttributeTitle.text = "FIRE RATE";
            this.myAttribute1.myAttributeValue.text = "11.34";
            this.myAttribute2.myAttributeTitle.text = "CLIP SIZE";
            this.myAttribute2.myAttributeValue.text = "36";
         }
      }
      
      public function set data(cDat:ProductObj) : void
      {
         this.mData = cDat;
         var stats:WeaponStatsObj = new WeaponStatsObj(this.mData);
         this.populateFireType(stats);
         this.populateRoundsPerSec(stats);
         this.populateClipSize(stats);
         this.myDescription.text = this.mData.description;
         this.myBackground.height = BACKGROUND_HEIGHT;
         var buffs:Vector.<ItemBuffObj> = ItemBuffListObj.getBuffs(cDat);
         if(buffs.length > 0)
         {
            this.populateBuffs(buffs);
         }
         else
         {
            this.clearBuffs();
         }
      }
      
      public function get data() : ProductObj
      {
         return this.mData;
      }
      
      private function populateFireType(statsData:WeaponStatsObj) : void
      {
         this.myAttribute0.visible = true;
         this.myAttribute0.myAttributeTitle.text = "@SF_WEAPON_FIRETYPE";
         this.myAttribute0.myAttributeValue.text = statsData.clipsize > 0 ? statsData.firetype : "@SF_UI_NOT_APPLICABLE";
      }
      
      private function populateRoundsPerSec(statsData:WeaponStatsObj) : void
      {
         var baseRPS:Number = statsData.rps;
         var clipSize:int = statsData.clipsize;
         this.myAttribute1.visible = true;
         this.myAttribute1.myAttributeTitle.text = "@SF_WEAPON_FIRERATE";
         if(clipSize > 0)
         {
            this.myAttribute1.myAttributeValue.text = baseRPS.toFixed(2);
            this.myAttribute1.myAttributeValue.font = GlobalGuide.FONT_FACE_NUMBERS;
         }
         else
         {
            this.myAttribute1.myAttributeValue.text = "@SF_UI_NOT_APPLICABLE";
            this.myAttribute1.myAttributeValue.font = GlobalGuide.FONT_FACE_MEDIUM;
         }
      }
      
      private function populateClipSize(statsData:WeaponStatsObj) : void
      {
         var baseClipSize:int = statsData.clipsize;
         this.myAttribute2.visible = true;
         this.myAttribute2.myAttributeTitle.text = "@SF_WEAPON_CLIPSIZE";
         if(baseClipSize > 0)
         {
            this.myAttribute2.myAttributeValue.text = String(baseClipSize);
            this.myAttribute2.myAttributeValue.font = GlobalGuide.FONT_FACE_NUMBERS;
         }
         else
         {
            this.myAttribute2.myAttributeValue.text = "@SF_UI_NOT_APPLICABLE";
            this.myAttribute2.myAttributeValue.font = GlobalGuide.FONT_FACE_MEDIUM;
         }
      }
      
      private function populateBuffs(buffs:Vector.<ItemBuffObj>) : void
      {
         var imgHolder:FsgImageHolder = null;
         var buff:ItemBuffObj = null;
         var textField:TextField = null;
         this.clearBuffs();
         var imgClass:Class = getDefinitionByName("codo.shared.Size32ImageHolder") as Class;
         var len:int = int(buffs.length);
         var i:int = 0;
         for(var curY:Number = 0; i < len; )
         {
            imgHolder = new imgClass() as FsgImageHolder;
            imgHolder.width = imgHolder.height = 40;
            buff = buffs[i];
            imgHolder.setImage(buff.icon);
            imgHolder.y = curY;
            this.myBuffs.addChild(imgHolder);
            textField = GlobalFactory.BUILD_TEXTFIELD();
            textField.width = DESCRIPTION_WIDTH - imgHolder.width;
            textField.textStyle = GlobalGuide.styleTextDescription;
            textField.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
            textField.text = LocalizeUtil.replaceConversionString(LocalizeUtil.localize(buff.desc),[buff.percent]);
            textField.x = imgHolder.x + imgHolder.width;
            textField.y = curY + imgHolder.height / 2 - textField.textHeight / 2 - 3;
            this.myBuffs.addChild(textField);
            curY += imgHolder.height + 14;
            this.myBackground.height += imgHolder.height + 14;
            i++;
         }
         if(len > 0)
         {
            this.myBackground.height += 5;
         }
      }
      
      private function clearBuffs() : void
      {
         while(this.myBuffs.numChildren > 0)
         {
            this.myBuffs.removeChildAt(0);
         }
      }
   }
}


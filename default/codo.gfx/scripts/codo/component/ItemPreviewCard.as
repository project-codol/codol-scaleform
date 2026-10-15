package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.objects.ItemBuffListObj;
   import codo.objects.ItemBuffObj;
   import codo.objects.ProductObj;
   import codo.objects.WeaponStatsObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   
   public class ItemPreviewCard extends MovieClip
   {
      
      public static const STATS_BASIC:Number = 0;
      
      public static const STATS_DUAL_BASE:Number = 1;
      
      public static const STATS_DUAL_CLASH:Number = 2;
      
      private static const ITEM_SET_INFO_SHOW_NONE:Number = 1;
      
      private static const ITEM_SET_INFO_SHOW_ON_LEFT:Number = 2;
      
      private static const ITEM_SET_INFO_SHOW_ON_RIGHT:Number = 3;
      
      private static const CATEGORY_TEXT_MARGIN:Number = 10;
      
      private static const DESCRIPTION_MARGIN:Number = 24;
      
      private static const DESCRIPTION_OFFSET_Y:Number = 8;
      
      private static const DEFAULT_WEAPON_BACKGROUND_HEIGHT:Number = 228;
      
      private static const BACKGROUND_MARGIN:Number = 13;
      
      public var myStatGraph:WeaponStatsGraph;
      
      public var myItemName:TextField;
      
      public var myItemCategory:TextField;
      
      public var myDescription:TextField;
      
      public var myLegendDesc:TextField;
      
      public var myItemWarning:TextField;
      
      public var myItemWarningIcon:Sprite;
      
      public var myTierColorSecondary:Sprite;
      
      public var myTierColor:Sprite;
      
      public var myDescriptionBackground:Sprite;
      
      public var myBuffs:MovieClip;
      
      public var myItemStatsBackground:Sprite;
      
      public var myItemStatsText:TextField;
      
      public var myCATDependencyDesc:TextField;
      
      public var myCATDependencyCuttingLine:Sprite;
      
      public var mySetInfo:ItemPreviewSetInfo;
      
      private var mPreviewItem:ProductObj;
      
      private var mComparisonItem:ProductObj;
      
      private var myUseBaseData:Boolean = true;
      
      private var myStatsState:int = 0;
      
      public function ItemPreviewCard()
      {
         super();
         this.myItemName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myItemName.autoSize = TextFieldAutoSize.LEFT;
         this.myItemCategory.alignment = TextStyle.HALIGN_RIGHT;
         this.myItemCategory.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myItemCategory.fontColor = GlobalGuide.BLACK;
         this.myDescription.width = this.myDescriptionBackground.width - DESCRIPTION_MARGIN;
         this.myDescription.height = this.myDescriptionBackground.height - DESCRIPTION_MARGIN;
         this.myDescription.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myDescription.autoSize = TextFieldAutoSize.LEFT;
         this.myDescription.visible = false;
         this.myLegendDesc.width = this.myDescription.width;
         this.myLegendDesc.height = this.myDescription.height;
         this.myLegendDesc.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLegendDesc.autoSize = TextFieldAutoSize.LEFT;
         this.myLegendDesc.fontColor = 16765440;
         this.myCATDependencyDesc.width = this.myDescription.width;
         this.myCATDependencyDesc.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myCATDependencyDesc.autoSize = TextFieldAutoSize.LEFT;
         this.myCATDependencyDesc.visible = this.myCATDependencyCuttingLine.visible = false;
         this.myItemWarning.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myItemWarning.fontColor = GlobalGuide.CODO_RED;
         this.myItemWarning.text = "";
         this.myItemWarningIcon.visible = false;
         this.myItemWarning.width = this.myItemName.width = this.myDescriptionBackground.width - this.myItemName.x;
         mouseEnabled = mouseChildren = false;
         this.mPreviewItem = null;
         this.mComparisonItem = null;
         this.myItemStatsText.visible = false;
         this.myItemStatsText.alignment = TextStyle.HALIGN_CENTER;
         this.myItemStatsText.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myItemStatsBackground.visible = false;
      }
      
      private function setWeaponPreviewData() : void
      {
         var compareStats:WeaponStatsObj = null;
         if(this.mPreviewItem.type != MarketMenuData.TYPE_WEAPON)
         {
            return;
         }
         var isClashStats:Boolean = this.myStatsState == STATS_DUAL_CLASH;
         if(this.myStatsState != STATS_BASIC)
         {
            this.myItemStatsText.visible = true;
            this.myItemStatsBackground.visible = true;
            this.myItemStatsText.text = isClashStats ? LocalizeUtil.localize(Dict.WEAPON_CLASH_STATS) : LocalizeUtil.localize(Dict.WEAPON_BASIC_STATS);
            this.myItemStatsText.fontColor = isClashStats ? GlobalGuide.GREEN : GlobalGuide.CODO_BLUE_LIGHT;
            this.updateTierAndItemCategoryWidth();
         }
         var stats:WeaponStatsObj = new WeaponStatsObj(this.mPreviewItem,false,isClashStats);
         if(null != this.mComparisonItem && this.mPreviewItem.id != this.mComparisonItem.id && (!isClashStats || this.mComparisonItem.clashProperties != null))
         {
            compareStats = new WeaponStatsObj(this.mComparisonItem,false,isClashStats);
            this.myStatGraph.setData(stats,compareStats,true,true);
         }
         else
         {
            this.myStatGraph.setData(stats,null,this.myUseBaseData,true);
         }
      }
      
      public function setData(data:ProductObj, comparisonItem:ProductObj = null) : void
      {
         var exclusiveEquippedItemName:String = null;
         var legendDescMargin:int = 0;
         var catDependencyOffset:int = 0;
         this.mPreviewItem = data;
         this.mComparisonItem = comparisonItem;
         var itemSetInfo:Object = CFunctionCommonContainer.AS_GetPveSetInfo(this.mPreviewItem.id,this.mPreviewItem.group);
         if(itemSetInfo == null)
         {
            this.mySetInfo.hide();
            gotoAndStop(ITEM_SET_INFO_SHOW_NONE);
         }
         else
         {
            this.mySetInfo.setData(itemSetInfo,this.mPreviewItem);
            this.mySetInfo.show();
            gotoAndStop(comparisonItem == null ? ITEM_SET_INFO_SHOW_ON_RIGHT : ITEM_SET_INFO_SHOW_ON_LEFT);
         }
         this.myItemName.text = this.mPreviewItem.name.toUpperCase();
         if(ScaleformUtil.IsLogItemIDEnabled())
         {
            this.myItemName.text = this.mPreviewItem.id.toString() + ": " + LocalizeUtil.localize(this.myItemName.text);
         }
         this.myItemCategory.text = LocalizeUtil.localize(MarketItemUtil.ITEM_TIER_LABELS[this.mPreviewItem.tier]).toUpperCase() + " " + LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(this.mPreviewItem.group));
         var tierColor:uint = uint(MarketGuide.COLOR_BY_TIER[this.mPreviewItem.tier]);
         GlobalGuide.formatComponentsByTier(tierColor,new <DisplayObject>[this.myTierColor,this.myCATDependencyCuttingLine]);
         this.myItemName.fontColor = tierColor;
         this.myStatsState = STATS_BASIC;
         this.myItemStatsText.visible = false;
         this.myItemStatsBackground.visible = false;
         this.myTierColor.x = this.myTierColorSecondary.x;
         this.updateTierAndItemCategoryWidth();
         if(this.mPreviewItem.type == MarketMenuData.TYPE_WEAPON)
         {
            if(this.mPreviewItem.group == "swd" && this.mPreviewItem.clashProperties != null)
            {
               this.myStatsState = STATS_DUAL_BASE;
            }
            this.setWeaponPreviewData();
            this.myStatGraph.visible = true;
            this.myDescription.visible = false;
            this.myDescriptionBackground.height = DEFAULT_WEAPON_BACKGROUND_HEIGHT;
            this.myItemWarning.text = "";
            this.myItemWarningIcon.visible = false;
            this.myBuffs.y = 260;
         }
         else
         {
            this.myDescription.text = this.mPreviewItem.description;
            this.myStatGraph.visible = false;
            this.myDescription.visible = true;
            this.myDescriptionBackground.height = this.myDescription.textHeight + this.myItemName.textHeight + 20;
            this.myDescription.y = this.myItemName.y + this.myItemName.textHeight + DESCRIPTION_OFFSET_Y;
            exclusiveEquippedItemName = this.mPreviewItem.getExclusiveEquippedItemName();
            if(Boolean(exclusiveEquippedItemName))
            {
               this.myItemWarning.text = LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_EXCLUSIVE_ITEM_WARNING"),[LocalizeUtil.localize(exclusiveEquippedItemName)]);
               this.myItemWarning.y = this.myItemWarningIcon.y = this.myDescription.y + this.myDescription.textHeight + DESCRIPTION_OFFSET_Y;
               this.myItemWarningIcon.visible = true;
               this.myDescriptionBackground.height += this.myItemWarningIcon.height + DESCRIPTION_OFFSET_Y;
            }
            else
            {
               this.myItemWarning.text = "";
               this.myItemWarningIcon.visible = false;
            }
            this.myBuffs.y = this.myDescription.y + this.myDescription.textHeight + 10;
         }
         var buffHeight:Number = this.populateBuffInformation(this.mPreviewItem,this.myBuffs);
         this.myDescriptionBackground.height += buffHeight;
         this.myLegendDesc.visible = this.mPreviewItem.legendDesc != "";
         if(this.myLegendDesc.visible)
         {
            this.myLegendDesc.text = LocalizeUtil.localize(this.mPreviewItem.legendDesc);
            legendDescMargin = 8;
            this.myLegendDesc.y = this.myDescriptionBackground.y + this.myDescriptionBackground.height + legendDescMargin;
            this.myDescriptionBackground.height += this.myLegendDesc.textHeight + legendDescMargin;
         }
         var catDependencyDesc:String = this.getCATDependencyDesc(this.mPreviewItem);
         if(catDependencyDesc != null)
         {
            this.myCATDependencyCuttingLine.visible = true;
            catDependencyOffset = 4;
            this.myCATDependencyCuttingLine.y = this.myDescriptionBackground.height + this.myDescriptionBackground.y + catDependencyOffset;
            this.myCATDependencyDesc.y = this.myCATDependencyCuttingLine.y + this.myCATDependencyCuttingLine.height + catDependencyOffset;
            this.myCATDependencyDesc.text = catDependencyDesc;
            this.myCATDependencyDesc.visible = true;
            this.myDescriptionBackground.height += this.myCATDependencyDesc.textHeight + this.myCATDependencyCuttingLine.height + catDependencyOffset;
         }
         else
         {
            this.myCATDependencyCuttingLine.visible = false;
            this.myCATDependencyDesc.visible = false;
         }
         this.myDescriptionBackground.height += BACKGROUND_MARGIN;
         if(this.myStatsState == STATS_BASIC)
         {
            this.mPreviewItem = null;
            this.mComparisonItem = null;
         }
      }
      
      public function disableData() : void
      {
         this.mySetInfo.hide();
      }
      
      private function populateBuffInformation(item:ProductObj, mc:MovieClip) : Number
      {
         var buffInfo:BuffInformation = null;
         var buff:ItemBuffObj = null;
         var tierColor:uint = 0;
         var mItemBuffs:Vector.<ItemBuffObj> = ItemBuffListObj.getBuffs(item);
         var len:int = int(mItemBuffs.length);
         var curY:Number = 0;
         var imgClass:Class = getDefinitionByName("codo.shared.BuffInformation") as Class;
         for(var i:int = 0; i < len; )
         {
            if(i < mc.numChildren)
            {
               buffInfo = mc.getChildAt(i) as BuffInformation;
            }
            else
            {
               buffInfo = new imgClass() as BuffInformation;
               mc.addChild(buffInfo);
            }
            buff = mItemBuffs[i];
            buffInfo.setData(buff);
            tierColor = uint(MarketGuide.COLOR_BY_TIER[item.tier]);
            buffInfo.setTierColor(tierColor);
            buffInfo.y = curY;
            curY += buffInfo.height + 5;
            i++;
         }
         while(i < mc.numChildren)
         {
            mc.removeChildAt(i);
         }
         return curY;
      }
      
      public function getCATDependencyDesc(item:ProductObj) : String
      {
         var characterNum:int = 0;
         var gender:int = 0;
         var nameList:Array = null;
         var name:String = null;
         var dependencyInfo:Object = CFunctionContainer.AS_GetCharacterAttachmentDependencyInfo(item.id,item.type == ItemType.BUNDLE);
         var desc:String = null;
         if(dependencyInfo != null && dependencyInfo.characterNum > 0)
         {
            characterNum = int(dependencyInfo.characterNum);
            gender = int(dependencyInfo.characterGender);
            nameList = dependencyInfo.characterNames;
            if(characterNum == 1)
            {
               desc = LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_CAT_ITEM_EXCLUSIVE"),[LocalizeUtil.localize(nameList[0]).toUpperCase()]);
            }
            else if(characterNum < 5)
            {
               desc = "";
               for each(name in nameList)
               {
                  if(desc.length > 0)
                  {
                     desc += ",";
                  }
                  desc += LocalizeUtil.localize(name).toUpperCase();
               }
               desc = LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_CAT_ITEM_MULTI_CHARACTERS"),[desc]);
            }
            else
            {
               switch(gender)
               {
                  case 0:
                     desc = LocalizeUtil.localize("@SF_UI_CAT_ITEM_MALE");
                     break;
                  case 1:
                     desc = LocalizeUtil.localize("@SF_UI_CAT_ITEM_FEMALE");
                     break;
                  default:
                     if(characterNum <= 10)
                     {
                        desc = LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_CAT_ITEM_MIXED_SEX"),[LocalizeUtil.localize(nameList[0]).toUpperCase()]);
                     }
                     else
                     {
                        desc = LocalizeUtil.localize("@SF_UI_CAT_ITEM_UNIVERSAL");
                     }
               }
            }
         }
         return desc;
      }
      
      override public function get width() : Number
      {
         return this.myTierColor.width;
      }
      
      override public function get height() : Number
      {
         var h:Number = this.myDescriptionBackground.height + this.myDescriptionBackground.y;
         return this.mySetInfo.visible ? Math.max(h,this.mySetInfo.height) : h;
      }
      
      public function get statsState() : int
      {
         return this.myStatsState;
      }
      
      public function set statsState(newState:int) : void
      {
         if(this.myStatsState == STATS_BASIC)
         {
            return;
         }
         if(newState != this.myStatsState)
         {
            this.myStatsState = newState;
            this.setWeaponPreviewData();
         }
      }
      
      public function set useBaseData(bUse:Boolean) : void
      {
         this.myUseBaseData = bUse;
      }
      
      private function updateTierAndItemCategoryWidth() : void
      {
         this.myTierColor.width = this.myItemStatsBackground.visible ? this.myItemStatsBackground.x - this.myTierColor.x : this.myItemStatsBackground.x - this.myTierColor.x + this.myItemStatsBackground.width;
         this.myItemCategory.width = this.myTierColor.x + this.myTierColor.width - CATEGORY_TEXT_MARGIN - this.myItemCategory.x;
      }
   }
}


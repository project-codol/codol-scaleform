package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.MarketFactory;
   import codo.constants.BCEvent;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class MarketplaceItemPreviewSelector extends UIInteractiveComponent
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 3;
      
      private static const SLIDE_DURATION:Number = 0.2;
      
      private static const DEFAULT_LIST_WIDTH:Number = 240;
      
      private static const DEFAULT_LIST_HEIGHT:Number = 300;
      
      private static const BLUE_HIGHLIGHT_OFFSET_Y:Number = 5;
      
      private static const BLUE_HIGHLIGHT_WIDTH:Number = 54;
      
      private static const BLUE_HIGHLIGHT_HEIGHT:Number = 4;
      
      private static const HIGHLIGHT_SCALE_DURATION:Number = 0.1;
      
      private static const BACKGROUND_GROW_DURATION:Number = 0.2;
      
      private static const LIST_MARGIN_X:Number = 10;
      
      private static const MASK_MARGIN:Number = 20;
      
      private static const HIGHLIGHT_GLOW_OFFSET_X:Number = 22;
      
      private static const HIGHLIGHT_GLOW_OFFSET_Y:Number = 16;
      
      private static const HIGHLIGHT_GLOW_FOCUS_ALPHA:Number = 0.5;
      
      public var myBackground:MovieClip;
      
      public var myClearButton:Button;
      
      public var myItemMount:MovieClip;
      
      public var myListContainer:Sprite;
      
      public var myMask:Sprite;
      
      public var myBlueHighlight:Sprite;
      
      public var myGlow:Sprite;
      
      public var myHighlightGlow:Sprite;
      
      public var myLabel:TextField;
      
      public var myItemCount:TextField;
      
      public var myItemCountBG:Sprite;
      
      public var myListBackground:MovieClip;
      
      public var myArrow:MovieClip;
      
      private var mToggled:Boolean = false;
      
      private var mTextFocusColor:Number = 16777215;
      
      private var mTextUnfocusColor:Number = 16777215;
      
      private var mTextClickColor:Number = 16777215;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mListWidth:Number;
      
      private var mListHeight:Number;
      
      private var mToggleAnimTimeline:TimelineLite;
      
      private var mSlots:Vector.<MarketplaceItemPreviewSelectorOption>;
      
      private var mSlotMapping:Dictionary;
      
      public function MarketplaceItemPreviewSelector()
      {
         super();
         isInteractiveEnabled = true;
         this.initReferences();
         this.initStage();
         if(ScaleformUtil.isScaleform)
         {
            EventManager.getInstance().listen(BCEvent.EVT_MARKET_UPDATE_PREVIEW_LIST,this.updateList);
         }
      }
      
      private static function onItemUnchecked(item:MarketplaceItemPreviewSelectorOption) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_PREVIEW_REMOVE,{"item":item.getData()});
         item.setEmpty();
      }
      
      private static function onItemClicked(item:MarketplaceItemPreviewSelectorOption) : void
      {
         if(!item.getData().isInBundle)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_SHOW_DETAILS,{"itemData":item.getData()});
         }
      }
      
      private function initReferences() : void
      {
         this.myItemMount = this.myListContainer["myItemMount"];
         this.myListBackground = this.myListContainer["myListBackground"];
         this.myClearButton = this.myListContainer["myClearButton"];
         this.myGlow = this.myListContainer["myGlow"];
      }
      
      private function initStage() : void
      {
         this.myListBackground.alpha = 0;
         this.myListBackground.height = 10;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.fontColor = this.mTextUnfocusColor;
         this.myLabel.text = LocalizeUtil.localize(DictMarket.CONTROLS_PREVIEW_LABEL);
         this.myItemCount.textStyle = MarketGuide.marketItemPreviewCount;
         this.myItemCount.myTextClip.autoSize = TextFieldAutoSize.NONE;
         this.myItemCount.width = this.myItemCount.height = 24;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myItemCount.text = "";
         this.myItemCountBG.visible = false;
         this.myBlueHighlight.width = 0;
         this.myItemMount.alpha = 0;
         this.myGlow.alpha = 0;
         this.myHighlightGlow.alpha = 0;
         this.myClearButton.alpha = 0;
         this.hideListBackground();
         this.mListWidth = DEFAULT_LIST_WIDTH;
         this.mListHeight = DEFAULT_LIST_HEIGHT;
         this.width = myHitArea.width;
         this.height = myHitArea.height;
         this.myClearButton.label = LocalizeUtil.localize(Dict.REMOVE);
         this.myClearButton.setClickCallback(this.clearPreviewList);
         this.enabled = false;
         this.buildList();
      }
      
      private function buildList() : void
      {
         var slot:MarketplaceItemPreviewSelectorOption = null;
         while(this.myItemMount.numChildren > 0)
         {
            this.myItemMount.removeChildAt(0);
         }
         this.mSlots = new Vector.<MarketplaceItemPreviewSelectorOption>();
         this.mListHeight = 0;
         this.mSlotMapping = new Dictionary();
         var curY:Number = 0;
         var i:uint = 0;
         var globalCategoryMapRef:Vector.<String> = MarketMenuData.PREVIEWABLE_ITEM_CATEGORY_MAPPING;
         for(var len:uint = globalCategoryMapRef.length; i < len; )
         {
            slot = this.addSlot();
            slot.itemImage = MarketFactory.GET_ITEM_CATEGORY_ICON_BY_TYPE(globalCategoryMapRef[i]);
            slot.setEmpty();
            slot.y = curY;
            curY = this.mListHeight = this.mListHeight + (slot.height + GlobalGuide.COMPONENT_PADDING);
            this.mSlotMapping[globalCategoryMapRef[i]] = slot;
            this.mSlots.push(slot);
            i++;
         }
         this.mListHeight += GlobalGuide.COMPONENT_PADDING;
         this.draw();
      }
      
      private function updateList(e:ParaEvent) : void
      {
         var slot:MarketplaceItemPreviewSelectorOption = null;
         var itemData:ProductObj = null;
         var j:int = 0;
         var itemObj:Object = null;
         var data:Array = e.myPara;
         if(data.length <= 0)
         {
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
            this.myArrow.gotoAndStop(UP_STATE_FRAME);
            this.myLabel.fontColor = this.mTextUnfocusColor;
            this.enabled = false;
            return;
         }
         this.enabled = true;
         this.emptyListItems();
         var len:int = int(data.length);
         var previewItemCount:int = 0;
         for(var i:int = 0; i < len; i++)
         {
            itemData = new ProductObj(data[i]);
            if(itemData.type == ItemType.WEAPON)
            {
               slot = this.mSlotMapping[itemData.type];
               if(Boolean(slot))
               {
                  slot.setData(itemData);
                  previewItemCount += 1;
               }
            }
            else if(itemData.group == MarketMenuData.GRP_OUTFIT)
            {
               for(j = 0; j < itemData.itemsList.length; j++)
               {
                  itemObj = itemData.itemsList[j];
                  slot = this.mSlotMapping[itemObj.group];
                  if(Boolean(slot))
                  {
                     slot.setData(itemData);
                     previewItemCount += 1;
                  }
               }
            }
            else
            {
               slot = this.mSlotMapping[itemData.group];
               if(Boolean(slot))
               {
                  slot.setData(itemData);
                  previewItemCount += 1;
               }
            }
         }
         if(previewItemCount > 0)
         {
            this.myItemCount.text = previewItemCount.toString();
            this.myItemCountBG.visible = true;
         }
         else
         {
            this.myItemCount.text = "";
            this.myItemCountBG.visible = false;
         }
      }
      
      private function addSlot() : MarketplaceItemPreviewSelectorOption
      {
         var slotClass:Class = getDefinitionByName("codo.shared.marketplaceItemPreviewSelectorOption") as Class;
         var slotClip:MarketplaceItemPreviewSelectorOption = new slotClass() as MarketplaceItemPreviewSelectorOption;
         slotClip.registerOnRemoveClickedCallback(onItemUnchecked);
         slotClip.registerClickUpEvent(onItemClicked,slotClip);
         slotClip.width = this.mListWidth;
         this.myItemMount.addChild(slotClip);
         return slotClip;
      }
      
      private function emptyListItems() : void
      {
         var slotClip:MarketplaceItemPreviewSelectorOption = null;
         var len:int = int(this.mSlots.length);
         for(var i:int = 0; i < len; i++)
         {
            slotClip = this.mSlots[i];
            slotClip.setEmpty();
         }
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         if(true == enabled)
         {
            this.myBackground.gotoAndStop(OVER_STATE_FRAME);
         }
         else
         {
            this.myItemCount.text = "";
            this.myItemCountBG.visible = false;
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
            this.toggled = false;
         }
         super.enabled = enabled;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      public function get toggled() : Boolean
      {
         return this.mToggled;
      }
      
      public function set toggled(toggled:Boolean) : void
      {
         if(this.mToggled == toggled)
         {
            return;
         }
         this.mToggled = toggled;
         if(null == this.mToggleAnimTimeline)
         {
            this.mToggleAnimTimeline = new TimelineLite();
         }
         else
         {
            this.mToggleAnimTimeline.killTweensOf(this.myItemMount);
            this.mToggleAnimTimeline.killTweensOf(this.myListBackground);
            this.mToggleAnimTimeline.killTweensOf(this.myBlueHighlight);
            this.mToggleAnimTimeline.killTweensOf(this.myGlow);
            this.mToggleAnimTimeline.killTweensOf(this.myHighlightGlow);
            this.mToggleAnimTimeline = new TimelineLite();
         }
         if(true == this.mToggled)
         {
            this.myItemMount.visible = true;
            this.myListContainer.visible = true;
            this.myGlow.visible = true;
            this.mToggleAnimTimeline.append(new TweenLite(this.myBlueHighlight,HIGHLIGHT_SCALE_DURATION,{"width":BLUE_HIGHLIGHT_WIDTH}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myHighlightGlow,SLIDE_DURATION,{"alpha":HIGHLIGHT_GLOW_FOCUS_ALPHA}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myListBackground,BACKGROUND_GROW_DURATION,{
               "height":this.mListHeight,
               "alpha":1
            }));
            this.mToggleAnimTimeline.append(new TweenLite(this.myItemMount,SLIDE_DURATION,{"alpha":1}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myClearButton,SLIDE_DURATION,{"alpha":1}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myGlow,SLIDE_DURATION,{"alpha":1}));
            stage.addEventListener(MouseEvent.CLICK,this.onStageClickHandle);
         }
         else
         {
            this.mToggleAnimTimeline.append(new TweenLite(this.myClearButton,SLIDE_DURATION,{"alpha":0}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myGlow,SLIDE_DURATION,{"alpha":0}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myItemMount,SLIDE_DURATION,{"alpha":0}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myListBackground,BACKGROUND_GROW_DURATION,{
               "height":10,
               "alpha":0
            }));
            this.mToggleAnimTimeline.append(new TweenLite(this.myHighlightGlow,SLIDE_DURATION,{"alpha":0}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myBlueHighlight,HIGHLIGHT_SCALE_DURATION,{
               "width":0,
               "onComplete":this.hideListBackground
            }));
            if(this.stage != null)
            {
               stage.removeEventListener(MouseEvent.CLICK,this.onStageClickHandle);
            }
         }
         this.mToggleAnimTimeline.play();
      }
      
      private function onStageClickHandle(cEvt:MouseEvent) : void
      {
         if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY) == false)
         {
            this.toggled = false;
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
            this.myArrow.gotoAndStop(UP_STATE_FRAME);
            this.myLabel.fontColor = this.mTextUnfocusColor;
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(false == this.mToggled)
         {
            this.myBackground.gotoAndStop(OVER_STATE_FRAME);
            this.myArrow.gotoAndStop(OVER_STATE_FRAME);
            this.myLabel.fontColor = this.mTextFocusColor;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(false == this.mToggled)
         {
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
            this.myArrow.gotoAndStop(UP_STATE_FRAME);
            this.myLabel.fontColor = this.mTextUnfocusColor;
         }
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         this.myBackground.gotoAndStop(DOWN_STATE_FRAME);
         this.myArrow.gotoAndStop(DOWN_STATE_FRAME);
         this.myLabel.fontColor = this.mTextClickColor;
         this.toggled = !this.mToggled;
      }
      
      override protected function onMouseClickUp() : void
      {
         if(false == this.mToggled)
         {
            if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY) == false)
            {
               this.myBackground.gotoAndStop(UP_STATE_FRAME);
               this.myArrow.gotoAndStop(UP_STATE_FRAME);
               this.myLabel.fontColor = this.mTextUnfocusColor;
            }
            else
            {
               this.myArrow.gotoAndStop(OVER_STATE_FRAME);
               this.myBackground.gotoAndStop(OVER_STATE_FRAME);
               this.myLabel.fontColor = this.mTextFocusColor;
            }
         }
      }
      
      private function draw() : void
      {
         var halfWidth:Number = this.mWidth * 0.5;
         this.myBlueHighlight.x = halfWidth - BLUE_HIGHLIGHT_WIDTH * 0.5;
         this.myBlueHighlight.y = this.mHeight + BLUE_HIGHLIGHT_OFFSET_Y;
         this.myListBackground.width = this.mListWidth + MASK_MARGIN;
         this.myListBackground.height = this.mListHeight;
         this.myListContainer.x = halfWidth - (this.mListWidth + MASK_MARGIN) * 0.5;
         this.myListContainer.y = this.myBlueHighlight.y + BLUE_HIGHLIGHT_HEIGHT;
         myHitArea.width = this.mWidth;
         myHitArea.height = this.mHeight;
         this.myLabel.width = this.mWidth - this.myArrow.width;
         this.myLabel.height = this.mHeight;
         this.myArrow.y = this.mHeight * 0.5 - this.myArrow.height * 0.5;
         this.myBackground.width = this.mWidth;
         this.myBackground.height = this.mHeight;
         this.myHighlightGlow.x = this.myBlueHighlight.x - HIGHLIGHT_GLOW_OFFSET_X;
         this.myHighlightGlow.y = this.myBlueHighlight.y - HIGHLIGHT_GLOW_OFFSET_Y;
         this.myMask.width = this.myListContainer.width;
         this.myMask.height = this.mListHeight + MASK_MARGIN + this.myClearButton.height;
         this.myMask.x = this.myListContainer.x;
         this.myMask.y = this.mHeight;
         this.myItemMount.x = this.myListBackground.x + LIST_MARGIN_X;
         this.myItemMount.y = this.myListBackground.y + MASK_MARGIN * 0.5;
         this.myGlow.width = this.myListBackground.width;
         this.myGlow.x = this.myListBackground.x;
         this.myGlow.y = this.myListBackground.y;
         this.myClearButton.x = this.myListBackground.x;
         this.myClearButton.y = this.myListBackground.y + this.mListHeight;
         this.myClearButton.width = this.mListWidth + MASK_MARGIN;
      }
      
      public function clearPreviewList() : void
      {
         this.emptyListItems();
         this.myBackground.gotoAndStop(UP_STATE_FRAME);
         this.myArrow.gotoAndStop(UP_STATE_FRAME);
         this.myLabel.fontColor = this.mTextUnfocusColor;
         EventManager.getInstance().broadcast(BCEvent.EVT_PREVIEW_REMOVE_ALL);
      }
      
      private function hideListBackground() : void
      {
         this.myListContainer.visible = false;
         this.myGlow.visible = false;
      }
   }
}


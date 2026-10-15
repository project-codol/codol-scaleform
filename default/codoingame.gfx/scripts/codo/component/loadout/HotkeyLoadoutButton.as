package codo.component.loadout
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.objects.ItemBuffListObj;
   import codo.objects.ItemBuffObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.style.TextStyle;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class HotkeyLoadoutButton extends Button
   {
      
      private static const BUFF_ICON_SIZE:int = 32;
      
      protected static const EMPTY_FRAME:int = 4;
      
      public var myTierColorBar:Sprite;
      
      public var myTierColorBarCap:Sprite;
      
      public var myHotKeyBG:Sprite;
      
      public var myBuffs:MovieClip;
      
      public var myImage:FsgImageHolder;
      
      public var myHotkey:TextField;
      
      public var myItemName:TextField;
      
      public var myEmptyIcon:MovieClip;
      
      protected var mEmpty:Boolean = false;
      
      private var _group:String;
      
      private var _slotID:String;
      
      private var _keycode:uint;
      
      public function HotkeyLoadoutButton()
      {
         super();
         mTextFocusColor = GlobalGuide.WHITE;
         this.myTierColorBar.visible = false;
         this.myTierColorBarCap.visible = false;
         this.myItemName.visible = false;
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         this.myItemName.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemName.fontColor = GlobalGuide.BLACK;
         this.myHotkey.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myHotkey.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHotkey.alignment = TextStyle.HALIGN_CENTER;
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         myLabel.alignmentVertical = TextStyle.VALIGN_TOP;
      }
      
      public function setGroup(group:String, loc:String, slotID:String = "") : void
      {
         this._group = group;
         this._slotID = slotID;
         if(null != this.myEmptyIcon)
         {
            this.myEmptyIcon.gotoAndStop(group);
         }
         label = loc;
      }
      
      public function get group() : String
      {
         return this._group;
      }
      
      public function get slotID() : String
      {
         return this._slotID;
      }
      
      public function setHotkey(hotkey:uint) : void
      {
         this._keycode = hotkey;
         this.myHotkey.text = String.fromCharCode(hotkey);
      }
      
      public function getHotkey() : uint
      {
         return this._keycode;
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(mToggled)
         {
            myBackground.gotoAndStop(DOWN_STATE_FRAME);
         }
         else if(!mToggled && this.mEmpty)
         {
            myBackground.gotoAndStop(EMPTY_FRAME);
         }
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         if(this.mEmpty)
         {
            myBackground.gotoAndStop(EMPTY_FRAME);
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         myBackground.gotoAndStop(this.mEmpty ? EMPTY_FRAME : UP_STATE_FRAME);
      }
      
      override public function setData(data:*) : void
      {
         var prodData:ProductObj = null;
         var isEmpty:Boolean = false;
         var buffs:Vector.<ItemBuffObj> = null;
         var imgClass:Class = null;
         var imgHolder:FsgImageHolder = null;
         var idx:int = 0;
         var buff:ItemBuffObj = null;
         super.setData(data);
         prodData = new ProductObj(data);
         isEmpty = prodData.name.length == 0;
         this.myTierColorBar.visible = !isEmpty;
         this.myTierColorBarCap.visible = !isEmpty;
         this.myItemName.visible = !isEmpty;
         this.mEmpty = isEmpty;
         myBackground.gotoAndStop(this.mEmpty ? EMPTY_FRAME : UP_STATE_FRAME);
         if(null != this.myEmptyIcon)
         {
            this.myEmptyIcon.visible = this.mEmpty;
         }
         this.myItemName.text = prodData.name;
         this.myImage.setImage(prodData.imageURL);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[prodData.tier],new <DisplayObject>[this.myTierColorBar]);
         var barWidth:Number = this.myItemName.x + this.myItemName.textWidth + this.myTierColorBarCap.width + GlobalGuide.COMPONENT_PADDING;
         this.myTierColorBar.width = Math.min(barWidth,myBackground.width - 4);
         this.myTierColorBarCap.x = this.myTierColorBar.x + this.myTierColorBar.width - this.myTierColorBarCap.width;
         if(Boolean(this.myBuffs))
         {
            this.clearBuffs();
            buffs = ItemBuffListObj.getBuffs(prodData);
            imgClass = getDefinitionByName("codo.shared.Size32ImageHolder") as Class;
            for(idx = 0; idx < buffs.length; idx++)
            {
               imgHolder = new imgClass() as FsgImageHolder;
               imgHolder.width = imgHolder.height = BUFF_ICON_SIZE;
               imgHolder.x = -(this.myBuffs.numChildren * (imgHolder.width - 8));
               this.myBuffs.addChild(imgHolder);
               buff = buffs[idx];
               imgHolder.setImage(buff.icon);
            }
         }
      }
      
      override public function draw() : void
      {
         super.draw();
         myHitArea.width = myBackground.width = mWidth;
         myHitArea.height = myBackground.height = mHeight;
         var aspectSize:int = (mHeight > mWidth ? mHeight : mWidth) - 40;
         this.myImage.width = aspectSize;
         this.myImage.height = aspectSize;
         var halfWidth:Number = mWidth * 0.5;
         var halfHeight:Number = mHeight * 0.5;
         this.myImage.x = halfWidth - this.myImage.width * 0.5;
         this.myImage.y = halfHeight - this.myImage.height * 0.5;
         this.myTierColorBar.y = mHeight - this.myTierColorBar.height - 15;
         this.myTierColorBarCap.y = this.myTierColorBar.y;
         this.myItemName.y = this.myTierColorBar.y + 2;
         this.myItemName.width = mWidth - this.myItemName.x;
         this.positionHotkey();
      }
      
      protected function positionHotkey() : void
      {
         this.myHotKeyBG.x = myHitArea.width - this.myHotKeyBG.width - 8;
         this.myHotkey.x = this.myHotKeyBG.x + this.myHotKeyBG.width * 0.5 - this.myHotkey.textWidth * 0.5 - 11;
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


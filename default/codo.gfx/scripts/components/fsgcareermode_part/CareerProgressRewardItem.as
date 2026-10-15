package components.fsgcareermode_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.ItemType;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   import fsg.util.ImageHolderSimple;
   
   public class CareerProgressRewardItem extends UIInteractiveComponent
   {
      
      public var myRewardCardTitle:Sprite;
      
      public var myTierColor:Sprite;
      
      public var myImageHolder:ImageHolderSimple;
      
      public var myRewardNameTF:TextField;
      
      public var myPrestigeIcon:FsgImageHolder;
      
      public var myRewardUnlockLevel:TextField;
      
      public var myNextUnlockLevel:TextField;
      
      public function CareerProgressRewardItem()
      {
         super();
         mClickable = new BehaviourClickable(myHitArea);
      }
      
      override public function get width() : Number
      {
         return 220;
      }
      
      override public function get height() : Number
      {
         return 206;
      }
      
      protected function onImageLoaded(e:Event) : void
      {
         this.myImageHolder.removeEventListener(Event.COMPLETE,this.onImageLoaded);
         var IMAGE_HOLDER_WIDTH:int = 220;
         var IMAGE_HOLDER_HEIGHT:int = 180;
         var itemScale:Number = 1;
         if(this.myImageHolder.width > IMAGE_HOLDER_WIDTH)
         {
            itemScale = 0.55;
         }
         this.myImageHolder.scaleX = this.myImageHolder.scaleY = itemScale;
         this.myImageHolder.x = (IMAGE_HOLDER_WIDTH - this.myImageHolder.width) * 0.5;
         this.myImageHolder.y = (IMAGE_HOLDER_HEIGHT - this.myImageHolder.height) * 0.5;
      }
      
      override public function setData(data:*) : void
      {
         var itemData:ProductObj = null;
         var cardTitle:TextField = null;
         super.setData(data);
         if(data == null)
         {
            return;
         }
         itemData = data;
         this.myRewardUnlockLevel.autoSize = TextFieldAutoSize.LEFT;
         this.myImageHolder.addEventListener(Event.COMPLETE,this.onImageLoaded);
         if(itemData.type == ItemType.PCT)
         {
            cardTitle = this.myRewardCardTitle.getChildAt(1) as TextField;
            this.myRewardNameTF.text = itemData.name;
            this.myImageHolder.setImage("");
            this.myRewardCardTitle.visible = true;
            cardTitle.text = itemData.name;
         }
         else
         {
            this.myRewardNameTF.text = itemData.name;
            this.myImageHolder.setImage(itemData.imageURL);
            this.myRewardCardTitle.visible = false;
         }
         if(itemData.type == ItemType.PCB)
         {
            this.myImageHolder.scaleX = this.myImageHolder.scaleY = 0.68;
            this.myImageHolder.x = 2;
            this.myImageHolder.y = 46;
         }
         else
         {
            this.myImageHolder.scaleX = this.myImageHolder.scaleY = 1;
            this.myImageHolder.x = -47;
            this.myImageHolder.y = 36;
         }
         if(itemData.prestigeLevel == 0)
         {
            this.myPrestigeIcon.visible = false;
            this.myRewardUnlockLevel.x = 7;
         }
         else
         {
            this.myPrestigeIcon.visible = true;
            this.myPrestigeIcon.setImage(FsgUtil.getPrestigeIcon(itemData.prestigeLevel));
            this.myRewardUnlockLevel.x = this.myPrestigeIcon.x + this.myPrestigeIcon.width - 4;
         }
         this.myRewardUnlockLevel.text = itemData.unlockLevel > 0 ? LocalizeUtil.param("@SF_UI_CAREER_LEVEL_REWARD",[itemData.unlockLevel]) : "";
         var unlockID:int = itemData.id;
         var item:ProductObj = CFunctionCommonContainer.GetItemInfo(unlockID);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[item.tier],new <DisplayObject>[this.myTierColor]);
      }
   }
}


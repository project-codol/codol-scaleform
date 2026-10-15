package codo.component
{
   import codo.constants.ItemType;
   import codo.objects.ItemBanObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class RestrictionOption extends Button
   {
      
      public var myImage:FsgImageHolder;
      
      public var myImageContainer:MovieClip;
      
      public var myBannedIcon:Sprite;
      
      public var myLabelBG:Sprite;
      
      public var myFocusOverlay:Sprite;
      
      public function RestrictionOption()
      {
         super();
         if(null == this.myBannedIcon)
         {
            isInteractiveEnabled = false;
         }
         this.myImage = this.myImageContainer["myImage"];
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         myLabel.alignmentVertical = TextStyle.VALIGN_BOTTOM;
         mTextFocusColor = GlobalGuide.WHITE;
         mTextClickColor = GlobalGuide.WHITE;
         mWidth = 191;
         mHeight = 133;
         this.draw();
         this.myFocusOverlay.visible = false;
         if(this.myBannedIcon != null)
         {
            this.myBannedIcon.visible = false;
         }
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(mData == null)
         {
            return;
         }
         var itemBanData:ItemBanObj = mData as ItemBanObj;
         if(itemBanData.imageURL != null)
         {
            this.myImage.setImage(itemBanData.imageURL);
         }
         if(itemBanData.name != null)
         {
            this.label = itemBanData.name;
         }
         if(this.myBannedIcon != null)
         {
            this.myBannedIcon.visible = itemBanData.banned;
         }
         switch(itemBanData.type)
         {
            case ItemType.WEAPON:
            case ItemType.PER:
               this.myImageContainer.gotoAndStop(2);
               break;
            case ItemType.KIS:
               this.myImageContainer.gotoAndStop(3);
               break;
            case ItemType.ITM:
               this.myImageContainer.gotoAndStop(4);
               break;
            default:
               this.myImageContainer.gotoAndStop(1);
         }
         resetCallback();
         if(itemBanData.toggleBannedCallback != null)
         {
            registerClickEvent(itemBanData.toggleBannedCallback,{
               "id":itemBanData.id,
               "banned":!itemBanData.banned
            });
         }
      }
      
      override public function draw() : void
      {
         super.draw();
         myLabel.width = mWidth - 20;
         myLabel.height = mHeight - 11;
         myLabel.x = 10;
         myLabel.y = 10;
      }
      
      override public function get width() : Number
      {
         return mWidth;
      }
      
      override public function set width(w:Number) : void
      {
      }
      
      override public function set height(h:Number) : void
      {
      }
      
      override public function get height() : Number
      {
         return mHeight;
      }
      
      override public function set label(label:String) : void
      {
         super.label = label;
         this.myLabelBG.width = myLabel.textWidth + 20;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myFocusOverlay.visible = true;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myFocusOverlay.visible = false;
      }
   }
}


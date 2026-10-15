package codo.component
{
   import codo.objects.ScrollListHeaderRestrictionObj;
   import codo.utils.LocalizeUtil;
   
   public class RestrictionOptionListHeader extends ListHeaderToggle
   {
      
      public var myBanAllButton:Button;
      
      public function RestrictionOptionListHeader()
      {
         super();
         this.myBanAllButton.height = 24;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var headerData:ScrollListHeaderRestrictionObj = mData as ScrollListHeaderRestrictionObj;
         if(headerData.toggleBannedCallback != null)
         {
            this.myBanAllButton.resetCallback();
            this.myBanAllButton.registerClickEvent(headerData.toggleBannedCallback,headerData);
            this.myBanAllButton.label = headerData.numBanned < headerData.count ? "@SF_UI_BAN_ALL" : "@SF_UI_UNBAN_ALL";
         }
         myCount.text = LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_ITEM_BAN_COUNT"),[headerData.numBanned]);
      }
      
      override public function set width(w:Number) : void
      {
         var btnOffset:Number = NaN;
         super.width = w;
         btnOffset = this.myBanAllButton.width + 5;
         this.myBanAllButton.x = myBackground.width - btnOffset;
         myCount.width -= btnOffset;
      }
   }
}


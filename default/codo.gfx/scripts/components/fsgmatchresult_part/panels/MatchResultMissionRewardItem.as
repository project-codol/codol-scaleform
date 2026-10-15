package components.fsgmatchresult_part.panels
{
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.UnlockItemObj;
   import codo.utils.StringUtil;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class MatchResultMissionRewardItem extends UIInteractiveComponent
   {
      
      public var myTitleTF:TextField;
      
      public var myDescTF:TextField;
      
      public var myQuantityTF:TextField;
      
      public var myIconImage:FsgImageHolder;
      
      public function MatchResultMissionRewardItem()
      {
         super();
         this.myDescTF.wordWrap = true;
      }
      
      override public function setData(data:*) : void
      {
         var showQty:Boolean = false;
         super.setData(data);
         if(data == null)
         {
            visible = false;
            return;
         }
         var itemData:UnlockItemObj = data as UnlockItemObj;
         showQty = data.quantity > 1;
         this.myTitleTF.text = itemData.name;
         this.myDescTF.text = itemData.description;
         this.myIconImage.setImage(itemData.imageURL);
         this.myQuantityTF.visible = showQty;
         if(showQty)
         {
            this.myQuantityTF.text = StringUtil.addZero(data.quantity.toString());
         }
      }
   }
}


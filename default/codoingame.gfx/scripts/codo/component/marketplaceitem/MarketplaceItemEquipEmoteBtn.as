package codo.component.marketplaceitem
{
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MarketplaceItemEquipEmoteBtn extends MovieClip
   {
      
      public var myKey:TextField;
      
      public var myHitArea:MovieClip;
      
      private var mIndex:int;
      
      private var mItem:ProductObj;
      
      public function MarketplaceItemEquipEmoteBtn()
      {
         super();
         gotoAndStop(1);
      }
      
      public function set index(index:int) : void
      {
         this.mIndex = index;
         switch(index)
         {
            case 0:
               this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+forward");
               break;
            case 1:
               this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+moveleft");
               break;
            case 2:
               this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+back");
               break;
            case 3:
               this.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+moveright");
               break;
            default:
               this.myKey.text = "";
         }
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
      
      public function setData(item:ProductObj) : void
      {
         this.mItem = item;
      }
      
      public function getData() : ProductObj
      {
         return this.mItem;
      }
      
      public function onMouseOver() : void
      {
         gotoAndStop(2);
         this.myKey.visible = false;
      }
      
      public function onMouseOut() : void
      {
         gotoAndStop(1);
         this.myKey.visible = true;
      }
   }
}


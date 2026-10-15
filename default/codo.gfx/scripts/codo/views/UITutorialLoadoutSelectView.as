package codo.views
{
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.UITutorialFlags;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.utils.ScaleformUtil;
   import codo.views.uitour.UITourLoadoutSelectNewUserEquipNewPrimarySecondary;
   import codo.views.uitour.UITourLoadoutSelectPick10EquipItems;
   import flash.geom.Point;
   
   public class UITutorialLoadoutSelectView extends UITutorialBaseView
   {
      
      public var myNewUserEquipPrimarySecondaryWeapon:UITourLoadoutSelectNewUserEquipNewPrimarySecondary;
      
      public var myPick10EquipItems:UITourLoadoutSelectPick10EquipItems;
      
      private var mInventoryTips:Vector.<UITourToolTipObj>;
      
      public function UITutorialLoadoutSelectView()
      {
         super();
         this.mInventoryTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_SELECT_WEAPON_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_SELECT_WEAPON_DESC",new Point(613,310),true,null,null,null,UITourToolTip.STYLE_0_BTN,UITourToolTip.ARROW_LEFT)];
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(!ScaleformUtil.isScaleform)
         {
            this.myPick10EquipItems.showSlot2();
         }
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_LOADOUT_SELECT_PICK10_EQUIP_PERK1_VIEWED:
               this.myNewUserEquipPrimarySecondaryWeapon.setToPrimary(false);
               break;
            case UITutorialFlags.UI_TOUR_LOADOUT_SELECT_PICK10_EQUIP_WILDCARD_VIEWED:
               this.myNewUserEquipPrimarySecondaryWeapon.setWildCardSlot();
               break;
            case UITutorialFlags.UI_TOUR_LOADOUT_SELECT_PICK10_EQUIP_PERK1_SLOT2_VIEWED:
               this.myPick10EquipItems.showSlot2();
         }
      }
      
      override protected function getToolTips() : Vector.<UITourToolTipObj>
      {
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_INVENTORY_SELECT_WEAPON:
               return this.mInventoryTips;
            default:
               return super.getToolTips();
         }
      }
   }
}


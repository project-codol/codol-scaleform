package codo.views.option_sub
{
   import codo.event.ComboBoxItemEvent;
   import codo.localization.Dict;
   import codo.objects.ToolTipObject;
   import codo.objects.VideoObj;
   import codo.utils.LocalizeUtil;
   import fsg.shared.ComboBox;
   import fsg.shared.ComboBoxItem;
   
   public class FsgOptionVideoBase extends FsgOptionPanel
   {
      
      public function FsgOptionVideoBase()
      {
         super();
      }
      
      override public function active() : void
      {
         super.active();
         addEventListener(ComboBoxItemEvent.ITEM_DISABLED_ONFOCUS,this.handleDisabledComboBoxItemSelect);
         addEventListener(ComboBoxItemEvent.ITEM_DISABLED_ONUNFOCUS,this.handleDisabledComboBoxItemSelect);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         removeEventListener(ComboBoxItemEvent.ITEM_DISABLED_ONFOCUS,this.handleDisabledComboBoxItemSelect);
         removeEventListener(ComboBoxItemEvent.ITEM_DISABLED_ONUNFOCUS,this.handleDisabledComboBoxItemSelect);
      }
      
      public function RefreshSettings(settings:VideoObj) : void
      {
      }
      
      public function ApplySettings(settingsToUpdate:VideoObj, isCurrentTab:Boolean) : void
      {
      }
      
      private function handleDisabledComboBoxItemSelect(comboBoxItemEvent:ComboBoxItemEvent) : void
      {
         var TIP_WIDTH:uint = 0;
         var item:ComboBoxItem = null;
         var targetComboBox:ComboBox = null;
         var config:ToolTipObject = null;
         var contents:String = null;
         var itemFocused:Boolean = comboBoxItemEvent.itemHasFocus;
         if(itemFocused)
         {
            TIP_WIDTH = 200;
            item = comboBoxItemEvent.target as ComboBoxItem;
            targetComboBox = item.parent.parent.parent as ComboBox;
            config = item.returnToolTipConfig();
            contents = LocalizeUtil.getLocalizationWithToken(Dict.WIDGET_COMBO_BOX_ITEM_DISABLED,comboBoxItemEvent.itemLabel,targetComboBox.label).concat("  ",LocalizeUtil.localize(targetComboBox.disabledItemMsg));
            config.contents = contents;
            config.setWidth = TIP_WIDTH;
            TIP_VIEW.displayGlobalToolTip(config);
         }
         else
         {
            TIP_VIEW.hideGlobalToolTip();
         }
      }
   }
}


package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.loadout.*;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class EmoteSettings extends MovieClip
   {
      
      public var myName1:flash.text.TextField;
      
      public var myName2:flash.text.TextField;
      
      public var myName3:flash.text.TextField;
      
      public var myName4:flash.text.TextField;
      
      public var myKey1:EmoteSettingKey;
      
      public var myKey2:EmoteSettingKey;
      
      public var myKey3:EmoteSettingKey;
      
      public var myKey4:EmoteSettingKey;
      
      public var myChooseHint:flash.text.TextField;
      
      private var mKeys:Vector.<EmoteSettingKey>;
      
      private var mNames:Vector.<flash.text.TextField>;
      
      public function EmoteSettings()
      {
         var i:int = 0;
         super();
         this.mKeys = new <EmoteSettingKey>[this.myKey1,this.myKey2,this.myKey3,this.myKey4];
         this.mNames = new <flash.text.TextField>[this.myName1,this.myName2,this.myName3,this.myName4];
         for(i = 0; i < this.mKeys.length; i++)
         {
            this.mKeys[i].index = i;
         }
         this.myChooseHint.text = Dict.CHOOSE_AN_EMOTE;
         this.chooseHintVisibility = false;
         this.updateEmoteSetting();
      }
      
      public function set forceHideTakeoffButton(forceHideTakeoffButton:Boolean) : void
      {
         var i:int = 0;
         for(i = 0; i < this.mKeys.length; i++)
         {
            this.mKeys[i].forceHideTakeoffButton = forceHideTakeoffButton;
         }
      }
      
      public function set chooseHintVisibility(visible:Boolean) : void
      {
         this.myChooseHint.visible = visible;
      }
      
      public function updateEmoteSetting() : void
      {
         var emote:int = 0;
         var productObj:ProductObj = null;
         for(var i:int = 0; i < this.mKeys.length; i++)
         {
            emote = CFunctionCommonContainer.AS_GetEquippedEmote(i);
            if(emote == 0)
            {
               this.mKeys[i].state = EmoteSettingKey.STATE_UNEQUIPPED;
               this.mNames[i].text = DictMarket.NOT_SET;
               this.mNames[i].alpha = 0.6;
            }
            else
            {
               productObj = CFunctionCommonContainer.GetItemInfo(emote);
               this.mKeys[i].state = EmoteSettingKey.STATE_EQUIPPED;
               this.mNames[i].text = productObj.name;
               this.mNames[i].alpha = 1;
            }
         }
      }
      
      public function selectEmote(index:int) : void
      {
         var emote:int = CFunctionCommonContainer.AS_GetEquippedEmote(index);
         if(emote == 0)
         {
            return;
         }
         this.chooseHintVisibility = false;
         for(var i:int = 0; i < this.mKeys.length; i++)
         {
            if(i == index)
            {
               this.mKeys[i].state = EmoteSettingKey.STATE_SELECTED;
               this.mNames[i].alpha = 1;
            }
            else
            {
               this.mKeys[i].state = EmoteSettingKey.STATE_UNSELECTED;
               this.mNames[i].alpha = 0.3;
            }
         }
      }
   }
}


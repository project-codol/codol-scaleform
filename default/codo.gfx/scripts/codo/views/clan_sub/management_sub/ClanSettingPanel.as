package codo.views.clan_sub.management_sub
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.ComboBox;
   import codo.component.TextField;
   import codo.component.social.LevelPicker;
   import codo.component.social.TextArea;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.event.ParaEvent;
   import codo.localization.DictClan;
   import codo.objects.InputBoxSettings;
   import codo.style.ClanGuide;
   
   public class ClanSettingPanel extends BaseSubElement
   {
      
      private static const RECRUIT_STATE_APPLY:int = 0;
      
      private static const RECRUIT_STATE_OPEN:int = 1;
      
      private static const RECRUIT_STATE_CLOSE:int = 2;
      
      private static const SAVE_BTN_WIDTH:Number = 205;
      
      private static const SAVE_BTN_HEIGHT:Number = 62;
      
      public var myClanIntroduceLabel:TextField;
      
      public var myClanRecruiteStateLabel:TextField;
      
      public var myClanIntroduceInput:TextArea;
      
      public var myClanRecruitState:ComboBox;
      
      public var myLevelRestrictLabel:TextField;
      
      public var myClanLevelPicker:LevelPicker;
      
      public var mySaveBtn:Button;
      
      private var mData:Object;
      
      public function ClanSettingPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myClanIntroduceLabel.textStyle = ClanGuide.styleClanLabel;
         this.myClanIntroduceLabel.width = 140;
         this.myClanIntroduceLabel.text = DictClan.CLAN_DESCRIPTION;
         this.myClanRecruiteStateLabel.textStyle = ClanGuide.styleClanLabel;
         this.myClanRecruiteStateLabel.width = 140;
         this.myClanRecruiteStateLabel.text = DictClan.RECRUITE_STATE_LABEL;
         this.myLevelRestrictLabel.textStyle = ClanGuide.styleClanLabel;
         this.myLevelRestrictLabel.width = 140;
         this.myLevelRestrictLabel.text = DictClan.CLAN_LEVEL_REQUIREMENT;
         var textAreaSetting:InputBoxSettings = new InputBoxSettings();
         textAreaSetting.width = 1156;
         textAreaSetting.height = 70;
         textAreaSetting.limitTextLen = ClanGuide.MAX_DESC_TEXT_COUNT;
         this.myClanIntroduceInput.settings = textAreaSetting;
         this.myClanIntroduceInput.text = "";
         var options:Array = [{
            "id":RECRUIT_STATE_APPLY,
            "enabled":true,
            "label":DictClan.RECRUIT_STATE_APPLY
         },{
            "id":RECRUIT_STATE_OPEN,
            "enabled":true,
            "label":DictClan.RECRUIT_STATE_OPEN
         },{
            "id":RECRUIT_STATE_CLOSE,
            "enabled":true,
            "label":DictClan.RECRUIT_STATE_CLOSE
         }];
         this.myClanRecruitState.label = DictClan.RECRUIT_STATE_OPEN;
         this.myClanRecruitState.singleOptionMode = true;
         this.myClanRecruitState.dataProvider = options;
         this.myClanRecruitState.width = 170;
         this.myClanRecruitState.listWidth = 170;
         this.myClanRecruitState.addEventListener(ComboBox.EVT_CHANGE,this.onRecruitStateChanged);
         this.myClanRecruitState.label = DictClan.RECRUIT_STATE_OPEN;
         this.mySaveBtn.width = SAVE_BTN_WIDTH;
         this.mySaveBtn.height = SAVE_BTN_HEIGHT;
         this.mySaveBtn.label = DictClan.SAVE_SETTING;
         this.mySaveBtn.registerClickEvent(this.saveClanSetting);
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.CLAN_INFO,this.bind_clanBasicInfo);
      }
      
      override public function deactive() : void
      {
         unbind(DataID.CLAN_INFO,this.bind_clanBasicInfo);
         super.deactive();
      }
      
      private function bind_clanBasicInfo(cRes:Object) : void
      {
         this.mData = cRes.data;
         this.myClanIntroduceInput.text = this.mData.clanDescription;
         this.myClanRecruitState.selectedIndex = this.mData.recruitState;
         var autoJoinLevel:int = int(this.mData.autoJoinLevel);
         var level:int = autoJoinLevel % 100;
         var prestige:int = (autoJoinLevel - level) / 100;
         if(level == 0)
         {
            level = 1;
         }
         this.myClanLevelPicker.setData(prestige,level);
      }
      
      private function onRecruitStateChanged(e:ParaEvent) : void
      {
         var itemData:Object = this.myClanRecruitState.selectedData;
         var itemId:int = int(itemData.id);
         var itemLabel:String = itemData.label;
         this.myClanRecruitState.label = itemLabel;
      }
      
      private function saveClanSetting() : void
      {
         if(!this.mData)
         {
            return;
         }
         if(this.mData.clanDescription != this.myClanIntroduceInput.text || this.myClanRecruitState.selectedIndex != this.mData.recruitState || this.myClanLevelPicker.getData() != this.mData.autoJoinLevel)
         {
            broadcast(BCEvent.EVT_CHANGE_CLAN_DESCRIPTION_AND_RECRUIT,{
               "text":this.myClanIntroduceInput.text,
               "recruitState":this.myClanRecruitState.selectedIndex,
               "autoJoinLevel":this.myClanLevelPicker.getData()
            });
         }
         showMsg(DictClan.SAVE_SETTING_SUCCESS,MsgBtnCount.ONE);
      }
   }
}


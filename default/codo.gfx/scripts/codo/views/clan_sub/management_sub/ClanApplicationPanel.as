package codo.views.clan_sub.management_sub
{
   import codo.base.BaseSubElement;
   import codo.component.social.ClanApplicationItem;
   import codo.component.social.PageList;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.DictClan;
   import codo.localization.DictMail;
   import codo.objects.PageListSettings;
   import codo.style.ClanGuide;
   import flash.display.MovieClip;
   
   public class ClanApplicationPanel extends BaseSubElement
   {
      
      private static const APPLICATION_ITEM_RENDER:String = "codo.social.clanApplicationItem";
      
      public var myPageList:PageList;
      
      public var myHeader:MovieClip;
      
      public var myNoDataHint:MovieClip;
      
      private var mPageListSetting:PageListSettings;
      
      public function ClanApplicationPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myHeader.myTimeLabel.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myTimeLabel.width = 100;
         this.myHeader.myTimeLabel.text = DictClan.LIST_TITLE_TIMESTAMP;
         this.myHeader.myNameLabel.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myNameLabel.width = 100;
         this.myHeader.myNameLabel.text = DictClan.LIST_TITLE_NAME;
         this.myHeader.myRankLabel.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myRankLabel.width = 100;
         this.myHeader.myRankLabel.text = DictClan.LIST_TITLE_RANK;
         this.myHeader.myKDALabel.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myKDALabel.width = 100;
         this.myHeader.myKDALabel.text = DictClan.LIST_TITLE_KDA;
         this.myHeader.myTimePlayedLabel.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myTimePlayedLabel.width = 100;
         this.myHeader.myTimePlayedLabel.text = DictClan.LIST_TITLE_TIME_PLAYED;
         this.mPageListSetting = new PageListSettings();
         this.mPageListSetting.itemCountPerPage = 11;
         this.mPageListSetting.itemPadding = 0;
         this.mPageListSetting.renderLinkName = APPLICATION_ITEM_RENDER;
         this.mPageListSetting.itemClickHandler = this.applicationItemClicked;
         this.myPageList.settings = this.mPageListSetting;
         this.myNoDataHint.myText.text = DictMail.NO_APPLY_HINT;
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.MESSAGE_CLAN_APPLICATION,this.bind_clanApplication);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.MESSAGE_CLAN_APPLICATION,this.bind_clanApplication);
      }
      
      private function bind_clanApplication(cRes:Object) : void
      {
         var data:Array = cRes.data.dp as Array;
         this.myPageList.dataProvider = data;
         this.myNoDataHint.visible = data.length <= 0;
      }
      
      private function applicationItemClicked(data:Object, whichButtonClicked:int) : void
      {
         switch(whichButtonClicked)
         {
            case ClanApplicationItem.DETAIL_BUTTON_INDEX:
               broadcast(BCEvent.VIEW_PLAYER_DETAIL_INFO,{
                  "id":data.senderID,
                  "name":data.senderName
               });
               break;
            case ClanApplicationItem.REJECT_BUTTON_INDEX:
               broadcast(BCEvent.EVT_REJECT_INVITATION,data);
               break;
            case ClanApplicationItem.APPROVE_BUTTON_INDEX:
               broadcast(BCEvent.EVT_ACCEPT_INVITATION,data);
         }
      }
   }
}


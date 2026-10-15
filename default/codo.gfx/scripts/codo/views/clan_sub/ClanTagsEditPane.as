package codo.views.clan_sub
{
   import codo.base.BaseSubElement;
   import codo.component.Popup;
   import codo.component.social.ClanTag;
   import codo.component.social.ClanTagButton;
   import codo.constants.BCEvent;
   import codo.localization.DictClan;
   import codo.objects.ClanObj;
   import codo.utils.TableUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class ClanTagsEditPane extends BaseSubElement
   {
      
      private static const CLAN_TAG_LINK:String = "codo.social.clanTagButton";
      
      private static const TAG_PER_ROW:int = 8;
      
      private static const TAG_X_WIDTH:Number = 102;
      
      private static const TAG_Y_HEIGHT:Number = 54;
      
      private static const TAG_LIST_PADDING:Number = 64;
      
      private static const POPUP_HEIGHT_PADDING:Number = 7;
      
      public var myPopup:Popup;
      
      public var myClanTagsContainer:MovieClip;
      
      public var myHint:TextField;
      
      public var myCurrentTagBoard:MovieClip;
      
      private var mTagList:Vector.<ClanTagButton>;
      
      private var mCurrentTagList:Vector.<ClanTagButton>;
      
      private var mClanTagIDs:Array;
      
      public function ClanTagsEditPane()
      {
         var i:int = 0;
         var row:int = 0;
         var col:int = 0;
         var tagBtn:ClanTagButton = null;
         super();
         this.mClanTagIDs = new Array();
         this.myHint.text = DictClan.CLAN_TAGS_SELECT_HINT;
         this.myCurrentTagBoard.myText.text = DictClan.CURRENT_CLAN_TAGS;
         this.mTagList = new Vector.<ClanTagButton>();
         var rowNum:int = TableUtil.getRowCount(ClanTag.TAGS_TABLE_PATH);
         var cls:Class = getDefinitionByName(CLAN_TAG_LINK) as Class;
         for(i = 0; i < rowNum; i++)
         {
            row = i / TAG_PER_ROW;
            col = i % TAG_PER_ROW;
            tagBtn = new cls();
            tagBtn.x = TAG_X_WIDTH * col;
            tagBtn.y = TAG_Y_HEIGHT * row;
            tagBtn.myCloseBtn.visible = false;
            tagBtn.onClickFunction = this.selectOrUnSelectTag;
            tagBtn.setupByRow(i);
            this.mTagList.push(tagBtn);
            this.myClanTagsContainer.addChild(tagBtn);
         }
         this.mCurrentTagList = new Vector.<ClanTagButton>();
         for(i = 0; true; i++)
         {
            tagBtn = this.myCurrentTagBoard.getChildByName("myTag".concat(i)) as ClanTagButton;
            if(tagBtn == null)
            {
               break;
            }
            tagBtn.visible = false;
            tagBtn.enabled = false;
            tagBtn.onClickFunction = this.selectOrUnSelectTag;
            this.mCurrentTagList.push(tagBtn);
         }
         this.myCurrentTagBoard.y = this.myClanTagsContainer.y + this.myClanTagsContainer.height + TAG_LIST_PADDING;
         this.myPopup.myCloseButton.registerClickEvent(this.onCloseBtnClicked);
         this.myPopup.myHeaderbar.title = DictClan.CLAN_TAGS_PANEL_LABEL;
         this.myPopup.width = 992;
         this.myPopup.height = this.myCurrentTagBoard.y - this.myPopup.y + this.myCurrentTagBoard.height + POPUP_HEIGHT_PADDING;
         this.myPopup.configConfirmButton("@SF_UI_CONFIRM_SELECTION",this.onConfirmBtnClicked,true);
         this.myPopup.configCancelButton("@SF_UI_SYS_CANCEL",this.onCloseBtnClicked);
      }
      
      public function setData(data:ClanObj) : void
      {
         if(data.tags != null)
         {
            this.mClanTagIDs = data.tags.concat();
         }
         else
         {
            this.mClanTagIDs.splice(0);
         }
         this.refreshTagButtons(this.mClanTagIDs);
      }
      
      override public function active() : void
      {
         super.active();
      }
      
      private function onCloseBtnClicked() : void
      {
         deactive();
      }
      
      private function onConfirmBtnClicked() : void
      {
         deactive();
         broadcast(BCEvent.EVT_CHANGE_CLAN_TAGS,this.mClanTagIDs);
      }
      
      private function refreshTagButtons(tagIDs:Array) : void
      {
         var tagBtn:ClanTagButton = null;
         var tagNum:int = tagIDs == null ? 0 : int(tagIDs.length);
         for(var i:int = 0; i < this.mCurrentTagList.length; i++)
         {
            if(i < tagNum)
            {
               this.mCurrentTagList[i].visible = true;
               this.mCurrentTagList[i].id = tagIDs[i];
            }
            else
            {
               this.mCurrentTagList[i].visible = false;
            }
         }
         for each(tagBtn in this.mTagList)
         {
            tagBtn.selected = tagIDs.indexOf(tagBtn.id) >= 0;
         }
      }
      
      private function selectOrUnSelectTag(tagId:int) : void
      {
         var index:int = this.mClanTagIDs.indexOf(tagId);
         if(index >= 0)
         {
            this.mClanTagIDs.splice(index,1);
         }
         else
         {
            if(this.mClanTagIDs.length >= this.mCurrentTagList.length)
            {
               return;
            }
            this.mClanTagIDs.push(tagId);
         }
         this.refreshTagButtons(this.mClanTagIDs);
      }
   }
}


package codo.views.friend_parts
{
   import codo.base.BaseSubElement;
   import codo.component.ComboBox;
   import codo.component.ContentContainer;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.social.SocialDropDown;
   import codo.component.social.SocialHamburgerButton;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.constants.RightClickMenuType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.RightClickMenuItemObj;
   import codo.objects.ScrollListSettings;
   import codo.style.FriendGuide;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class MemberListPanel extends BaseSubElement
   {
      
      private static const ITEM_LINKAGE:String = "codo.friend.friendSelector";
      
      private static const DROP_DOWN_PANEL_LINK:String = "codo.social.socialDropDown";
      
      private static const FILTER_TYPE_ALL:int = 0;
      
      private static const FILTER_TYPE_ONLINE:int = 1;
      
      private static const FILTER_TYPE_INGAME:int = 2;
      
      private static const FILTER_TYPE_OFFLINE:int = 3;
      
      private static const MEMBER_PANEL_WIDTH:int = 714;
      
      private static const MEMBER_PANEL_HEIGHT:int = 715;
      
      public var myContentContainer:ContentContainer;
      
      public var myFilter:ComboBox;
      
      public var myFilterLabel:TextField;
      
      public var myScrollGrid:ScrollGrid;
      
      private var mCurrentFilter:int = 0;
      
      private var mUnfilteredData:Vector.<Object>;
      
      private var mListKeeper:Vector.<Object> = new Vector.<Object>();
      
      private var mDropDownMenu:SocialDropDown;
      
      private var mPlayerBasicInfoQueryUtil:PlayerBasicInfoQueryUtil;
      
      public function MemberListPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myContentContainer.width = MEMBER_PANEL_WIDTH;
         this.myContentContainer.height = MEMBER_PANEL_HEIGHT;
         this.myFilterLabel.textStyle = FriendGuide.styleFilterLabel;
         this.myFilterLabel.text = Dict.FILTER_OPTION;
         this.myFilter.width = 123;
         this.myFilter.singleOptionMode = true;
         var options:Array = [{
            "id":FILTER_TYPE_ALL,
            "enabled":true,
            "label":Dict.USER_ALL
         },{
            "id":FILTER_TYPE_ONLINE,
            "enabled":true,
            "label":Dict.USER_ONLINE
         },{
            "id":FILTER_TYPE_INGAME,
            "enabled":true,
            "label":Dict.USER_STATUS_INGAME
         },{
            "id":FILTER_TYPE_OFFLINE,
            "enabled":true,
            "label":Dict.USER_OFFLINE
         }];
         this.myFilter.dataProvider = options;
         this.myFilter.label = Dict.USER_ALL;
         this.myFilter.addEventListener(ComboBox.EVT_CHANGE,this.onFilterChanged);
         var setting:ScrollListSettings = new ScrollListSettings();
         setting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         setting.itemLinkage = ITEM_LINKAGE;
         setting.itemPadding = 10;
         setting.useNavArrows = false;
         this.myScrollGrid.initGrid(setting,14,false,1);
         this.myScrollGrid.addItemsByVector(new Vector.<Object>());
         FriendSelector.setOptionButtonClickHandler(this.onOptionButtonClickedHandler);
         var cls:Class = getDefinitionByName(DROP_DOWN_PANEL_LINK) as Class;
         this.mDropDownMenu = new cls() as SocialDropDown;
         this.mPlayerBasicInfoQueryUtil = new PlayerBasicInfoQueryUtil();
         this.mPlayerBasicInfoQueryUtil.registerPlayerBasicInfoHandler(this.onPlayerBasicInfo);
         this.mPlayerBasicInfoQueryUtil.registerCompleteHandler(this.onPlayerBasicInfoComplete);
      }
      
      private function onFilterChanged(e:ParaEvent) : void
      {
         var option:Object = this.myFilter.selectedData;
         this.mCurrentFilter = option.id;
         this.myFilter.label = option.label;
         this.processFilteredData(this.mUnfilteredData);
         this.myScrollGrid.addItemsByVector(this.mListKeeper);
      }
      
      public function setData(member:Vector.<Object>) : void
      {
         this.mUnfilteredData = member;
         this.processFilteredData(member);
         this.myScrollGrid.addItemsByVector(this.mListKeeper);
         var userIdsArray:Array = [];
         for(var i:int = 0; i < this.mListKeeper.length; i++)
         {
            userIdsArray.push(this.mListKeeper[i].id);
         }
         this.mPlayerBasicInfoQueryUtil.queryPlayerBasicInfo(userIdsArray);
      }
      
      private function processFilteredData(member:Vector.<Object>) : void
      {
         this.mListKeeper.splice(0,this.mListKeeper.length);
         var memberCount:int = int(member.length);
         for(var i:int = 0; i < memberCount; i++)
         {
            if(this.isPassTheFiler(member[i]))
            {
               this.mListKeeper.push(member[i]);
            }
         }
      }
      
      private function isPassTheFiler(member:Object) : Boolean
      {
         var status:int = int(member.friendStatus);
         switch(this.mCurrentFilter)
         {
            case FILTER_TYPE_ALL:
               return true;
            case FILTER_TYPE_ONLINE:
               if(status == Common.CODO_BASIC_PRESENCE_MENU || status == Common.CODO_BASIC_PRESENCE_ROOM || status == Common.CODO_BASIC_PRESENCE_PARTY || status == Common.CODO_BASIC_PRESENCE_GAME)
               {
                  return true;
               }
               break;
            case FILTER_TYPE_INGAME:
               if(status == Common.CODO_BASIC_PRESENCE_GAME)
               {
                  return true;
               }
               break;
            case FILTER_TYPE_OFFLINE:
               if(status == Common.CODO_BASIC_PRESENCE_OFFLINE)
               {
                  return true;
               }
         }
         return false;
      }
      
      private function onOptionButtonClickedHandler(button:SocialHamburgerButton) : void
      {
         var localPoint:Point;
         var globalPoint:Point = null;
         var onStageClicked:Function = null;
         onStageClicked = function(evt:MouseEvent):void
         {
            var hitObj:Object = evt.target;
            if(!hitObj.parent || !(hitObj.parent is SocialHamburgerButton))
            {
               removeChild(mDropDownMenu);
               stage.removeEventListener(MouseEvent.CLICK,onStageClicked);
            }
         };
         var optionMenu:Vector.<RightClickMenuItemObj> = getDP(DataID.RIGHT_CLICK_MENU,[RightClickMenuType.FULL,button.getData()]);
         this.mDropDownMenu.setOptionMenu(optionMenu,button.getData());
         addChild(this.mDropDownMenu);
         globalPoint = button.localToGlobal(new Point(button.width,button.height));
         localPoint = this.globalToLocal(globalPoint);
         this.mDropDownMenu.visible = true;
         this.mDropDownMenu.x = localPoint.x - this.mDropDownMenu.width + 10;
         this.mDropDownMenu.y = localPoint.y + 10;
         if(globalPoint.y + this.mDropDownMenu.height > GameInfo.DEFAULT_HEIGHT)
         {
            this.mDropDownMenu.y = localPoint.y - this.mDropDownMenu.height;
         }
         stage.addEventListener(MouseEvent.CLICK,onStageClicked);
      }
      
      public function onPlayerBasicInfo(info:PlayerBasicInfoObj) : void
      {
         if(!info.available)
         {
            return;
         }
         for(var j:uint = 0; j < this.mListKeeper.length; j++)
         {
            if(this.mListKeeper[j].id == info.entityID)
            {
               this.mListKeeper[j].wargodScore = info.wargodScore;
               this.mListKeeper[j].wargodSeason = info.wargodSeason;
               break;
            }
         }
      }
      
      public function onPlayerBasicInfoComplete() : void
      {
         this.myScrollGrid.addItemsByVector(this.mListKeeper);
      }
   }
}


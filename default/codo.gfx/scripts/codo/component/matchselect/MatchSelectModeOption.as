package codo.component.matchselect
{
   import codo.component.Breadcrumb;
   import codo.component.TextField;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.MapObj;
   import codo.objects.MatchSelectModeObj;
   import codo.objects.MatchSelectRoomModeObj;
   import codo.objects.ModeObj;
   import codo.objects.PlayListObj;
   import codo.style.GlobalGuide;
   import codo.style.MatchSelectGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.TableUtil;
   import flash.filters.DropShadowFilter;
   import fsg.util.FsgImageHolder;
   
   public class MatchSelectModeOption extends MatchSelectOption
   {
      
      public static const DMZ_DEFAULT_IMAGE:String = "scaleform_ash/miscicons/dmz_modeBG1";
      
      public static const DMZ_HARDCORE_IMAGE:String = "scaleform_ash/miscicons/dmz_modeBG2";
      
      public static const DMZ_LEAGUE_IMAGE:String = "scaleform_ash/miscicons/dmz_modeBG3";
      
      public var myImage:FsgImageHolder;
      
      public var myInfoLabel:TextField;
      
      public function MatchSelectModeOption()
      {
         super();
         myLabel.textStyle = MatchSelectGuide.styleModeOption;
         myLabel.width = 369;
         myLabel.height = 40;
         myLabel.x = 0;
         myLabel.y = 22;
         myLabel.text = "";
         this.myInfoLabel.textStyle = MatchSelectGuide.styleInfoLabel;
         this.myInfoLabel.visible = false;
         this.myInfoLabel.width = myLabel.width - 4;
         this.myInfoLabel.x = 2;
         mTagPosition = [310,254];
         myUnlockLevel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.gotoNormalState();
      }
      
      override public function setData(data:*) : void
      {
         var modeData:MatchSelectModeObj = null;
         var mapObj:MapObj = null;
         var playlist:PlayListObj = null;
         super.setData(data);
         if(data == null)
         {
            visible = false;
            return;
         }
         visible = true;
         var image:String = "SP_Multi_Gamemode_.tga";
         modeData = data as MatchSelectModeObj;
         var modeObj:ModeObj = data as ModeObj;
         var roomMode:MatchSelectRoomModeObj = data as MatchSelectRoomModeObj;
         var playlistObj:PlayListObj = data as PlayListObj;
         if(modeData != null)
         {
            if(modeData.heroOpsMaps != null && modeData.heroOpsMaps.length > 0)
            {
               mapObj = modeData.heroOpsMaps[0] as MapObj;
               image = mapObj.imageURL;
            }
            else
            {
               playlist = null;
               if(modeData.cycleTodayIndex >= 0)
               {
                  playlist = modeData.getPlaylist(modeData.cycleTodayIndex);
                  this.myInfoLabel.visible = playlist != null;
                  if(this.myInfoLabel.visible)
                  {
                     this.myInfoLabel.text = LocalizeUtil.localize("@SF_UI_TODAY_PARTY") + ": " + playlist.name;
                  }
               }
               else
               {
                  this.myInfoLabel.visible = false;
                  playlist = modeData.getPlaylist(0);
               }
               if(playlist != null)
               {
                  image = playlist.getImage();
               }
            }
            this.updateRedDot(modeData.isNewUnlock);
         }
         if(modeObj != null)
         {
            image = modeObj.image;
         }
         if(roomMode != null)
         {
            image = roomMode.image;
         }
         var globalObj:BattleCityLeagueGlobalObj = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         if(playlistObj != null)
         {
            if(playlistObj.isBattleCityMode())
            {
               if(playlistObj.isBattleCityLeague())
               {
                  image = DMZ_LEAGUE_IMAGE;
                  myLockIcon.visible = !globalObj.enabled;
               }
               else if(playlistObj.isBattleCityHardCoreMode())
               {
                  image = DMZ_HARDCORE_IMAGE;
               }
               else
               {
                  image = DMZ_DEFAULT_IMAGE;
               }
            }
         }
         this.myImage.setImage(image);
         var offset:Number = this.getImageStripYOffset(image);
         this.myImage.y = -1 * offset;
         var padding:Number = 8;
         var totalWidth:Number = myLockIcon.width + myUnlockLevel.textWidth + padding;
         myLockIcon.y = 55;
         myUnlockLevel.y = 55;
         myLockIcon.x = 8;
         myUnlockLevel.x = myLockIcon.x + myLockIcon.width + GlobalGuide.COMPONENT_PADDING;
      }
      
      override public function set selected(sel:Boolean) : void
      {
         super.selected = sel;
         if(mSelected)
         {
            this.gotoSelectState();
         }
         else
         {
            this.gotoNormalState();
         }
      }
      
      private function updateRedDot(show:Boolean) : void
      {
         var crumb:Breadcrumb = getBreadcrumb();
         if(show)
         {
            if(crumb == null)
            {
               crumb = addBreadcrumb();
            }
            crumb.visible = true;
         }
         else if(crumb != null)
         {
            crumb.visible = false;
         }
      }
      
      override public function draw() : void
      {
         super.draw();
      }
      
      override protected function gotoNormalState() : void
      {
         myForeground.gotoAndStop(FRAME_NORMAL);
         myLabel.fontColor = 12905727;
         var dropShadow:DropShadowFilter = new DropShadowFilter(2,45,0,0.8,2,2);
         myLabel.filters = [dropShadow];
      }
      
      override protected function gotoOverState() : void
      {
         myForeground.gotoAndStop(FRAME_OVER);
         myLabel.fontColor = GlobalGuide.WHITE;
         myLabel.filters = [];
      }
      
      override protected function gotoSelectState() : void
      {
         myForeground.gotoAndStop(FRAME_SELECTED);
         myLabel.fontColor = GlobalGuide.WHITE;
         myLabel.filters = [];
      }
      
      private function getImageStripYOffset(image:String) : Number
      {
         if(image == DMZ_DEFAULT_IMAGE || image == DMZ_HARDCORE_IMAGE || image == DMZ_LEAGUE_IMAGE)
         {
            return 62;
         }
         var index:int = image.indexOf(".tga");
         if(index != -1)
         {
            image = image.substr(0,index);
         }
         var result:String = TableUtil.lookup("mp/modeMapImageStrip.csv",0,image,1);
         if(result != "")
         {
            return Number(result);
         }
         return 0;
      }
      
      override protected function updateLabelPosition() : void
      {
         myLabel.x = 0;
      }
   }
}


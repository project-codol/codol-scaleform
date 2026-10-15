package components.matchselect_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.DictRoom;
   import codo.objects.PlayListObj;
   import flash.display.MovieClip;
   
   public class MatchSelectPlaylistItem extends MatchSelectListItem
   {
      
      private static var INERT_DOWNLOADING_ICON:int = 3;
      
      private static var HIGHLIGHTED_DOWNLOADING_ICON:int = 4;
      
      public var myRoomStatusText:MovieClip;
      
      private var m_lockedByMicroClient:Boolean;
      
      public function MatchSelectPlaylistItem()
      {
         super();
         this.m_lockedByMicroClient = false;
      }
      
      override protected function onGetData() : void
      {
         var currentLevel:int = 0;
         var currentPrestige:int = 0;
         var maxLevel:uint = 0;
         var openLevels:Array = null;
         var start:int = 0;
         var end:int = 0;
         var lockText:String = null;
         super.onGetData();
         var playListObj:PlayListObj = _data as PlayListObj;
         this.myRoomStatusText.myTextTF.text = DictRoom.PLAYLIST_PLAYER_COUNT_STATUS[playListObj.playerCountStatus];
         this.m_lockedByMicroClient = playListObj.dlcLocked;
         if(currentFrame == 1 || currentFrame == 3)
         {
            this.setLockNormal();
         }
         else
         {
            this.setLockHighlighted();
         }
         if(myIconLock.visible == true && !playListObj.dlcLocked)
         {
            if(myIconLock.myLockText != null)
            {
               currentLevel = CFunctionCommonContainer.GetPlayerLevel();
               currentLevel += 1;
               currentPrestige = CFunctionCommonContainer.GetPlayerPrestige();
               maxLevel = CFunctionCommonContainer.GetPlayerMaxLevel();
               openLevels = playListObj.unlockedLevels;
               start = int(openLevels[0].start);
               end = int(openLevels[0].end);
               lockText = "";
               if(currentLevel < start && currentPrestige == 0)
               {
                  lockText = String(start);
               }
               else if(currentLevel > end || currentPrestige > 0 && end < maxLevel)
               {
                  lockText = String(end);
               }
               myIconLock.myLockText.myLockTF.text = lockText;
            }
         }
         else if(myIconLock.myLockText != null)
         {
            myIconLock.myLockText.myLockTF.text = "";
         }
      }
      
      override protected function setLockNormal() : void
      {
         myIconLock.gotoAndStop(this.m_lockedByMicroClient ? INERT_DOWNLOADING_ICON : INERT_LOCKED_ICON);
      }
      
      override protected function setLockHighlighted() : void
      {
         myIconLock.gotoAndStop(this.m_lockedByMicroClient ? HIGHLIGHTED_DOWNLOADING_ICON : HIGHLIGHTED_LOCKED_ICON);
      }
      
      override protected function updateLock() : void
      {
         var playListObj:PlayListObj = _data as PlayListObj;
         myIconLock.visible = !playListObj.unlocked || playListObj.dlcLocked || !playListObj.unlockedTimedMatch;
      }
      
      override protected function updateNew() : void
      {
         var playListObj:PlayListObj = _data as PlayListObj;
         var isNew:Boolean = !myIconLock.visible && !playListObj.isFeatured ? playListObj.isNew : false;
         setIsNew(isNew);
      }
      
      override protected function updateFeatured() : void
      {
         var playListObj:PlayListObj = _data as PlayListObj;
         var isFeatured:Boolean = !myIconLock.visible ? playListObj.isFeatured : false;
         setIsFeatured(isFeatured);
      }
   }
}


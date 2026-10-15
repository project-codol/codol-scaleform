package codo.views.leaderboard_sub.detail_sub
{
   import codo.component.social.PageList;
   import codo.views.wargod_parts.WarGodLeaderboardItem;
   
   public class LeaderBoardPageList extends PageList
   {
      
      private var mSelfEntityId:String;
      
      private var mShowHamburgerButtonClickedHandler:Function;
      
      public function LeaderBoardPageList()
      {
         super();
      }
      
      public function setShowHamburgerButton(handler:Function) : void
      {
         this.mShowHamburgerButtonClickedHandler = handler;
      }
      
      override public function refresh() : void
      {
         var lbItem:LeaderBoardItem = null;
         var wglbItem:WarGodLeaderboardItem = null;
         var renderShowCount:int = 0;
         var i:int = 0;
         while(i < mSetting.itemCountPerPage && i < mDataProvider.length)
         {
            mRenderKeeper[i].setData(mDataProvider[i]);
            lbItem = mRenderKeeper[i] as LeaderBoardItem;
            if(Boolean(lbItem))
            {
               lbItem.isSelfMode(lbItem.getData().entityID == this.mSelfEntityId);
               lbItem.myHamburgerBtn.setShowHamburgerButtonClickedHandler(this.mShowHamburgerButtonClickedHandler);
            }
            wglbItem = mRenderKeeper[i] as WarGodLeaderboardItem;
            if(Boolean(wglbItem))
            {
               wglbItem.isSelfMode(wglbItem.getData().entityID == this.mSelfEntityId);
               wglbItem.myHamburgerBtn.setShowHamburgerButtonClickedHandler(this.mShowHamburgerButtonClickedHandler);
            }
            mRenderKeeper[i].visible = true;
            renderShowCount++;
            i++;
         }
         for(i = renderShowCount; i < mSetting.itemCountPerPage; i++)
         {
            mRenderKeeper[i].visible = false;
         }
      }
      
      public function set selfEntityId(value:String) : void
      {
         this.mSelfEntityId = value;
      }
   }
}


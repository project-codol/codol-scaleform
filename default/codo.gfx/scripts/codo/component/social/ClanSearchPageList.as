package codo.component.social
{
   public class ClanSearchPageList extends PageList
   {
      
      private var mShowJoinBtn:Boolean = true;
      
      public function ClanSearchPageList()
      {
         super();
      }
      
      override public function refresh() : void
      {
         var i:int = 0;
         var renderShowCount:int = 0;
         i = 0;
         while(i < mSetting.itemCountPerPage && i < mDataProvider.length)
         {
            mRenderKeeper[i].setData(mDataProvider[i]);
            mRenderKeeper[i].visible = true;
            if(mRenderKeeper[i] is ClanSearchResultItem)
            {
               (mRenderKeeper[i] as ClanSearchResultItem).switchShowJoinBtn(this.mShowJoinBtn);
            }
            this.refreshJoinBtnState(mRenderKeeper[i],mDataProvider[i]);
            renderShowCount++;
            i++;
         }
         for(i = renderShowCount; i < mSetting.itemCountPerPage; i++)
         {
            mRenderKeeper[i].visible = false;
         }
      }
      
      public function switchShowJoinBtn(value:Boolean) : void
      {
         this.mShowJoinBtn = value;
      }
      
      public function refreshAllRenderJoinBtnState() : void
      {
         for(var i:int = 0; i < mDataProvider.length; i++)
         {
            this.refreshJoinBtnState(mRenderKeeper[i],mDataProvider[i]);
         }
      }
      
      private function refreshJoinBtnState(item:PageListBaseRender, data:Object) : void
      {
         if(mSetting.extraHandler == null)
         {
            return;
         }
         var searchRender:ClanSearchResultItem = item as ClanSearchResultItem;
         if(!searchRender)
         {
            return;
         }
         var isApplicationEverSent:Boolean = mSetting.extraHandler(data.id);
         if(isApplicationEverSent)
         {
            searchRender.setJoinBtnState(ClanSearchResultItem.JOIN_BTN_STATE_SENT);
         }
         else
         {
            searchRender.setJoinBtnState(ClanSearchResultItem.JOIN_BTN_STATE_NORMAL);
         }
      }
   }
}


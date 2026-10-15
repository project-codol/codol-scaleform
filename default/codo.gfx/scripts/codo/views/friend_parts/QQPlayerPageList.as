package codo.views.friend_parts
{
   import codo.component.social.PageList;
   
   public class QQPlayerPageList extends PageList
   {
      
      public function QQPlayerPageList()
      {
         super();
      }
      
      override public function refresh() : void
      {
         for(var i:int = 0; i < mSetting.itemCountPerPage; i++)
         {
            if(i < mDataProvider.length)
            {
               mRenderKeeper[i].setData(mDataProvider[i]);
               mRenderKeeper[i].visible = true;
            }
            else
            {
               mRenderKeeper[i].visible = false;
            }
         }
      }
   }
}


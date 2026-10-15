package components.fsgSocialPanel_part.FsgEmailHelper
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.DataID;
   import codo.localization.DictParty;
   import codo.manager.DataManager;
   import codo.objects.PlayListObj;
   import codo.objects.PlaylistCategoryObj;
   import codo.utils.LocalizeUtil;
   
   public class MailDataAdapterGameInvites2Mail extends MailDataAdapterFriendInvites2Mail
   {
      
      public function MailDataAdapterGameInvites2Mail()
      {
         super();
      }
      
      override public function adaptOneObject(rawObj:Object) : Object
      {
         var adaptedObj:Object = null;
         var gameModeName:String = null;
         if(!rawObj.isLog)
         {
            adaptedObj = super.adaptOneObject(rawObj);
            gameModeName = this.getMessageContent(rawObj);
            adaptedObj.message = LocalizeUtil.param(DictParty.GAME_INVITATION_MESSAGE,[adaptedObj.senderName,gameModeName]);
            adaptedObj.fsgMailType = FsgMailType.MAIL_TYPE_GAME_INVITE;
            return adaptedObj;
         }
         return null;
      }
      
      private function getMessageContent(rawObj:Object) : String
      {
         var playlistObj:PlayListObj = null;
         var categoryObj:PlaylistCategoryObj = null;
         var content:String = "";
         if(rawObj.gameType == "playlist")
         {
            playlistObj = DataManager.getInstance().getDP(DataID.PLAY_LIST_OBJ,[rawObj.playlistID]);
            categoryObj = CFunctionContainer.AS_GetPlayListCategoryByID(playlistObj.category);
            if(Boolean(categoryObj))
            {
               content = categoryObj.name;
            }
         }
         else
         {
            content = CFunctionCommonContainer.AS_GetGameTypeDisplayName(rawObj.gameType);
         }
         return content;
      }
   }
}


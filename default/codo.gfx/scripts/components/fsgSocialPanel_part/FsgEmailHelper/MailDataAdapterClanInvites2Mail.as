package components.fsgSocialPanel_part.FsgEmailHelper
{
   import codo.component.social.ClanTag;
   import codo.localization.Dict;
   import codo.objects.ClanGlobalConfig;
   import codo.utils.LocalizeUtil;
   import codo.utils.TableUtil;
   
   public class MailDataAdapterClanInvites2Mail extends MailDataAdapterFriendInvites2Mail
   {
      
      public function MailDataAdapterClanInvites2Mail()
      {
         super();
      }
      
      override public function adaptOneObject(rawObj:Object) : Object
      {
         var adaptedObj:Object = super.adaptOneObject(rawObj);
         adaptedObj.fsgMailType = FsgMailType.MAIL_TYPE_CLAN_INVITE;
         adaptedObj.message = this.organizeMessage(rawObj);
         return adaptedObj;
      }
      
      private function organizeMessage(rawObj:Object) : String
      {
         var clanLevelName:String = null;
         var tagID:int = 0;
         var row:int = 0;
         var desc:String = null;
         var hasDetail:Boolean = Boolean(rawObj.clanLevel) && Boolean(rawObj.numClanMember);
         var message:String = LocalizeUtil.param(Dict.RECEIVE_CLAN_INVITE_FROM_USER,[rawObj.senderName]);
         if(hasDetail)
         {
            clanLevelName = LocalizeUtil.localize(ClanGlobalConfig.CLAN_LEVEL_NAMES[rawObj.clanLevel - 1]);
            message = message + "\n" + LocalizeUtil.param(Dict.RECEIVE_CLAN_INVITE_FROM_USER2,[rawObj.targetName,rawObj.targetID,clanLevelName,String(rawObj.numClanMember)]);
            if(rawObj.clanTags != null)
            {
               message = message + "\n" + LocalizeUtil.localize("@SF_UI_CLAN_TAG_LABEL") + ": ";
               for each(tagID in rawObj.clanTags)
               {
                  row = TableUtil.lookupRow(ClanTag.TAGS_TABLE_PATH,ClanTag.TAGS_TABLE_COL_ID,tagID.toString());
                  desc = TableUtil.getValue(ClanTag.TAGS_TABLE_PATH,row,ClanTag.TAGS_TABLE_COL_DESC);
                  message += LocalizeUtil.localize("@" + desc) + " ";
               }
            }
         }
         return message;
      }
   }
}


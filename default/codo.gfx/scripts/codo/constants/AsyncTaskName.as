package codo.constants
{
   import codo.tasks.*;
   import flash.utils.Dictionary;
   
   public class AsyncTaskName
   {
      
      private static var _asyncTaskNames:Dictionary;
      
      public function AsyncTaskName()
      {
         super();
      }
      
      public static function getClass(id:uint = 0) : Class
      {
         if(_asyncTaskNames == null)
         {
            _asyncTaskNames = new Dictionary();
            _asyncTaskNames[DataID.CREATE_ROOM] = CreateRoomTask;
            _asyncTaskNames[DataID.JOIN_ROOM] = JoinRoomTask;
            _asyncTaskNames[DataID.LEAVE_ROOM] = LeaveRoomTask;
            _asyncTaskNames[DataID.GROUP_COUNTS] = GetGroupCountsTask;
            _asyncTaskNames[DataID.JUMP_GAME] = JumpGameTask;
            _asyncTaskNames[DataID.LIST_CLAN] = ListClanTask;
            _asyncTaskNames[DataID.CREATE_CLAN] = CreateClanTask;
            _asyncTaskNames[DataID.LEAVE_CLAN] = LeaveClanTask;
            _asyncTaskNames[DataID.RENAME_CLAN] = RenameClanTask;
            _asyncTaskNames[DataID.KICK_CLAN_MEMBER] = KickClanMemberTask;
            _asyncTaskNames[DataID.PROMOTE_CLAN_MEMBER] = PromoteClanMemberTask;
            _asyncTaskNames[DataID.DEMOTE_CLAN_MEMBER] = DemoteClanMemberTask;
            _asyncTaskNames[DataID.PROPOSE_CLAN_MEMBERSHIP] = ProposeClanMembershipTask;
            _asyncTaskNames[DataID.ACCEPT_CLAN_MEMBERSHIP] = AcceptClanMembershipTask;
            _asyncTaskNames[DataID.REJECT_CLAN_MEMBERSHIP] = RejectClanMembershipTask;
            _asyncTaskNames[DataID.CREATE_PARTY] = CreatePartyTask;
            _asyncTaskNames[DataID.JOIN_PARTY] = JoinPartyTask;
            _asyncTaskNames[DataID.LEAVE_PARTY] = LeavePartyTask;
            _asyncTaskNames[DataID.START_MATCH] = StartMatchTask;
            _asyncTaskNames[DataID.QUICK_MATCH] = QuickMatchTask;
            _asyncTaskNames[DataID.QUICK_MATCH_IN_PROGRESS_IN_ROOM] = QuickMatchInProgressInRoomTask;
            _asyncTaskNames[DataID.LIST_FRIEND] = ListContactTask;
            _asyncTaskNames[DataID.LIST_BLACKLIST] = ListBlackListTask;
            _asyncTaskNames[DataID.LIST_RECENTPLAYMATE] = ListRecentPlaymateTask;
            _asyncTaskNames[DataID.PROPOSE_FRIEND_MEMBERSHIP] = ProposeFriendMembershipTask;
            _asyncTaskNames[DataID.LIST_LEADERBOARD] = ListLeaderboardTask;
            _asyncTaskNames[DataID.LIST_DEDICATED_SERVER] = ListDedicatedServerTask;
            _asyncTaskNames[DataID.PUBLISHER_FILES_UPDATE] = PublisherFileTask;
            _asyncTaskNames[DataCommonID.TENCENT_SANITIZE_STRING] = TencentSanitizeStringTask;
            _asyncTaskNames[DataID.TENCENT_GET_AAS_RECORD] = TencentGetAASRecordTask;
            _asyncTaskNames[DataID.SEND_MAIL] = SendMailTask;
            _asyncTaskNames[DataID.FETCH_MAIL_HEADERS] = FetchMailHeadersTask;
            _asyncTaskNames[DataID.FETCH_MAIL_BODIES] = FetchMailBodiesTask;
            _asyncTaskNames[DataID.DELETE_MAILS] = DeleteMailsTask;
            _asyncTaskNames[DataID.FETCH_CLAN_MAIL_HEADERS] = FetchClanMailHeadersTask;
            _asyncTaskNames[DataID.DELETE_CLAN_MAILS] = DeleteClanMailsTask;
            _asyncTaskNames[DataID.MARKET_BUY] = PurchaseItemTask;
            _asyncTaskNames[DataID.PURCHASE_GIFT] = PurchaseGiftTask;
            _asyncTaskNames[DataID.CLAIM_COUPON] = ClaimCouponTask;
            _asyncTaskNames[DataID.TRANSFER_COUPON] = TransferCouponTask;
            _asyncTaskNames[DataID.REDEEM_COUPON] = RedeemCouponTask;
            _asyncTaskNames[DataID.FETCH_MAIL_ATTACHMENTS] = FetchMailAttachmentsTask;
            _asyncTaskNames[DataID.UPDATE_COUPON] = UpdateCouponTask;
            _asyncTaskNames[DataID.REWARD_CONSUME_SUPPLY_DROP] = ConsumeSupplyDropTask;
            _asyncTaskNames[DataID.REWARD_REROLL_CHALLENGE] = RerollChallengeTask;
            _asyncTaskNames[DataID.CLAIM_ONBOARDING_REWARD] = ClaimOnboardingRewardTask;
            _asyncTaskNames[DataID.CREATE_CHARACTER] = CreateUserNameTask;
            _asyncTaskNames[DataID.REDEEM_CHANGE_NAME] = ChangeUserNameTask;
            _asyncTaskNames[DataID.REDEEM_STAT_RESET] = StatResetTask;
         }
         if(id == DataID.NONE || !_asyncTaskNames.hasOwnProperty(id.toString()))
         {
            return null;
         }
         return _asyncTaskNames[id];
      }
   }
}


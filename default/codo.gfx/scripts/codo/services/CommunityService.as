package codo.services
{
   import codo.base.ServiceBase;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.constants.ServiceID;
   import codo.localization.Dict;
   import codo.objects.FriendObj;
   import codo.objects.RecentmetObj;
   import codo.utils.ScaleformUtil;
   
   public class CommunityService extends ServiceBase
   {
      
      private static var _instance:CommunityService;
      
      private var _fakeFriends:Array = [];
      
      private var _fakeRecentPlaymates:Array = [];
      
      private var _fakeBlackList:Array = [];
      
      public function CommunityService()
      {
         super(ServiceID.COMMUNITY);
      }
      
      public static function getInstance() : CommunityService
      {
         if(CommunityService._instance == null)
         {
            CommunityService._instance = new CommunityService();
         }
         return CommunityService._instance;
      }
      
      override public function init() : void
      {
         this.register(DataID.LIST_FRIEND,this.listFriend);
         this.register(DataID.LIST_RECENTPLAYMATE,this.listRecentPlaymate);
         this.register(DataID.PROPOSE_FRIEND_MEMBERSHIP,this.proposeFriendMembership);
         this.register(DataID.LIST_BLACKLIST,this.listBlackList);
      }
      
      private function get fakeFriends() : Array
      {
         var i:int = 0;
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         if(this._fakeFriends.length <= 0)
         {
            i = 0;
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"BBBBBBBBBBBBB332464.2",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"bbbbbbbbbbbbb332464.2",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"L332464",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"刘备",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"mohaha",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"张飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"showtime",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"关羽",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"你是谁？",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"你会飞？",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"Showtime",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"Showtime8",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"a会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"b会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"c会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"d会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends.push(new FriendObj({
               "id":i++,
               "name":"会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeFriends[1].isInRoom = true;
            this._fakeFriends[2].isInRoom = true;
            this._fakeFriends[3].isInRoom = true;
            this._fakeFriends[4].isInRoom = true;
         }
         return this._fakeFriends;
      }
      
      private function get fakeRecentPlaymates() : Array
      {
         var i:int = 0;
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         if(this._fakeRecentPlaymates.length <= 0)
         {
            i = 100;
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rBBBBBBBBBBBBB332464.2",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rbbbbbbbbbbbbb332464.2",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rL332464",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"r刘备",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rmohaha",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"r张飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rshowtime",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"r关羽",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"r你是谁？",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"r你会飞？",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rShowtime",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rShowtime8",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"r会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"ra会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rb会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rc会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"rd会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"r飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
            this._fakeRecentPlaymates.push(new RecentmetObj({
               "id":i++,
               "name":"r会飞的会飞",
               "isOnline":Math.round(i + Math.random()) % 2 == 0
            }));
         }
         return this._fakeRecentPlaymates;
      }
      
      private function get fakeBlackList() : Array
      {
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         this._fakeBlackList.push({
            "name":"laowenchao",
            "id":"06122444"
         });
         this._fakeBlackList.push({
            "name":"jitao",
            "id":"06122445"
         });
         this._fakeBlackList.push({
            "name":"xiaoyuting",
            "id":"06122446"
         });
         this._fakeBlackList.push({
            "name":"gaoyang",
            "id":"06122447"
         });
         return this._fakeBlackList;
      }
      
      public function listFriend(cObj:Object) : void
      {
         this.createTask(DataID.LIST_FRIEND,AsyncTaskGroup.CONTACT,{
            "auto":cObj.auto,
            "type":cObj.type
         },this.fakeFriends);
      }
      
      public function listRecentPlaymate(cObj:Object) : void
      {
         this.createTask(DataID.LIST_RECENTPLAYMATE,AsyncTaskGroup.RECENT,{
            "auto":cObj.auto,
            "type":cObj.type
         },this.fakeRecentPlaymates);
      }
      
      private function proposeFriendMembership(proposal:Object) : void
      {
         showMsg(Dict.FRIEND_PROPOSAL_SENDING);
         this.createTask(DataID.PROPOSE_FRIEND_MEMBERSHIP,AsyncTaskGroup.CONTACT,proposal);
      }
      
      private function listBlackList() : void
      {
         this.createTask(DataID.LIST_BLACKLIST,AsyncTaskGroup.BLACK_LIST,null,this.fakeBlackList);
      }
   }
}


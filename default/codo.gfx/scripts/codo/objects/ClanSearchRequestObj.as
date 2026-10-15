package codo.objects
{
   public class ClanSearchRequestObj
   {
      
      public static const CLAN_SEARCH_TYPE_BEST:int = 1;
      
      public static const CLAN_SEARCH_TYPE_NEW:int = 2;
      
      public static const CLAN_SEARCH_TYPE_NEW_JOINABLE:int = 3;
      
      public static const CLAN_SEARCH_TYPE_BY_NAME:int = 5;
      
      public static const CLAN_SEARCH_TYPE_TENCENT_BEST:int = 6;
      
      public var type:int;
      
      public var isNewSearch:Boolean;
      
      public var keyword:String = "";
      
      public var offset:int;
      
      public var count:int;
      
      public function ClanSearchRequestObj()
      {
         super();
      }
   }
}


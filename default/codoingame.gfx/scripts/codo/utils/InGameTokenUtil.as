package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   
   public class InGameTokenUtil
   {
      
      private static const TOKEN_SPENT_INDEX:uint = 0;
      
      private static const TOKEN_OWNED_INDEX:uint = 1;
      
      private static const TOKEN_RAMPAGE_OWNED_INDEX:uint = 2;
      
      private static const TOKEN_LIMIT_INDEX:uint = 3;
      
      private static const TOKEN_CAN_BUY_INDEX:uint = 4;
      
      private static const TOKEN_RAMPAGE_CAN_BUY_INDEX:uint = 5;
      
      private static const TOKEN_RAMPAGE_CAN_USE_INDEX:uint = 6;
      
      public function InGameTokenUtil()
      {
         super();
      }
      
      private static function GetTokenInfo(index:uint) : uint
      {
         var dvarTokenInfo:String = CFunctionCommonContainer.Dvar_GetString("ui_tok_info");
         var tokenInfo:Array = dvarTokenInfo.split(",");
         if(tokenInfo.length > index + 1)
         {
            return tokenInfo[index];
         }
         return 0;
      }
      
      public static function GetTokenUsed() : uint
      {
         return GetTokenInfo(TOKEN_SPENT_INDEX);
      }
      
      public static function GetTokenOwned() : uint
      {
         return GetTokenInfo(TOKEN_OWNED_INDEX);
      }
      
      public static function GetRampageTokenOwned() : uint
      {
         return GetTokenInfo(TOKEN_RAMPAGE_OWNED_INDEX);
      }
      
      public static function GetTokenUseLimit() : uint
      {
         return GetTokenInfo(TOKEN_LIMIT_INDEX);
      }
      
      public static function CanBuyToken() : Boolean
      {
         return GetTokenInfo(TOKEN_CAN_BUY_INDEX) > 0;
      }
      
      public static function CanBuyRampageToken() : Boolean
      {
         return GetTokenInfo(TOKEN_RAMPAGE_CAN_BUY_INDEX) > 0;
      }
      
      public static function RampageTokenEnabled() : Boolean
      {
         return GetTokenInfo(TOKEN_RAMPAGE_CAN_USE_INDEX) > 0;
      }
      
      public static function GetTokensCanUse() : uint
      {
         return GetTokenUseLimit() - GetTokenUsed();
      }
      
      public static function InGamePurchaseAllowed() : Boolean
      {
         return CFunctionCommonContainer.Dvar_GetBool("ui_allow_ingamepurchase") as Boolean;
      }
   }
}


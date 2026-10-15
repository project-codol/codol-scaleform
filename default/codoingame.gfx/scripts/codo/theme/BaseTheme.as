package codo.theme
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.getDefinitionByName;
   
   public class BaseTheme
   {
      
      public static const THEME_PIECE_CODO_LOGO:int = 0;
      
      public static const THEME_PIECE_PRIMARY_NAVIGATION:int = 1;
      
      public static const THEME_PIECE_SOCIAL_BUTTON_BACKGROUND:int = 2;
      
      public static const THEME_PIECE_CONTROL_PANEL:int = 3;
      
      public static const THEME_PIECE_MAIN_CHAT_PANEL:int = 4;
      
      public static const THEME_PIECE_CHAT_LIST:int = 5;
      
      public static const THEME_PIECE_SPEAK_BUTTON:int = 6;
      
      public static const THEME_PIECE_POPUP:int = 7;
      
      public static const THEME_CONTENT_SIMPLE_BACKGROUND:int = 8;
      
      public static const THEME_WEB_IMAGE_REFRESH_BUTTON:int = 9;
      
      public static const MAX_PIECES:int = 10;
      
      protected var themePieceLinkages:Array;
      
      public function BaseTheme()
      {
         super();
      }
      
      public function getPieceLinkage(themePiece:int) : String
      {
         if(Boolean(this.themePieceLinkages) && themePiece < this.themePieceLinkages.length)
         {
            return this.themePieceLinkages[themePiece];
         }
         return "";
      }
      
      public function getThemePieceLinkages() : Array
      {
         return this.themePieceLinkages;
      }
      
      public function tryApplyThemePiece(originalPiece:DisplayObject, pieceName:int) : void
      {
         var parentContainer:DisplayObjectContainer = null;
         var piece:DisplayObject = this.getThemePiece(pieceName);
         if(Boolean(piece))
         {
            parentContainer = originalPiece.parent;
            if(null != parentContainer)
            {
               parentContainer.addChild(piece);
               parentContainer.swapChildren(originalPiece,piece);
               parentContainer.removeChild(originalPiece);
               parentContainer[originalPiece.name] = piece;
            }
            this.applyOriginalPiecePropery(originalPiece,piece);
         }
      }
      
      protected function getThemePiece(pieceName:int) : DisplayObject
      {
         var definition:Class = null;
         var linkage:String = this.getPieceLinkage(pieceName);
         if(linkage != "")
         {
            definition = getDefinitionByName(linkage) as Class;
            if(null != definition)
            {
               return new definition();
            }
         }
         return null;
      }
      
      protected function applyOriginalPiecePropery(original:DisplayObject, target:DisplayObject) : void
      {
         target.name = original.name;
         target.x = original.x;
         target.y = original.y;
      }
   }
}


package codo.constants
{
   import flash.geom.Point;
   
   public class GameInfo
   {
      
      public static var widthExtra:Number;
      
      public static var heightExtra:Number;
      
      public static const WEB_IMG_ID:String = "web_view_texture";
      
      public static const GAME_FONT_S:String = "FZZongYi-M05S";
      
      public static const GAME_FONT_L:String = "FZLanTingHei-R-GBK";
      
      public static const GAME_FONT_AENCY_FB:String = "Agency FB";
      
      public static const GAME_FONT_AENCY_FB_BOLD:String = "Agency FB";
      
      public static const GAME_FONT_BEBAS:String = "Bebas Neue";
      
      public static const TOP_LEFT:Point = new Point(0,0);
      
      public static const TOP_RIGHT:Point = new Point(1,0);
      
      public static const BOTTOM_LEFT:Point = new Point(0,1);
      
      public static const BOTTOM_RIGHT:Point = new Point(1,1);
      
      public static const TOP_CENTER:Point = new Point(0.5,0);
      
      public static const LEFT_CENTER:Point = new Point(0,0.5);
      
      public static const RIGHT_CENTER:Point = new Point(1,0.5);
      
      public static const BOTTOM_CENTER:Point = new Point(0.5,1);
      
      public static const CENTER:Point = new Point(0.5,0.5);
      
      public static var DEFAULT_WIDTH:uint = 1920;
      
      public static var DEFAULT_HEIGHT:uint = 1080;
      
      public static const GENERAL_STRING_LEN_MAX:uint = 32;
      
      public static const CLANTAG_STRING_LEN_MAX:uint = 4;
      
      public static const MOTTO_MODO_LEN_MAX:uint = 20;
      
      public static var gameWidth:int = DEFAULT_WIDTH;
      
      public static var gameHeight:int = DEFAULT_HEIGHT;
      
      private static var _stageWidth:uint = DEFAULT_WIDTH;
      
      private static var _stageHeight:uint = DEFAULT_HEIGHT;
      
      private static var _stageX:int = 0;
      
      private static var _stageY:int = 0;
      
      public function GameInfo()
      {
         super();
      }
      
      public static function isResolutionChanged() : Boolean
      {
         var isChanged:Boolean = false;
         if(gameWidth != 0 && gameHeight != 0)
         {
            if(gameWidth != DEFAULT_WIDTH || gameHeight != DEFAULT_HEIGHT)
            {
               isChanged = true;
            }
         }
         return isChanged;
      }
      
      public static function setStageSize(w:uint, h:uint) : void
      {
         DEFAULT_WIDTH = w;
         DEFAULT_HEIGHT = h;
         gameWidth = DEFAULT_WIDTH;
         gameHeight = DEFAULT_HEIGHT;
         _stageWidth = DEFAULT_WIDTH;
         _stageHeight = DEFAULT_HEIGHT;
      }
      
      public static function get currentScale() : Number
      {
         return gameWidth / DEFAULT_WIDTH;
      }
      
      public static function updateStageDimensionsForAspectRatio() : void
      {
         var windowAR:Number = gameWidth / gameHeight;
         var scaleformAR:Number = DEFAULT_WIDTH / DEFAULT_HEIGHT;
         if(windowAR > scaleformAR)
         {
            _stageHeight = DEFAULT_HEIGHT;
            _stageWidth = Math.round(_stageHeight * windowAR);
         }
         else if(windowAR < scaleformAR)
         {
            _stageWidth = DEFAULT_WIDTH;
            _stageHeight = Math.round(_stageWidth / windowAR);
         }
         else
         {
            _stageWidth = DEFAULT_WIDTH;
            _stageHeight = DEFAULT_HEIGHT;
         }
         _stageX = 0 - (_stageWidth - DEFAULT_WIDTH) / 2;
         _stageY = 0 - (_stageHeight - DEFAULT_HEIGHT) / 2;
      }
      
      public static function get stageSize() : Point
      {
         return new Point(_stageWidth,_stageHeight);
      }
      
      public static function get stagePosition() : Point
      {
         return new Point(_stageX,_stageY);
      }
      
      public static function getStageCoordForAnchorAndOffset(anchor:Point, offset:Point) : Point
      {
         var stageCoord:Point = new Point();
         stageCoord.x = _stageX + _stageWidth * anchor.x + offset.x;
         stageCoord.y = _stageY + _stageHeight * anchor.y + offset.y;
         return stageCoord;
      }
   }
}


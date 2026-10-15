package codo.component.factory
{
   import codo.component.Breadcrumb;
   import codo.component.CheckBox;
   import codo.component.InputTextField;
   import codo.component.ListHeader;
   import codo.component.ListHeaderToggle;
   import codo.component.TextField;
   import codo.style.TextStyle;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class GlobalFactory
   {
      
      public static const LIST_HEADER_LINKAGE:String = "codo.shared.listHeader";
      
      public static const LIST_HEADER_TOGGLE_LINKAGE:String = "codo.shared.ListHeaderToggle";
      
      public static const TEXTFIELD_LINKAGE:String = "codo.shared.TextField";
      
      public static const CHECKBOX_LINKAGE:String = "codo.shared.CheckBox";
      
      public static const FILTER_OPTION_LINKAGE:String = "codo.shared.FilterOption";
      
      public static const ICON_GP:String = "codo.shared.IconGP";
      
      public static const ICON_CP:String = "codo.shared.IconCP";
      
      public static const ICON_HP:String = "codo.shared.icon_hp";
      
      public static const ICON_EHP:String = "codo.shared.icon_ehp";
      
      public static const ICON_DISABLED:String = "codo.shared.icon_disabled";
      
      public static const INPUT_TEXTFIELD:String = "codo.shared.inputTextField";
      
      public static const BREADCRUMB:String = "codo.shared.Breadcrumb";
      
      public static const BREADCRUMB_END:String = "codo.shared.BreadcrumbEnd";
      
      public function GlobalFactory()
      {
         super();
      }
      
      public static function BUILD_INPUT_TEXT_FIELD(style:TextStyle) : InputTextField
      {
         var cls:Class = getDefinitionByName(INPUT_TEXTFIELD) as Class;
         var itm:InputTextField = new cls() as InputTextField;
         itm.textStyle = style;
         return itm;
      }
      
      public static function BUILD_ICON_GP(width:uint, iconStartPos:Point = null) : Sprite
      {
         var itm:Sprite = null;
         var cls:Class = getDefinitionByName(ICON_GP) as Class;
         itm = new cls() as Sprite;
         itm.width = width;
         itm.scaleY = itm.scaleX;
         if(Boolean(iconStartPos))
         {
            itm.x = iconStartPos.x;
            itm.y = iconStartPos.y;
         }
         return itm;
      }
      
      public static function BUILD_ICON_DISABLED(width:int = -1) : Sprite
      {
         var cls:Class = getDefinitionByName(ICON_DISABLED) as Class;
         var itm:Sprite = new cls() as Sprite;
         if(width > 0)
         {
            itm.width = width;
            itm.scaleY = itm.scaleX;
         }
         return itm;
      }
      
      public static function BUILD_ICON_CP(height:uint, iconStartPos:Point = null) : Sprite
      {
         var itm:Sprite = null;
         var cls:Class = getDefinitionByName(ICON_CP) as Class;
         itm = new cls() as Sprite;
         itm.height = height;
         itm.scaleX = itm.scaleY;
         if(Boolean(iconStartPos))
         {
            itm.x = iconStartPos.x;
            itm.y = iconStartPos.y;
         }
         return itm;
      }
      
      public static function BUILD_LIST_HEADER() : ListHeader
      {
         var cls:Class = getDefinitionByName(LIST_HEADER_LINKAGE) as Class;
         return new cls() as ListHeader;
      }
      
      public static function BUILD_LIST_HEADER_TOGGLE() : ListHeaderToggle
      {
         var cls:Class = getDefinitionByName(LIST_HEADER_TOGGLE_LINKAGE) as Class;
         return new cls() as ListHeaderToggle;
      }
      
      public static function BUILD_TEXTFIELD() : TextField
      {
         var cls:Class = getDefinitionByName(TEXTFIELD_LINKAGE) as Class;
         return new cls() as TextField;
      }
      
      public static function BUILD_CHECKBOX() : CheckBox
      {
         var cls:Class = getDefinitionByName(CHECKBOX_LINKAGE) as Class;
         return new cls() as CheckBox;
      }
      
      public static function BUILD_BREADCRUMB() : Breadcrumb
      {
         var cls:Class = getDefinitionByName(BREADCRUMB) as Class;
         return new cls() as Breadcrumb;
      }
      
      public static function BUILD_BREADCRUMB_END() : Breadcrumb
      {
         var cls:Class = getDefinitionByName(BREADCRUMB_END) as Class;
         return new cls() as Breadcrumb;
      }
      
      public static function BUILD_ICON_HP(height:uint) : Sprite
      {
         var cls:Class = getDefinitionByName(ICON_HP) as Class;
         var itm:Sprite = new cls();
         itm.height = height;
         itm.scaleX = itm.scaleY;
         return itm;
      }
      
      public static function BUILD_ICON_EHP(height:uint) : Sprite
      {
         var cls:Class = getDefinitionByName(ICON_EHP) as Class;
         var itm:Sprite = new cls();
         itm.height = height;
         itm.scaleX = itm.scaleY;
         return itm;
      }
   }
}


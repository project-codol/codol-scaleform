package codo.cpp
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.ProductObj;
   import flash.utils.Dictionary;
   
   public dynamic class UiCppNewItems extends UiCpp
   {
      
      private static var _instance:UiCppNewItems;
      
      public static var CPP_TYPE:uint;
      
      public static const CRUMB_STREAKS:uint = 0;
      
      public static const CRUMB_CHARACTERS:uint = 1;
      
      public static const CRUMB_PERKS_1:uint = 2;
      
      public static const CRUMB_PERKS_2:uint = 3;
      
      public static const CRUMB_PERKS_3:uint = 4;
      
      public static const CRUMB_PERKS:uint = 5;
      
      public static const CRUMB_WILDCARDS:uint = 6;
      
      public static const CRUMB_LETHALS:uint = 7;
      
      public static const CRUMB_TACTICALS:uint = 8;
      
      public static const CRUMB_EQUIPMENT:uint = 9;
      
      public static const CRUMB_ASSAULT_RIFLES:uint = 10;
      
      public static const CRUMB_SMGS:uint = 11;
      
      public static const CRUMB_LMGS:uint = 12;
      
      public static const CRUMB_SNIPERS:uint = 13;
      
      public static const CRUMB_SHOTGUNS:uint = 14;
      
      public static const CRUMB_OTHER_PRIMARIES:uint = 15;
      
      public static const CRUMB_PRIMARIES:uint = 16;
      
      public static const CRUMB_PISTOLS:uint = 17;
      
      public static const CRUMB_MACHINE_PISTOLS:uint = 18;
      
      public static const CRUMB_LAUNCHERS:uint = 19;
      
      public static const CRUMB_OTHER_SECONDARIES:uint = 20;
      
      public static const CRUMB_SECONDARIES:uint = 21;
      
      public static const CRUMB_HEADGEAR:uint = 22;
      
      public static const CRUMB_EYEWEAR:uint = 23;
      
      public static const CRUMB_JACKETS:uint = 24;
      
      public static const CRUMB_VESTS:uint = 25;
      
      public static const CRUMB_TATTOOS:uint = 26;
      
      public static const CRUMB_GLOVES:uint = 27;
      
      public static const CRUMB_PANTS:uint = 28;
      
      public static const CRUMB_EMOTES:uint = 29;
      
      public static const CRUMB_GEAR:uint = 30;
      
      public static const CRUMB_NAME_TOKENS:uint = 31;
      
      public static const CRUMB_CARD_BKGS:uint = 32;
      
      public static const CRUMB_CARD_TITLES:uint = 33;
      
      public static const CRUMB_CARD_EMBLEMS:uint = 34;
      
      public static const CRUMB_PLAYERCARD:uint = 35;
      
      public static const CRUMB_BADGES:uint = 36;
      
      public static const CRUMB_TOKENS:uint = 37;
      
      public static const CRUMB_ADV_TOKENS:uint = 38;
      
      public static const CRUMB_REQUISITIONS:uint = 39;
      
      public static const CRUMB_COMBAT_KNIFE:uint = 40;
      
      public static const CRUMB_LOADOUT:uint = 41;
      
      public static const CRUMB_INVENTORY:uint = 42;
      
      public static const CRUMB_LOBBY_INVENTORY:uint = 43;
      
      public static const CRUMB_LOBBY_LOADOUT:uint = 44;
      
      public static const CRUMB_STREAKS_STANDARD:uint = 45;
      
      public static const CRUMB_STREAKS_PRO:uint = 46;
      
      public static const CRUMB_CARD_NAMEPLATE:uint = 47;
      
      public static const CRUMB_MELEES:uint = 48;
      
      public static const CRUMB_NONE_MELEES:uint = 49;
      
      public static const CRUMB_SHARDS:uint = 50;
      
      public static const CRUMB_CARD_FRAMES:uint = 51;
      
      public static const CRUMB_NULL:uint = 52;
      
      private var _componentTypes:Dictionary = new Dictionary(true);
      
      public function UiCppNewItems()
      {
         super();
         CFunctionCommonContainer.Assert(_instance == null,new Error("Multiple UiCppNewItems instances"));
         _instance = this;
      }
      
      public static function get instance() : UiCppNewItems
      {
         return _instance;
      }
      
      public function ClearNew(item:ProductObj) : void
      {
         this["AS_ClearNew"](item);
      }
      
      public function InitBreadcrumb(component:UIInteractiveComponent, type:uint, x:Number = NaN, y:Number = NaN) : void
      {
         if(type == CRUMB_NULL)
         {
            delete this._componentTypes[component];
            if(component.getBreadcrumb() != null)
            {
               component.getBreadcrumb().visible = false;
            }
         }
         else
         {
            this._componentTypes[component] = type;
            if(component.getBreadcrumb() == null)
            {
               component.addBreadcrumb(x,y,false);
            }
            this.RefreshCrumb(component,type);
         }
      }
      
      public function GetCrumbState(type:uint) : Boolean
      {
         return this["AS_GetCrumbState"](type);
      }
      
      public function CPP_RefreshCrumbs() : void
      {
         var key:Object = null;
         var component:UIInteractiveComponent = null;
         for(key in this._componentTypes)
         {
            component = key as UIInteractiveComponent;
            this.RefreshCrumb(component,this._componentTypes[component]);
         }
      }
      
      private function RefreshCrumb(component:UIInteractiveComponent, type:uint) : void
      {
         component.getBreadcrumb().visible = this.GetCrumbState(type);
      }
      
      public function CPP_GetCrumbHeirarchy() : Array
      {
         var perks:Object = this.MakeObj(CRUMB_PERKS,[CRUMB_PERKS_1,CRUMB_PERKS_2,CRUMB_PERKS_3]);
         var primaries:Object = this.MakeObj(CRUMB_PRIMARIES,[CRUMB_ASSAULT_RIFLES,CRUMB_SMGS,CRUMB_LMGS,CRUMB_SNIPERS,CRUMB_SHOTGUNS,CRUMB_OTHER_PRIMARIES]);
         var secondaries:Object = this.MakeObj(CRUMB_SECONDARIES,[CRUMB_PISTOLS,CRUMB_MACHINE_PISTOLS,CRUMB_LAUNCHERS]);
         var melees:Object = this.MakeObj(CRUMB_MELEES,[CRUMB_OTHER_SECONDARIES,CRUMB_COMBAT_KNIFE]);
         var equipment:Object = this.MakeObj(CRUMB_EQUIPMENT,[CRUMB_LETHALS,CRUMB_TACTICALS]);
         var noneMelees:Object = this.MakeObj(CRUMB_NONE_MELEES,[primaries,secondaries]);
         var loadout:Object = this.MakeObj(CRUMB_LOADOUT,[noneMelees,melees,perks,equipment,CRUMB_WILDCARDS,CRUMB_CHARACTERS]);
         var lobbyLoadout:Object = this.MakeObj(CRUMB_LOBBY_LOADOUT,[primaries,secondaries,melees,perks,equipment,CRUMB_WILDCARDS]);
         var gear:Object = this.MakeObj(CRUMB_GEAR,[CRUMB_EMOTES,CRUMB_HEADGEAR,CRUMB_EYEWEAR,CRUMB_JACKETS,CRUMB_VESTS,CRUMB_PANTS,CRUMB_GLOVES,CRUMB_TATTOOS]);
         var playercard:Object = this.MakeObj(CRUMB_PLAYERCARD,[CRUMB_CARD_BKGS,CRUMB_CARD_TITLES,CRUMB_CARD_FRAMES,CRUMB_CARD_EMBLEMS,CRUMB_CARD_NAMEPLATE,CRUMB_NAME_TOKENS]);
         var requis:Object = this.MakeObj(CRUMB_REQUISITIONS,[CRUMB_BADGES,CRUMB_TOKENS,CRUMB_ADV_TOKENS,CRUMB_SHARDS]);
         var streaks:Object = this.MakeObj(CRUMB_STREAKS,[CRUMB_STREAKS_STANDARD,CRUMB_STREAKS_PRO]);
         return [this.MakeObj(CRUMB_INVENTORY,[loadout,requis,streaks,gear,playercard]),this.MakeObj(CRUMB_LOBBY_INVENTORY,[lobbyLoadout,requis,streaks,gear])];
      }
      
      private function MakeObj(id:uint, children:Array) : Object
      {
         return {
            "id":id,
            "children":children
         };
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
   }
}


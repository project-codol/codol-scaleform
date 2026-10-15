package codo.objects
{
   public class RecommendationObject
   {
      
      public static const WELFARE:int = 1;
      
      public static const REWARD:int = 2;
      
      public static const GAMEMODE:int = 3;
      
      public static const MARKET:int = 4;
      
      public static const SUPPLY_DROP:int = 5;
      
      public static const RAW_WEB:int = 6;
      
      public var type:int;
      
      public var taskid:int;
      
      public var title:String;
      
      public var subtitle:String;
      
      public var imagejump:String;
      
      public var buttontext:String;
      
      public var buttondata:String;
      
      public function RecommendationObject(object:Object)
      {
         super();
         this.type = object.type;
         this.taskid = object.taskid;
         this.title = object.title;
         this.subtitle = object.subtitle;
         this.imagejump = object.imagejump;
         this.buttontext = object.buttontext;
         this.buttondata = object.buttondata;
      }
   }
}


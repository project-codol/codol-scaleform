package codo.views.wargod_parts
{
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   
   public interface IWarGodUIElement
   {
      
      function setData(param1:WarGodSeasonObj, param2:WarGodPlayerObj, param3:WarGodGlobalSettingObj) : void;
   }
}


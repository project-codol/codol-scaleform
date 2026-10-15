package components.ingameaar_part
{
   import codo.localization.DictInGame;
   import flash.text.TextField;
   import shaui.component.core.UIComponent;
   
   public class AARXPModItem extends UIComponent
   {
      
      public static const TYPE_AAS:int = 0;
      
      public static const TYPE_LEAGUE:int = 1;
      
      public var myTextTF:TextField;
      
      public function AARXPModItem()
      {
         super();
      }
      
      public function SetModType(type:int) : void
      {
         var text:String = null;
         if(type == TYPE_AAS)
         {
            text = DictInGame.XP_MODIFIER_AAS;
         }
         else if(type == TYPE_LEAGUE)
         {
            text = DictInGame.XP_MODIFIER_LEAGUE;
         }
         this.myTextTF.text = text;
      }
   }
}


package components.asym
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import fsg.shared.InputIconUtility;
   import fsg.util.FsgImageHolder;
   
   public class AsymAbilityListItem extends Sprite
   {
      
      private static const ICON_SCALE_FACTOR:Number = 0.75;
      
      public var myNameTF:TextField;
      
      public var myDescTF:TextField;
      
      public var myAbilityImage:FsgImageHolder;
      
      public var myKeyHolder:Sprite;
      
      public function AsymAbilityListItem()
      {
         super();
      }
      
      public function addKeyIcon() : InputIconUtility
      {
         var cls:Class = getDefinitionByName("fsg.widgets.inputIconUtility") as Class;
         var abilityKey:InputIconUtility = this.myKeyHolder.addChild(new cls()) as InputIconUtility;
         abilityKey.setImageScale(ICON_SCALE_FACTOR);
         return abilityKey;
      }
   }
}


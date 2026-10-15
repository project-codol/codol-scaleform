package codo.objects
{
   public class OnboardCharacterOptionObj
   {
      
      public var index:uint;
      
      public var characterItemSKU:int;
      
      public var characterDepth:uint;
      
      public var characterName:String;
      
      public var characterCodeName:String;
      
      public var characterSlogan:String;
      
      public var characterVO:String;
      
      public var characterBio:String;
      
      public var characterVitals:String;
      
      public var characterImageClassPath:Class;
      
      public var characterDetailImageClassPath:Class;
      
      public var characterImageURL:String;
      
      public function OnboardCharacterOptionObj(characterItemSKU:int, characterName:String, characterCodeName:String, characterSlogan:String, characterBio:String, characterVitals:String, characterImageClassPath:Class, characterDetailImageClassPath:Class = null, characterDepth:uint = 0, characterVO:String = null, characterImageURL:String = null)
      {
         super();
         this.characterItemSKU = characterItemSKU;
         this.characterName = characterName;
         this.characterCodeName = characterCodeName;
         this.characterSlogan = characterSlogan;
         this.characterBio = characterBio;
         this.characterVitals = characterVitals;
         this.characterImageClassPath = characterImageClassPath;
         this.characterDetailImageClassPath = characterDetailImageClassPath;
         this.characterDepth = characterDepth;
         this.characterVO = characterVO;
         this.characterImageURL = characterImageURL;
      }
   }
}


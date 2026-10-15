package components.ingameaar_part
{
   import codo.localization.DictInGame;
   import components.BaseButton;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class AARXPModBtn extends BaseButton
   {
      
      public var myTextTF:TextField;
      
      public function AARXPModBtn()
      {
         super();
      }
      
      public function SetIsReduction(isReduction:Boolean) : void
      {
         if(isReduction)
         {
            this.transform.colorTransform = new ColorTransform(1,0,0);
            this.myTextTF.text = DictInGame.XP_REDUCED;
         }
         else
         {
            this.transform.colorTransform = new ColorTransform(0.4,1,0);
            this.myTextTF.text = DictInGame.XP_BOOSTED;
         }
      }
   }
}


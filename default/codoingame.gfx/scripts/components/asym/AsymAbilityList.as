package components.asym
{
   import codo.objects.AsymPvpLoadoutObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   import fsg.shared.InputIconUtility;
   
   public class AsymAbilityList extends Sprite
   {
      
      public var myMeleeAttack:AsymAbilityListItem;
      
      public var myAbility0:AsymAbilityListItem;
      
      public var myAbility1:AsymAbilityListItem;
      
      public var myAbility2:AsymAbilityListItem;
      
      private var mMeleeKey:InputIconUtility;
      
      private var mAbility0Key:InputIconUtility;
      
      private var mAbility1Key:InputIconUtility;
      
      private var mAbility2Key:InputIconUtility;
      
      public function AsymAbilityList()
      {
         super();
      }
      
      public function setKeys() : void
      {
         if(!this.mMeleeKey || !this.mAbility0Key || !this.mAbility1Key || !this.mAbility2Key)
         {
            if(null != this.myMeleeAttack)
            {
               this.mMeleeKey = this.myMeleeAttack.addKeyIcon();
            }
            this.mAbility0Key = this.myAbility0.addKeyIcon();
            this.mAbility1Key = this.myAbility1.addKeyIcon();
            this.mAbility2Key = this.myAbility2.addKeyIcon();
         }
      }
      
      public function setData(data:AsymPvpLoadoutObj) : void
      {
         if(ScaleformUtil.isScaleform)
         {
            if(null != this.myMeleeAttack)
            {
               this.myMeleeAttack.myNameTF.text = LocalizeUtil.localize(data.meleeAbilityName);
               this.myMeleeAttack.myDescTF.text = LocalizeUtil.localize(data.meleeAbilityDesc);
               this.myMeleeAttack.myAbilityImage.setImage(data.meleeAbilityIcon);
               this.mMeleeKey.setForCommand("+attack",16777215);
            }
            this.myAbility0.myNameTF.text = LocalizeUtil.localize(data.firstAbilityName);
            this.myAbility0.myDescTF.text = LocalizeUtil.localize(data.firstAbilityDesc);
            this.myAbility0.myAbilityImage.setImage(data.firstAbilityIcon);
            this.mAbility0Key.setForCommand("+toggleads_throw",16777215);
            this.myAbility1.myNameTF.text = LocalizeUtil.localize(data.secondAbilityName);
            this.myAbility1.myDescTF.text = LocalizeUtil.localize(data.secondAbilityDesc);
            this.myAbility1.myAbilityImage.setImage(data.secondAbilityIcon);
            this.mAbility1Key.setForCommand("+tact",16777215);
            this.myAbility2.myNameTF.text = LocalizeUtil.localize(data.thirdAbilityName);
            this.myAbility2.myDescTF.text = LocalizeUtil.localize(data.thirdAbilityDesc);
            this.myAbility2.myAbilityImage.setImage(data.thirdAbilityIcon);
            this.mAbility2Key.setForCommand("+reload",16777215);
         }
      }
   }
}


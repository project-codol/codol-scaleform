package codo.component.lobby
{
   import codo.common.CFunctionInGameContainer;
   import codo.objects.ZombieChampionAttrObj;
   import codo.objects.ZombieChampionObj;
   import codo.views.hudZombieArena.ZombieChampionSkillMeter;
   import flash.text.TextField;
   
   public class ZombieChampionDetailInGame extends ZombieChampionDetailPanel
   {
      
      public var myAttributesTitle:TextField;
      
      public var myAttribute0:ZombieChampionSkillMeter;
      
      public var myAttribute1:ZombieChampionSkillMeter;
      
      public var myAttribute2:ZombieChampionSkillMeter;
      
      public var myAttribute3:ZombieChampionSkillMeter;
      
      private var mAttributeClips:Vector.<ZombieChampionSkillMeter>;
      
      private var mNumAttributeClips:uint;
      
      public function ZombieChampionDetailInGame()
      {
         var attributes:Vector.<ZombieChampionAttrObj> = null;
         super();
         this.mAttributeClips = new <ZombieChampionSkillMeter>[this.myAttribute0,this.myAttribute1,this.myAttribute2,this.myAttribute3];
         this.mNumAttributeClips = this.mAttributeClips.length;
         attributes = CFunctionInGameContainer.AS_ZChampGetAttributeInfo();
         var numAttributes:uint = attributes.length;
         for(var i:uint = 0; i < this.mNumAttributeClips; i++)
         {
            if(i < numAttributes)
            {
               this.mAttributeClips[i].initData(attributes[i],true);
            }
            else
            {
               this.mAttributeClips[i].visible = false;
            }
         }
         this.myAttributesTitle.text = "@UI_HUD_ZOMBIE_CHAMPIONS_SKILLS_LABEL";
      }
      
      override public function show(champion:ZombieChampionObj) : void
      {
         var allocations:Array = null;
         var upgrades:Array = null;
         super.show(champion);
         allocations = CFunctionInGameContainer.AS_ZChampGetAttributeAllocations();
         var numAttributes:uint = allocations.length;
         for(var i:uint = 0; i < this.mNumAttributeClips; i++)
         {
            if(this.mAttributeClips[i].visible)
            {
               this.mAttributeClips[i].setValue(i < numAttributes ? int(allocations[i]) : 0,0);
            }
         }
         upgrades = CFunctionInGameContainer.AS_ZChampGetUpgrades();
         var numUpgrades:uint = upgrades.length;
         for(i = 0; i < mNumSkillClips; i++)
         {
            if(mSkillClips[i].visible)
            {
               mSkillClips[i].setUpgrade(i < numUpgrades ? upgrades[i] : "");
            }
         }
      }
   }
}


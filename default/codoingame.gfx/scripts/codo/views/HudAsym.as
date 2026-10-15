package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import codo.objects.AsymPvpLoadoutObj;
   import codo.utils.AsymPvpUtil;
   import codo.utils.ShoutcastUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudAsym extends BaseView
   {
      
      public var myView:MovieClip;
      
      public var myCaptureBar:MovieClip;
      
      public var myRightContainer:MovieClip;
      
      public var myWeaponMod:MovieClip;
      
      public var myBeaconOnlineTimerTF:TextField;
      
      public var mySpiderBombTimer:MovieClip;
      
      public var robotContainer:MovieClip;
      
      public var humanContainer:MovieClip;
      
      public var centerX:Number;
      
      public var centerY:Number;
      
      public function HudAsym()
      {
         super();
      }
      
      override public function init() : void
      {
         trace("HudAsym::init()");
         super.init();
      }
      
      override protected function showView() : void
      {
         var stageSize:Point = null;
         var stagePosition:Point = null;
         trace("HudAsym::showView()");
         super.showView();
         visible = false;
         this.myRightContainer = this.robotContainer.myRightContainer;
         this.myWeaponMod = this.humanContainer.myWeaponMod;
         stageSize = GameInfo.stageSize;
         stagePosition = GameInfo.stagePosition;
         this.robotContainer.x = stagePosition.x + (stageSize.x - GameInfo.DEFAULT_WIDTH);
         this.robotContainer.y = stagePosition.y + (stageSize.y - GameInfo.DEFAULT_HEIGHT);
         this.humanContainer.x = stagePosition.x + (stageSize.x - GameInfo.DEFAULT_WIDTH);
         this.humanContainer.y = stagePosition.y + (stageSize.y - GameInfo.DEFAULT_HEIGHT);
         this.centerX = GameInfo.DEFAULT_WIDTH / 2 - (stagePosition.x + (stageSize.x - GameInfo.DEFAULT_WIDTH));
         this.centerY = GameInfo.DEFAULT_HEIGHT / 2 - (stagePosition.y + (stageSize.y - GameInfo.DEFAULT_HEIGHT));
         this.myRightContainer.myAbility1.myKeyBinding.setForCommand("+toggleads_throw",16777215);
         this.myRightContainer.myAbility2.myKeyBinding.setForCommand("+tact",16777215);
         this.myRightContainer.myAbility3.myKeyBinding.setForCommand("+reload",16777215);
         this.myRightContainer.myAbility1.myKeyBinding.setImageScale(0.6);
         this.myRightContainer.myAbility2.myKeyBinding.setImageScale(0.6);
         this.myRightContainer.myAbility3.myKeyBinding.setImageScale(0.6);
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_Asym,this);
         ShoutcastUtil.getInstance().registerView(this);
         this.myWeaponMod.weaponModSlot1.iconName.visible = false;
         this.myWeaponMod.weaponModSlot1.iconDesc.visible = false;
         this.myWeaponMod.weaponModSlot2.iconName.visible = false;
         this.myWeaponMod.weaponModSlot2.iconDesc.visible = false;
      }
      
      override protected function hideView() : void
      {
         trace("HudAsym::hideView()");
         super.hideView();
      }
      
      public function refreshVisuals(speciesName:String) : void
      {
         trace("HudAsym::refreshVisuals - speciesName = " + speciesName);
         var loadout:AsymPvpLoadoutObj = AsymPvpUtil.instance.getLoadoutBySpeciesName(speciesName);
         var image:FsgImageHolder = this.myRightContainer.myAbility1.myAbilityImage;
         trace("loadout.firstAbilityIcon = " + loadout.firstAbilityIcon);
         image.setImage(loadout.firstAbilityIcon);
         image = this.myRightContainer.myAbility2.myAbilityImage;
         trace("loadout.secondAbilityIcon = " + loadout.secondAbilityIcon);
         image.setImage(loadout.secondAbilityIcon);
         image = this.myRightContainer.myAbility3.myAbilityImage;
         trace("loadout.thirdAbilityIcon = " + loadout.thirdAbilityIcon);
         image.setImage(loadout.thirdAbilityIcon);
         var cornerImage:String = loadout.image + "_corner_icon";
         trace("cornerImage = " + cornerImage);
         this.myRightContainer.myCornerImage.setImage(cornerImage);
      }
      
      public function refreshVisualsWeaponLevel(slot:int, levelIcon:int, weaponType:int) : void
      {
         var slotMC:MovieClip = null;
         var nameMv:MovieClip = null;
         var descMv:MovieClip = null;
         var image:FsgImageHolder = null;
         if(slot == 0)
         {
            slotMC = this.myWeaponMod.weaponModSlot1;
            nameMv = this.myWeaponMod.weaponModSlot1.iconName;
            descMv = this.myWeaponMod.weaponModSlot1.iconDesc;
         }
         else if(slot == 1)
         {
            slotMC = this.myWeaponMod.weaponModSlot2;
            nameMv = this.myWeaponMod.weaponModSlot2.iconName;
            descMv = this.myWeaponMod.weaponModSlot2.iconDesc;
         }
         if(levelIcon == -1 && weaponType == -1)
         {
            slotMC.visible = false;
         }
         else
         {
            slotMC.visible = true;
            image = slotMC.myAbilityImage;
            if(levelIcon == -1)
            {
               image.setImage(AsymPvpUtil.instance.getWeaponUpgradeModImage(weaponType));
               nameMv.theText.text = AsymPvpUtil.instance.getWeaponUpgradeModName(weaponType);
               descMv.theText.text = AsymPvpUtil.instance.getWeaponUpgradeModDesc(weaponType);
               nameMv.visible = true;
            }
            else
            {
               image.setImage(AsymPvpUtil.instance.getWeaponUpgradeLevelIcon(levelIcon));
               nameMv.visible = false;
               descMv.visible = false;
            }
         }
      }
   }
}


package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import codo.localization.DictTD;
   import codo.utils.ScaleformUtil;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class FsgHelpMenuTDView extends BaseView
   {
      
      public var myDescAmmoEquipment:TextField;
      
      public var myLabelAmmoEquipment:TextField;
      
      public var myDescWeapon:TextField;
      
      public var myLabelWeapon:TextField;
      
      public var myDescLifeMoneyTurret:TextField;
      
      public var myLabelLifeMoneyTurret:TextField;
      
      public var myDescRank:TextField;
      
      public var myLabelRank:TextField;
      
      public var myDescMapBase:TextField;
      
      public var myLableMapBase:TextField;
      
      public function FsgHelpMenuTDView()
      {
         super();
         this.myDescAmmoEquipment.text = DictTD.HELP_DESC_AMMO;
         this.myLabelAmmoEquipment.text = DictTD.HELP_LABEL_AMMO;
         this.myDescWeapon.text = DictTD.HELP_DESC_WEAPON;
         this.myLabelWeapon.text = DictTD.HELP_LABEL_WEAPON;
         this.myDescLifeMoneyTurret.text = DictTD.HELP_DESC_HP_MONEY_TURRET;
         this.myLabelLifeMoneyTurret.text = DictTD.HELP_LABEL_HP_MONEY_TURRET;
         this.myDescRank.text = DictTD.HELP_DESC_RANK;
         this.myLabelRank.text = DictTD.HELP_LABEL_RANK;
         this.myDescMapBase.text = DictTD.HELP_DESC_BASE_MAP;
         this.myLableMapBase.text = DictTD.HELP_LABEL_BASE_MAP;
      }
      
      override protected function showView() : void
      {
         var stageSize:Point = null;
         var scaledHeight:Number = NaN;
         var turret:Object = null;
         var turretName:TextField = null;
         super.showView();
         stageSize = new Point(1280,960);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         var scale:Number = stageSize.x / this.width;
         scaledHeight = this.height * scale;
         var yOff:Number = (scaledHeight - stageSize.y) / 2;
         this.x = stagePosition.x;
         this.y = stagePosition.y - yOff;
         this.width = stageSize.x;
         this.height = scaledHeight;
         var turrets:Array = CFunctionInGameContainer.AS_TD_GetTurretList();
         for each(turret in turrets)
         {
            turretName = getChildByName("myTurretName".concat(turret.id)) as TextField;
            turretName.text = "@" + turret.name;
         }
      }
   }
}


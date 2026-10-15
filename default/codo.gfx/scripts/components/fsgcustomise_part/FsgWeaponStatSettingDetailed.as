package components.fsgcustomise_part
{
   import codo.objects.WeaponBasicStatObj;
   import codo.objects.WeaponStatsObj;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class FsgWeaponStatSettingDetailed extends MovieClip
   {
      
      public var myDamage:MovieClip;
      
      public var myRange:MovieClip;
      
      public var myRecoil:MovieClip;
      
      public var myCenteringSpeed:MovieClip;
      
      public var myBulletSpread:MovieClip;
      
      public var myMobility:MovieClip;
      
      private var myStatInfo:Vector.<MovieClip>;
      
      public var myAttribute0:MovieClip;
      
      public var myAttribute1:MovieClip;
      
      public var myAttribute2:MovieClip;
      
      public function FsgWeaponStatSettingDetailed()
      {
         super();
         this.myStatInfo = new <MovieClip>[this.myDamage,this.myRange,this.myRecoil,this.myCenteringSpeed,this.myBulletSpread,this.myMobility];
         if(ScaleformUtil.isScaleform)
         {
            this.onResetValues();
         }
      }
      
      private static function PercentToFraction(nPercent:Number) : Number
      {
         return nPercent / 100;
      }
      
      private function populateFireType(statsData:Object, fireTypePanel:MovieClip) : void
      {
         if(fireTypePanel != null)
         {
            fireTypePanel.gotoAndStop(1);
            fireTypePanel.visible = true;
            fireTypePanel.myAttributeTitle.myTextTF.text = "@SF_WEAPON_FIRETYPE";
            fireTypePanel.myAttributeValue.myTextTF.text = statsData.clipsize > 0 ? statsData.firetype : "@SF_UI_NOT_APPLICABLE";
            fireTypePanel.myAttributeText.visible = false;
         }
      }
      
      private function populateRoundsPerSec(statsData:Object, rpsPanel:MovieClip, showAttachmentModifiers:Boolean = false) : void
      {
         var baseRPS:Number = NaN;
         var clipSize:int = 0;
         if(rpsPanel != null)
         {
            baseRPS = Number(statsData.rps);
            clipSize = int(statsData.clipsize);
            rpsPanel.visible = true;
            rpsPanel.myAttributeTitle.myTextTF.text = "@SF_WEAPON_FIRERATE";
            rpsPanel.gotoAndStop(1);
            rpsPanel.myAttributeValue.myTextTF.text = clipSize > 0 ? baseRPS.toFixed(2) : "@SF_UI_NOT_APPLICABLE";
            rpsPanel.myAttributeText.myTextTF.text = clipSize > 0 ? "@SF_WEAPON_ROUNDSPERSEC" : "";
         }
      }
      
      private function populateClipSize(statsData:Object, clipSizePanel:MovieClip, showAttachmentModifiers:Boolean = false) : void
      {
         var baseClipSize:int = 0;
         var modClipSize:int = 0;
         if(clipSizePanel != null)
         {
            baseClipSize = int(statsData.clipsize);
            clipSizePanel.visible = true;
            clipSizePanel.myAttributeTitle.myTextTF.text = "@SF_WEAPON_CLIPSIZE";
            if(showAttachmentModifiers)
            {
               modClipSize = int(statsData.modclipsize);
               if(baseClipSize == modClipSize)
               {
                  clipSizePanel.gotoAndStop(1);
                  clipSizePanel.myAttributeValue.myTextTF.text = baseClipSize > 0 ? String(baseClipSize) : "@SF_UI_NOT_APPLICABLE";
               }
               else
               {
                  clipSizePanel.gotoAndStop(baseClipSize > modClipSize ? 3 : 2);
                  clipSizePanel.myAttributeValue.myTextTF.text = String(modClipSize);
               }
            }
            else
            {
               clipSizePanel.gotoAndStop(1);
               clipSizePanel.myAttributeValue.myTextTF.text = baseClipSize > 0 ? String(baseClipSize) : "@SF_UI_NOT_APPLICABLE";
            }
            clipSizePanel.myAttributeText.myTextTF.text = baseClipSize > 0 ? "@SF_WEAPON_ROUNDS" : "";
         }
      }
      
      private function populateHeader(statsData:Object, fireTypePanel:MovieClip, rpsPanel:MovieClip, clipSizePanel:MovieClip, showAttachmentModifiers:Boolean = false) : void
      {
         this.populateFireType(statsData,fireTypePanel);
         this.populateRoundsPerSec(statsData,rpsPanel,false);
         this.populateClipSize(statsData,clipSizePanel,showAttachmentModifiers);
      }
      
      public function populateCustomization(statsObject:Object) : void
      {
         this.onResetValues();
         this.populateHeader(statsObject.properties,this.myAttribute0,this.myAttribute1,this.myAttribute2,true);
         this.showModifiedStats(statsObject.properties);
      }
      
      public function populateToolTip(statsObject:Object, fireTypeClip:MovieClip, rpsClip:MovieClip, clipSizeClip:MovieClip, isEquipped:Boolean) : void
      {
         var stat:Object = null;
         this.onResetValues();
         this.populateHeader(statsObject.properties,fireTypeClip,rpsClip,clipSizeClip,false);
         var iHighest:int = 0;
         var statsObj:WeaponStatsObj = statsObject.properties;
         var basicStats:Array = statsObj.stats;
         for(var i:int = 0; i < basicStats.length; i++)
         {
            if(basicStats[i].base > iHighest)
            {
               iHighest = int(basicStats[i].base);
            }
         }
         for(var j:int = 0; j < basicStats.length; j++)
         {
            stat = basicStats[j];
            this.setStatValue(j,stat.base);
            this.setStatName(j,stat.name || "");
         }
      }
      
      public function populatePurchaseConfirm(statsObject:Object) : void
      {
         var i:uint = 0;
         var statObj:WeaponBasicStatObj = null;
         var tVal:Number = NaN;
         this.onResetValues();
         this.populateHeader(statsObject.properties,this.myAttribute0,this.myAttribute1,this.myAttribute2);
         var statsObj:WeaponStatsObj = statsObject.properties;
         var mValArray:Array = new Array();
         if(statsObj != null)
         {
            for(i = 0; i < statsObj.stats.length; i++)
            {
               statObj = statsObj.stats[i] as WeaponBasicStatObj;
               tVal = statObj.value;
               mValArray[i] = tVal;
               this.setStatValue(i,tVal);
               this.setStatName(i,statObj.name || "");
               this.setMaxValue(i,0);
            }
         }
      }
      
      private function showModifiedStats(statArray:Array) : void
      {
         var i:uint = 0;
         var stat:Object = null;
         if(statArray != null)
         {
            for(i = 0; i < statArray.length; i++)
            {
               stat = statArray[i];
               this.setStatName(i,stat.name || "");
               this.setStatDifValue(i,stat.base,stat.value);
            }
         }
      }
      
      public function onResetValues() : void
      {
         var forEachFunc:Function = function(statInfo:MovieClip, index:uint, vec:Vector.<MovieClip>):void
         {
            statInfo.myStatusBarPositive.scaleX = 0;
            statInfo.myStatusBarNegative.scaleX = 0;
            statInfo.myStatusBar.scaleX = 0;
            statInfo.myStatusBar.gotoAndStop(1);
         };
         this.myStatInfo.forEach(forEachFunc);
      }
      
      public function setStatName(uIndex:uint, sName:String) : void
      {
         var statInfo:MovieClip = this.myStatInfo[uIndex];
         statInfo.myTextTF.text = sName;
      }
      
      public function setStatValue(uIndex:uint, nStatValue:Number) : void
      {
         this.myStatInfo[uIndex].myStatusBar.scaleX = PercentToFraction(nStatValue);
         this.myStatInfo[uIndex].myNumberText.gotoAndStop(1);
         this.myStatInfo[uIndex].myNumberText.myTextField.text = String(nStatValue);
      }
      
      public function setMaxValue(uIndex:uint, nStatValue:Number) : void
      {
      }
      
      public function setStatDifValue(uIndex:uint, baseValue:Number, modifiedValue:Number) : void
      {
         var statInfo:MovieClip = this.myStatInfo[uIndex];
         var basePercentage:Number = PercentToFraction(baseValue);
         var modifiedPercentage:Number = PercentToFraction(modifiedValue);
         statInfo.myStatusBarPositive.visible = false;
         statInfo.myStatusBarNegative.visible = false;
         if(baseValue == modifiedValue)
         {
            statInfo.myStatusBar.scaleX = basePercentage;
            statInfo.myNumberText.gotoAndStop(1);
            statInfo.myNumberText.myTextField.text = String(baseValue);
         }
         else if(baseValue < modifiedValue)
         {
            statInfo.myStatusBarPositive.visible = true;
            statInfo.myStatusBarPositive.scaleX = modifiedPercentage;
            statInfo.myStatusBar.scaleX = basePercentage;
            statInfo.myNumberText.gotoAndStop(2);
            statInfo.myNumberText.myTextField.text = String(modifiedValue);
         }
         else if(baseValue > modifiedValue)
         {
            statInfo.myStatusBarNegative.visible = true;
            statInfo.myStatusBarNegative.scaleX = basePercentage;
            statInfo.myStatusBar.scaleX = modifiedPercentage;
            statInfo.myNumberText.gotoAndStop(3);
            statInfo.myNumberText.myTextField.text = String(modifiedValue);
         }
      }
      
      public function getStatTextSize(uIndex:uint) : Number
      {
         return Number(this.myStatInfo[uIndex].myTextTF.width);
      }
   }
}


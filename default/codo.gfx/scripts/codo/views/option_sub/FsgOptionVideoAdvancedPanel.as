package codo.views.option_sub
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictSetting;
   import codo.objects.VideoObj;
   import flash.events.Event;
   import fsg.shared.CheckBox;
   import fsg.shared.ComboBox;
   import fsg.shared.ConfigSlider;
   
   public class FsgOptionVideoAdvancedPanel extends FsgOptionVideoBase
   {
      
      public var myFPSLimit:ComboBox;
      
      public var myCBScreenRefreshRate:ComboBox;
      
      public var myCBAntiAliasing:ComboBox;
      
      public var myPBFOV:ConfigSlider;
      
      public var myChkSyncEveryFrame:CheckBox;
      
      public var myChkShadows:CheckBox;
      
      public var myChkSpecularMap:CheckBox;
      
      public var myChkDepthOfField:CheckBox;
      
      public var myChkSoftenSmokeEdges:CheckBox;
      
      public var myChkDistortion:CheckBox;
      
      public var myChkRagdoll:CheckBox;
      
      public var myChkBulletImpacts:CheckBox;
      
      public var myChkGlowAllowed:CheckBox;
      
      public var myCBTextureQuality:ComboBox;
      
      public var myCBTextureRes:ComboBox;
      
      public var myCBNormalMapRes:ComboBox;
      
      public var myCBSpecularMapRes:ComboBox;
      
      public var myCBSSAO:ComboBox;
      
      public var myCBDynamicLight:ComboBox;
      
      public function FsgOptionVideoAdvancedPanel()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.myFPSLimit.label = DictSetting.FPS_LIMIT;
         this.myCBScreenRefreshRate.label = DictSetting.SCREEN_REFRESH_RATE;
         this.myCBAntiAliasing.label = DictSetting.ANTI_ALIASING;
         this.myPBFOV.setText(DictSetting.VIDEO_FOV,null);
         this.myChkSyncEveryFrame.setText(DictSetting.SYNC_EVERY_FRAME,DictSetting.SYNC_EVERY_FRAME_DESC);
         this.myChkSyncEveryFrame.addCheckedCallback(this.onVSyncChange);
         this.myChkSyncEveryFrame.addUncheckedCallback(this.onVSyncChange);
         this.myChkShadows.setText(DictSetting.SHADOWS,DictSetting.SHADOWS_DESC);
         this.myChkSpecularMap.setText(DictSetting.SPECULAR_MAP,DictSetting.SPECULAR_MAP_DESC);
         this.myChkDepthOfField.setText(DictSetting.DEPTH_OF_FIELD,DictSetting.DEPTH_OF_FIELD_DESC);
         this.myChkSoftenSmokeEdges.setText(DictSetting.SOFTEN_SMOKE_EDGES,DictSetting.SOFTEN_SMOKE_EDGES_DESC);
         this.myChkDistortion.setText(DictSetting.DISTORTION,DictSetting.DISTORTION_DESC);
         this.myChkRagdoll.setText(DictSetting.RAGDOLL,DictSetting.RAGDOLL_DESC);
         this.myChkBulletImpacts.setText(DictSetting.BULLET_IMPACTS,DictSetting.BULLET_IMPACTS_DESC);
         this.myChkGlowAllowed.setText(DictSetting.GLOW_ALLOWED,DictSetting.GLOW_ALLOWED_DESC);
         this.myCBTextureQuality.label = DictSetting.TEXTURE_QUALITY;
         this.myCBTextureRes.label = DictSetting.TEXTURE_RESOLUTION;
         this.myCBNormalMapRes.label = DictSetting.NORMAL_MAP_RESOLUTION;
         this.myCBSpecularMapRes.label = DictSetting.SPECULAR_MAP_RESOLUTION;
         this.myCBSSAO.label = DictSetting.SSAO;
         this.myCBDynamicLight.label = DictSetting.DYNAMIC_LIGHT_LIMIT;
         this.myChkSyncEveryFrame.checked = false;
         this.myChkShadows.checked = false;
         this.myChkSpecularMap.checked = false;
         this.myChkDepthOfField.checked = false;
         this.myChkSoftenSmokeEdges.checked = false;
         this.myChkRagdoll.checked = false;
         this.myChkBulletImpacts.checked = false;
         this.myChkDistortion.checked = false;
         this.myChkGlowAllowed.checked = false;
      }
      
      override protected function onInitListener() : void
      {
         this.myCBTextureQuality.addEventListener(ComboBox.EVT_CHANGE,this.onTextureQualityChanged);
      }
      
      override public function RefreshSettings(settings:VideoObj) : void
      {
         var fovRange:Object = this.getDP(DataID.FOV_RANGE);
         if(fovRange != null)
         {
            this.myPBFOV.initialise(settings.ui_r_fov,fovRange.min,fovRange.max);
         }
         this.myCBAntiAliasing.dataProvider = settings.antiAliasings;
         this.myCBAntiAliasing.selectedIndex = settings.idxAntiAliasing;
         this.myFPSLimit.dataProvider = settings.fpsLimits;
         this.myFPSLimit.selectedIndex = settings.idxFpsLimit;
         this.myCBScreenRefreshRate.dataProvider = settings.displayRefreshes;
         this.myCBScreenRefreshRate.selectedIndex = settings.idxDisplayRefresh;
         this.myChkSyncEveryFrame.checked = settings.ui_r_vsync;
         var isVSyncEnabled:Boolean = this.myChkSyncEveryFrame.checked;
         broadcast(BCEvent.EVT_VSYNC_OPTION_CHANGE,{"v_sync_enabled":isVSyncEnabled});
         this.myChkShadows.checked = settings.ui_sm_enable;
         this.myChkSpecularMap.checked = settings.ui_r_specular;
         this.myChkDepthOfField.checked = settings.ui_r_dof_enable;
         this.myChkSoftenSmokeEdges.checked = settings.ui_r_zFeather;
         this.myChkRagdoll.checked = settings.ui_ragdoll_enable;
         this.myChkBulletImpacts.checked = settings.ui_fx_marks;
         this.myChkGlowAllowed.checked = settings.ui_r_glow_allowed;
         this.myChkDistortion.checked = settings.ui_r_distortion;
         this.myCBTextureQuality.dataProvider = settings.texQualities;
         if(settings.idxTextureQuality >= this.myCBTextureQuality.dataProvider.length)
         {
            this.myCBTextureQuality.selectedIndex = this.myCBTextureQuality.dataProvider.length - 1;
         }
         else
         {
            this.myCBTextureQuality.selectedIndex = settings.idxTextureQuality;
         }
         this.myCBTextureRes.dataProvider = settings.texResolutions;
         if(this.getIndexByID(settings.texResolutions,settings.ui_r_picmip) >= this.myCBTextureRes.dataProvider.length)
         {
            this.myCBTextureRes.selectedIndex = this.myCBTextureRes.dataProvider.length - 1;
         }
         else
         {
            this.myCBTextureRes.selectedIndex = this.getIndexByID(settings.texResolutions,settings.ui_r_picmip);
         }
         this.myCBNormalMapRes.dataProvider = settings.normalMapResolutions;
         if(this.getIndexByID(settings.normalMapResolutions,settings.ui_r_picmip_bump) >= this.myCBNormalMapRes.dataProvider.length)
         {
            this.myCBNormalMapRes.selectedIndex = this.myCBNormalMapRes.dataProvider.length - 1;
         }
         else
         {
            this.myCBNormalMapRes.selectedIndex = this.getIndexByID(settings.normalMapResolutions,settings.ui_r_picmip_bump);
         }
         this.myCBSpecularMapRes.dataProvider = settings.specularMapResolutions;
         this.myCBSpecularMapRes.disabledItemMsg = this.myCBTextureRes.disabledItemMsg = this.myCBNormalMapRes.disabledItemMsg = Dict.TEXTURE_RES_GRAPHICS_CARD_WARNING;
         if(this.getIndexByID(settings.normalMapResolutions,settings.ui_r_picmip_spec) >= this.myCBSpecularMapRes.dataProvider.length)
         {
            this.myCBSpecularMapRes.selectedIndex = this.myCBSpecularMapRes.dataProvider.length - 1;
         }
         else
         {
            this.myCBSpecularMapRes.selectedIndex = this.getIndexByID(settings.normalMapResolutions,settings.ui_r_picmip_spec);
         }
         this.myCBSSAO.dataProvider = settings.ssaos;
         if(this.getIndexByID(settings.ssaos,settings.ui_r_ssao) >= this.myCBSSAO.dataProvider.length)
         {
            this.myCBSSAO.selectedIndex = this.myCBSSAO.dataProvider.length - 1;
         }
         else
         {
            this.myCBSSAO.selectedIndex = this.getIndexByID(settings.ssaos,settings.ui_r_ssao);
         }
         this.myCBDynamicLight.dataProvider = settings.dynamicLights;
         if(this.getIndexByID(settings.dynamicLights,settings.ui_r_dlightlimit) >= this.myCBDynamicLight.dataProvider)
         {
            this.myCBDynamicLight.selectedIndex = this.myCBDynamicLight.dataProvider.length - 1;
         }
         else
         {
            this.myCBDynamicLight.selectedIndex = this.getIndexByID(settings.dynamicLights,settings.ui_r_dlightlimit);
         }
         this.myCBAntiAliasing.enabled = this.myChkSyncEveryFrame.enable = this.myChkShadows.enable = this.myChkSpecularMap.enable = this.myChkDepthOfField.enable = this.myChkSoftenSmokeEdges.enable = this.myChkRagdoll.enable = this.myChkBulletImpacts.enable = this.myChkGlowAllowed.enable = this.myChkDistortion.enable = this.myCBTextureQuality.enabled = this.myCBSSAO.enabled = this.myCBDynamicLight.enabled = !settings.disable_adv_option;
         this.showTextureResolutions(this.myCBTextureQuality.selectedIndex == 1);
      }
      
      override public function ApplySettings(settingsToUpdate:VideoObj, isCurrentTab:Boolean) : void
      {
         settingsToUpdate.ui_r_aaSamples = this.myCBAntiAliasing.selectedValue.id;
         settingsToUpdate.ui_r_fpsLimit = this.myFPSLimit.selectedValue.id;
         settingsToUpdate.ui_r_displayRefresh = this.myCBScreenRefreshRate.selectedValue.id;
         settingsToUpdate.ui_r_vsync = this.myChkSyncEveryFrame.checked;
         settingsToUpdate.ui_sm_enable = this.myChkShadows.checked;
         settingsToUpdate.ui_r_specular = this.myChkSpecularMap.checked;
         settingsToUpdate.ui_r_dof_enable = this.myChkDepthOfField.checked;
         settingsToUpdate.ui_r_zFeather = this.myChkSoftenSmokeEdges.checked;
         settingsToUpdate.ui_ragdoll_enable = this.myChkRagdoll.checked;
         settingsToUpdate.ui_fx_marks = this.myChkBulletImpacts.checked;
         settingsToUpdate.ui_r_picmip_manual = this.myCBTextureQuality.selectedValue.id;
         settingsToUpdate.ui_r_picmip = settingsToUpdate.texResolutions[this.myCBTextureRes.selectedIndex].id;
         settingsToUpdate.ui_r_picmip_bump = settingsToUpdate.normalMapResolutions[this.myCBNormalMapRes.selectedIndex].id;
         settingsToUpdate.ui_r_picmip_spec = settingsToUpdate.specularMapResolutions[this.myCBSpecularMapRes.selectedIndex].id;
         settingsToUpdate.ui_r_ssao = this.myCBSSAO.selectedValue.id;
         settingsToUpdate.ui_r_dlightlimit = this.myCBDynamicLight.selectedValue.id;
         settingsToUpdate.ui_r_glow_allowed = this.myChkGlowAllowed.checked;
         settingsToUpdate.ui_r_distortion = this.myChkDistortion.checked;
         this.broadcast(BCEvent.EVT_SET_FOV,this.myPBFOV.getValue());
         if(settingsToUpdate.ui_r_vsync)
         {
            this.broadcast(BCEvent.EVT_SET_MOUSE_SMOOTH,"1");
         }
      }
      
      private function getIndexByID(dp:Array, id:int) : int
      {
         for(var i:int = 0; i < dp.length; i++)
         {
            if(dp[i].id == id)
            {
               return i;
            }
         }
         return 0;
      }
      
      private function showTextureResolutions(visible:Boolean) : void
      {
         this.myCBTextureRes.visible = visible;
         this.myCBNormalMapRes.visible = visible;
         this.myCBSpecularMapRes.visible = visible;
      }
      
      private function onTextureQualityChanged(event:Event) : void
      {
         this.showTextureResolutions(this.myCBTextureQuality.selectedIndex == 1);
      }
      
      private function onVSyncChange() : void
      {
         var isVSyncEnabled:Boolean = this.myChkSyncEveryFrame.checked;
         broadcast(BCEvent.EVT_VSYNC_OPTION_CHANGE,{"v_sync_enabled":isVSyncEnabled});
      }
   }
}


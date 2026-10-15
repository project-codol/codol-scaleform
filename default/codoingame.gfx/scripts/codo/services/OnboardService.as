package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.ServiceID;
   import codo.localization.DictCoopSummary;
   import codo.objects.FsgTrainingSummaryObj;
   import codo.objects.ItemObj;
   import codo.utils.ScaleformUtil;
   
   public class OnboardService extends ServiceBase
   {
      
      private static var _instance:OnboardService;
      
      public function OnboardService()
      {
         super(ServiceID.ONBOARDING);
      }
      
      public static function getInstance() : OnboardService
      {
         if(OnboardService._instance == null)
         {
            OnboardService._instance = new OnboardService();
         }
         return OnboardService._instance;
      }
      
      public function getTrainEOGSummary() : Vector.<FsgTrainingSummaryObj>
      {
         var summaryData:Vector.<FsgTrainingSummaryObj> = null;
         var SUMMARY_STAT_ACCURACY:uint = 0;
         var SUMMARY_STAT_TIME:uint = 1;
         var SUMMARY_STAT_TARGETS:uint = 2;
         var SUMMARY_STAT_FINAL_SCORE:uint = 3;
         var time:Number = ScaleformUtil.isScaleform ? Number(CFunctionCommonContainer.Dvar_GetFloat("train_time")) : 26;
         var timeScore:Number = ScaleformUtil.isScaleform ? Number(CFunctionCommonContainer.Dvar_GetFloat("train_score_time")) : 54;
         var timeIconFrame:uint = 2;
         var accuracyIconFrame:uint = 1;
         var accuracyLabel:String = ScaleformUtil.isScaleform ? CFunctionCommonContainer.Dvar_GetString("train_accuracy_label") : DictCoopSummary.ACCURACY_LABEL;
         var accuracy:String = ScaleformUtil.isScaleform ? CFunctionCommonContainer.Dvar_GetString("train_accuracy") : "66%";
         var accuracyScore:int = ScaleformUtil.isScaleform ? this.getDvarInt("train_score_accuracy") : 66;
         var targetsIconFrame:uint = 3;
         var targetsLabel:String = ScaleformUtil.isScaleform ? CFunctionCommonContainer.Dvar_GetString("train_targets_label") : DictCoopSummary.TARGET_HIT_LABEL;
         var targets:String = ScaleformUtil.isScaleform ? CFunctionCommonContainer.Dvar_GetString("train_targets") : "7";
         var targetsScore:int = ScaleformUtil.isScaleform ? this.getDvarInt("train_score_targets") : 35;
         var finalScore:int = ScaleformUtil.isScaleform ? this.getDvarInt("train_final_score") : 235;
         var finalScoreStar:int = ScaleformUtil.isScaleform ? this.getDvarInt("train_final_star") : 3;
         var preBestScore:int = ScaleformUtil.isScaleform ? this.getDvarInt("train_prev_best") : 3;
         var preBestStar:int = ScaleformUtil.isScaleform ? this.getDvarInt("train_prev_best_star") : 0;
         return new <FsgTrainingSummaryObj>[new FsgTrainingSummaryObj(SUMMARY_STAT_ACCURACY,accuracyIconFrame,accuracyLabel,accuracy,accuracyScore),new FsgTrainingSummaryObj(SUMMARY_STAT_TIME,timeIconFrame,null,time,timeScore.toFixed(0)),new FsgTrainingSummaryObj(SUMMARY_STAT_TARGETS,targetsIconFrame,targetsLabel,targets,targetsScore),new FsgTrainingSummaryObj(SUMMARY_STAT_FINAL_SCORE,0,null,null,finalScore,preBestScore,finalScoreStar,preBestStar)];
      }
      
      public function getTrainEOGUnlocks() : Vector.<ItemObj>
      {
         var unlockData:Vector.<ItemObj> = null;
         var finalScoreStar:ItemObj = new ItemObj();
         var unlock1:ItemObj = new ItemObj();
         var unlock2:ItemObj = new ItemObj();
         var unlock3:ItemObj = new ItemObj();
         finalScoreStar.level = ScaleformUtil.isScaleform ? uint(this.getDvarInt("train_final_star")) : 0;
         unlock1.name = CFunctionCommonContainer.Dvar_GetString("train_unlock_star_1_text");
         unlock1.description = "@" + CFunctionCommonContainer.Dvar_GetString("train_unlock_star_1_desc");
         unlock1.imageURL = CFunctionCommonContainer.Dvar_GetString("train_unlock_star_1_img");
         unlock1.level = 1;
         unlock1.specialPara = [0.8];
         unlock2.name = CFunctionCommonContainer.Dvar_GetString("train_unlock_star_3_text");
         unlock2.description = "@" + CFunctionCommonContainer.Dvar_GetString("train_unlock_star_3_desc");
         unlock2.imageURL = CFunctionCommonContainer.Dvar_GetString("train_unlock_star_3_img");
         unlock2.level = 3;
         unlock2.specialPara = [0.8];
         unlock3.name = CFunctionCommonContainer.Dvar_GetString("train_unlock_star_5_text");
         unlock3.imageURL = CFunctionCommonContainer.Dvar_GetString("train_unlock_star_5_img");
         unlock3.description = "@" + CFunctionCommonContainer.Dvar_GetString("train_unlock_star_5_desc");
         unlock3.level = 5;
         unlock3.specialPara = [0.8];
         return new <ItemObj>[finalScoreStar,unlock1,unlock2,unlock3];
      }
   }
}


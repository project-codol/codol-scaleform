package components.fsgmatchresult_part.panels
{
   import codo.localization.DictWarGod;
   import codo.objects.WarGodRewardObj;
   import codo.utils.ScaleformUtil;
   import codo.views.wargodMatchResult_parts.Description;
   import codo.views.wargodMatchResult_parts.Title;
   import codo.views.wargodMatchResult_parts.WarGodAnimationTimeLine;
   import codo.views.wargodMatchResult_parts.WarGodMatchResultThreeRewards;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   
   public class FsgMatchResultWarGodRewardPopupPanel extends FsgMatchResultPopupPanelBase
   {
      
      public var myTitle:Title;
      
      public var myRewardDescription:Description;
      
      public var myRewardPanel:WarGodMatchResultThreeRewards;
      
      private var mAnimated:Boolean = false;
      
      private var mAnimationTimeLine:WarGodAnimationTimeLine;
      
      private var mRewards:Array;
      
      public function FsgMatchResultWarGodRewardPopupPanel()
      {
         var rewards:Array = null;
         var itemData:WarGodRewardObj = null;
         super();
         this.mAnimationTimeLine = new WarGodAnimationTimeLine();
         addChild(this.mAnimationTimeLine);
         this.myTitle.visible = false;
         this.myRewardDescription.visible = false;
         this.myRewardPanel.visible = false;
         if(!ScaleformUtil.isScaleform)
         {
            rewards = new Array();
            itemData = new WarGodRewardObj();
            itemData.prodID = 15270;
            itemData.parameter = 7;
            itemData.type = WarGodRewardObj.TYPE_RENTAL;
            rewards.push(itemData);
            itemData = new WarGodRewardObj();
            itemData.prodID = 15271;
            itemData.parameter = 7;
            itemData.type = WarGodRewardObj.TYPE_RENTAL;
            rewards.push(itemData);
            itemData = new WarGodRewardObj();
            itemData.prodID = 15272;
            itemData.parameter = 7;
            itemData.type = WarGodRewardObj.TYPE_RENTAL;
            rewards.push(itemData);
            this.setData(rewards);
            this.active();
         }
      }
      
      override public function active() : void
      {
         super.active();
         if(this.mAnimated)
         {
            return;
         }
         this.mAnimated = true;
         this.myTitle.setText(DictWarGod.WARGOD_REWARD_TITLE);
         this.mAnimationTimeLine.add(this.myTitle,0.5);
         this.myRewardDescription.setText(DictWarGod.WARGOD_REWARD_INTRODUCE);
         this.mAnimationTimeLine.add(this.myRewardDescription,1.5);
         this.myRewardPanel.setRewards(this.mRewards);
         this.mAnimationTimeLine.add(this.myRewardPanel,2);
         this.mAnimationTimeLine.start();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.mRewards = data as Array;
      }
   }
}


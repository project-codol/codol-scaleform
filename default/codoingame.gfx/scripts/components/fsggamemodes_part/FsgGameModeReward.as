package components.fsggamemodes_part
{
   import codo.constants.ItemType;
   import codo.localization.Dict;
   import codo.utils.DebugUtil;
   import codo.utils.ScaleformUtil;
   import components.fsgonboardpopups_part.FsgUnlockItemCompleteBanner;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import fsg.shared.ToolTipItem;
   import fsg.shared.widgets.GameModesTrainingBestScoreBar;
   import fsg.util.FsgImageHolder;
   
   public class FsgGameModeReward extends ToolTipItem
   {
      
      public static const RARITY_S_RARE:String = "s-rare";
      
      public static const RARITY_RARE:String = "rare";
      
      public static const RARITY_WON:String = "won";
      
      public var myRewardItemTitle:MovieClip;
      
      public var myImageHolder:FsgImageHolder;
      
      public var myItemTag:MovieClip;
      
      public var myGPImage:MovieClip;
      
      public var myPlayerCardTitle:MovieClip;
      
      public function FsgGameModeReward()
      {
         super();
         if(this.myGPImage != null)
         {
            this.myGPImage.visible = false;
         }
      }
      
      public function set rewardComplete(isComplete:Boolean) : void
      {
         var itemCompleteBanner:FsgUnlockItemCompleteBanner = null;
         var pos:Point = null;
         var cls:Class = getDefinitionByName("fsg.popups.fsgPopupUnlockItemComplete") as Class;
         pos = this.getRewardCompletePos();
         itemCompleteBanner = addChild(new cls()) as FsgUnlockItemCompleteBanner;
         itemCompleteBanner.rotation = -45;
         itemCompleteBanner.x = pos.x;
         itemCompleteBanner.y = pos.y;
         itemCompleteBanner.visible = isComplete;
         itemCompleteBanner.bannerText = Dict.WON;
      }
      
      protected function getRewardCompletePos() : Point
      {
         return new Point(3,3);
      }
      
      public function set scoreDisplay(index:uint) : void
      {
         var prevBestScore:GameModesTrainingBestScoreBar = null;
         var cls:Class = getDefinitionByName("fsgGameModesTrainingBestScoreBar") as Class;
         var starsToDisplay:uint = 0;
         switch(index)
         {
            case 0:
               starsToDisplay = 1;
               break;
            case 1:
               starsToDisplay = 3;
               break;
            case 2:
               starsToDisplay = 5;
         }
         prevBestScore = addChild(new cls()) as GameModesTrainingBestScoreBar;
         prevBestScore.hideBestScoreTF();
         prevBestScore.formatDisplay();
         prevBestScore.starsComplete = starsToDisplay;
         prevBestScore.y = this.height - prevBestScore.height;
      }
      
      public function setData(reward:Object) : void
      {
         var playercardTitleTxt:TextField = null;
         var additionalData:Object = null;
         var description:String = null;
         playercardTitleTxt = this.myPlayerCardTitle.getChildByName("myTextTF") as TextField;
         playercardTitleTxt.autoSize = TextFieldAutoSize.CENTER;
         if(reward == null)
         {
            return;
         }
         if(reward.type == "pct")
         {
            this.myPlayerCardTitle.visible = true;
            playercardTitleTxt.text = reward.name;
            this.myRewardItemTitle.visible = false;
            this.myImageHolder.visible = false;
         }
         else
         {
            this.myRewardItemTitle.visible = true;
            this.myRewardItemTitle.text_txt.text = reward.name;
            this.myPlayerCardTitle.visible = false;
            this.myImageHolder.visible = true;
            this.myImageHolder.setImage(reward.imageURL);
         }
         if(reward.type == ItemType.WEAPON)
         {
            additionalData = new Object();
            additionalData.data = reward;
            setTip(reward.description,{
               "x":300,
               "y":0
            },additionalData);
         }
         else
         {
            description = reward.description;
            if(ScaleformUtil.IsLogItemIDEnabled())
            {
               description = DebugUtil.concatenateDebugSkuInfoToString(description,reward);
            }
            setTip(reward.description,{
               "x":300,
               "y":0
            });
         }
         this.setItemTag(reward.rarity);
      }
      
      public function setItemTag(rarity:String = "") : void
      {
         if(rarity == RARITY_S_RARE)
         {
            this.myItemTag.visible = true;
            this.myItemTag.gotoAndStop(1);
            this.myItemTag.myTagText.text_txt.text = "@SF_UI_TAG_SUPER_RARE";
         }
         else if(rarity == RARITY_RARE)
         {
            this.myItemTag.visible = true;
            this.myItemTag.gotoAndStop(2);
            this.myItemTag.myTagText.text_txt.text = "@SF_UI_TAG_RARE";
         }
         else if(rarity == RARITY_WON)
         {
            this.myItemTag.visible = true;
            this.myItemTag.gotoAndStop(2);
            this.myItemTag.myTagText.text_txt.text = Dict.WON;
         }
         else
         {
            this.myItemTag.visible = false;
         }
      }
      
      public function setExclusive() : void
      {
         this.myItemTag.visible = true;
         this.myItemTag.gotoAndStop(3);
         this.myItemTag.myTagText.text_txt.text = "@SF_UI_EXCLUSIVE";
      }
   }
}


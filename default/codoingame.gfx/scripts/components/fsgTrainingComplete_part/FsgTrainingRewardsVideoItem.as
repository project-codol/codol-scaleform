package components.fsgTrainingComplete_part
{
   import codo.constants.ItemType;
   import codo.event.ParaEvent;
   import codo.utils.DebugUtil;
   import codo.utils.ScaleformUtil;
   import components.fsggamemodes_part.FsgGameModeReward;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import fsg.shared.widgets.GameModesTrainingBestScoreBar;
   
   public class FsgTrainingRewardsVideoItem extends FsgGameModeReward
   {
      
      public var myBackgroundItem:Sprite;
      
      public function FsgTrainingRewardsVideoItem()
      {
         super();
         myItemTag.visible = false;
      }
      
      override public function set scoreDisplay(index:uint) : void
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
         prevBestScore.y = this.height - 106;
         prevBestScore.x = -125;
         prevBestScore.scaleX = prevBestScore.scaleY = 0.83;
      }
      
      override protected function getRewardCompletePos() : Point
      {
         return new Point(myItemTag.x,myItemTag.y);
      }
      
      override public function setData(reward:Object) : void
      {
         var additionalData:Object = null;
         var description:String = null;
         if(reward == null)
         {
            return;
         }
         if(reward.type == "pct")
         {
            myPlayerCardTitle.visible = true;
            myPlayerCardTitle.myTextTF.text = "@" + reward.name;
            myRewardItemTitle.visible = false;
            myImageHolder.visible = false;
         }
         else
         {
            myRewardItemTitle.visible = true;
            myRewardItemTitle.text_txt.text = "@" + reward.name;
            myPlayerCardTitle.visible = false;
            myImageHolder.visible = true;
            myImageHolder.setImage(reward.imageURL);
         }
         if(reward.type == ItemType.WEAPON)
         {
            additionalData = new Object();
            additionalData.data = reward;
         }
         else
         {
            description = reward.description;
            if(ScaleformUtil.IsLogItemIDEnabled())
            {
               description = DebugUtil.concatenateDebugSkuInfoToString(description,reward);
            }
         }
         myImageHolder.addEventListener(Event.COMPLETE,this.onImageComplete);
      }
      
      private function onImageComplete(cEvt:ParaEvent) : void
      {
         var bmpImage:DisplayObject = myImageHolder.getChildAt(0);
         bmpImage.scaleX = bmpImage.scaleY = 0.9;
         bmpImage.x = (this.myBackgroundItem.width - bmpImage.width) * 0.5 + 16;
         bmpImage.y = (this.myBackgroundItem.height - bmpImage.height) * 0.5 - 10;
         myImageHolder.removeEventListener(Event.COMPLETE,this.onImageComplete);
      }
      
      override public function setTip(text:String, size:Object = null, AdditionalData:Object = null) : void
      {
      }
   }
}


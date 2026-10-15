package codo.views.hud.playerInfoBar
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PlayerInfoBar extends HUDComponent
   {
      
      private static const CONSUMABLE_BUFF_ICON_PADDING:int = 55;
      
      private static const BUFF_ICON_PADDING:int = 44;
      
      public var myHealthValueWrapper:MovieClip;
      
      public var myHealthValue:TextField;
      
      public var myLevelTextWrapper:MovieClip;
      
      public var myLevel:TextField;
      
      public var myBuff0:MovieClip;
      
      public var myBuff1:MovieClip;
      
      public var myBuff2:MovieClip;
      
      public var myBuff3:MovieClip;
      
      public var myConsumableBuff:MovieClip;
      
      private var mBuffIcons:Array;
      
      private var mBuffAnimationTimelines:Array;
      
      private var mBuffXPositions:Array;
      
      private var mBuffSizes:Array;
      
      private var mLevelAnimTimeline:TimelineLite;
      
      private var mBuffIconOrgX:Number;
      
      public function PlayerInfoBar()
      {
         super();
         this.mBuffIconOrgX = this.myBuff0.x;
      }
      
      override protected function init() : void
      {
         this.myHealthValue = this.myHealthValueWrapper["myText"];
         this.myLevel = this.myLevelTextWrapper["myText"];
         this.mBuffIcons = [this.myBuff0,this.myBuff1,this.myBuff2,this.myBuff3];
         this.mBuffAnimationTimelines = [];
         this.mBuffXPositions = [];
         this.mBuffSizes = [];
         for(var i:int = 0; i < this.mBuffIcons.length; i++)
         {
            this.mBuffAnimationTimelines.push(new TimelineLite());
            this.mBuffXPositions.push(this.mBuffIcons[i].x);
            this.mBuffSizes.push([this.mBuffIcons[i].width,this.mBuffIcons[i].height]);
         }
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.PLAYERINFO_BAR;
      }
      
      public function playBuffGainAnimation(buffIndex:int) : void
      {
         var mc:MovieClip = this.mBuffIcons[buffIndex];
         var timeline:TimelineLite = this.mBuffAnimationTimelines[buffIndex];
         if(timeline.active)
         {
            timeline.complete();
         }
         timeline = new TimelineLite();
         var xOffset:Number = 0;
         if(buffIndex == 0)
         {
            xOffset = mc.width;
         }
         var newPositionX:Number = Number(this.mBuffXPositions[buffIndex]);
         if(this.myConsumableBuff.visible)
         {
            newPositionX += CONSUMABLE_BUFF_ICON_PADDING;
         }
         mc.x = newPositionX;
         mc.width = this.mBuffSizes[buffIndex][0];
         mc.height = mc.width = this.mBuffSizes[buffIndex][1];
         timeline.append(TweenLite.to(mc,0.25,{
            "width":mc.width * 2,
            "height":mc.height * 2,
            "alpha":0.5,
            "x":mc.x - xOffset
         }));
         timeline.append(TweenLite.to(mc,0.25,{
            "width":mc.width,
            "height":mc.height,
            "alpha":1,
            "x":mc.x
         }));
         timeline.play();
      }
      
      public function playLevelUpgradeAnimation() : void
      {
         if(this.mLevelAnimTimeline != null && this.mLevelAnimTimeline.active)
         {
            this.mLevelAnimTimeline.complete();
         }
         this.mLevelAnimTimeline = new TimelineLite();
         this.mLevelAnimTimeline.append(TweenLite.to(this.myLevelTextWrapper,0.25,{
            "width":this.myLevelTextWrapper.width * 2.5,
            "height":this.myLevelTextWrapper.height * 2.5
         }));
         this.mLevelAnimTimeline.append(TweenLite.to(this.myLevelTextWrapper,0.25,{
            "width":this.myLevelTextWrapper.width,
            "height":this.myLevelTextWrapper.height
         }));
         this.mLevelAnimTimeline.play();
      }
      
      public function playGainConsumableBuffAnimation() : void
      {
         var xOffset:Number = NaN;
         var timeline:TimelineLite = new TimelineLite();
         xOffset = this.myConsumableBuff.width / 2;
         var yOffset:Number = this.myConsumableBuff.height / 2;
         this.myConsumableBuff.x = this.mBuffIconOrgX;
         this.mBuffIcons[0].x = this.myConsumableBuff.x + CONSUMABLE_BUFF_ICON_PADDING;
         this.mBuffIcons[1].x = this.mBuffIcons[0].x + BUFF_ICON_PADDING;
         this.mBuffIcons[2].x = this.mBuffIcons[1].x + BUFF_ICON_PADDING;
         this.mBuffIcons[3].x = this.mBuffIcons[2].x + BUFF_ICON_PADDING;
         TweenLite.killTweensOf(this.myConsumableBuff);
         this.myConsumableBuff.scaleX = 1;
         this.myConsumableBuff.scaleY = 1;
         timeline.append(TweenLite.to(this.myConsumableBuff,0.25,{
            "width":this.myConsumableBuff.width * 2,
            "height":this.myConsumableBuff.height * 2,
            "alpha":0.5,
            "x":this.myConsumableBuff.x - xOffset,
            "y":this.myConsumableBuff.y - yOffset
         }));
         timeline.append(TweenLite.to(this.myConsumableBuff,0.25,{
            "width":this.myConsumableBuff.width,
            "height":this.myConsumableBuff.height,
            "alpha":1,
            "x":this.myConsumableBuff.x,
            "y":this.myConsumableBuff.y
         }));
      }
      
      public function hideConsumableBuff() : void
      {
         this.mBuffIcons[0].x = this.mBuffIconOrgX;
         this.mBuffIcons[1].x = this.mBuffIcons[0].x + BUFF_ICON_PADDING;
         this.mBuffIcons[2].x = this.mBuffIcons[1].x + BUFF_ICON_PADDING;
         this.mBuffIcons[3].x = this.mBuffIcons[2].x + BUFF_ICON_PADDING;
      }
   }
}


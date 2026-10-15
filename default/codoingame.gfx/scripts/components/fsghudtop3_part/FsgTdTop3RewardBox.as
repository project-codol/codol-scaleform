package components.fsghudtop3_part
{
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class FsgTdTop3RewardBox extends MovieClip
   {
      
      private const ITEM_FRAME_INDEX_DEFAULT:int = 1;
      
      private const ITEM_FRAME_INDEX_SPECIAL:int = 2;
      
      private const BASE_OPEN_DELAY:Number = 3;
      
      private const OPEN_DELAY_INC:Number = 1.5;
      
      private const OPEN_ANIM_DURATION:Number = 1;
      
      public var myItem:MovieClip;
      
      public var myBoxIcon:MovieClip;
      
      private var mFlipProgress:Number;
      
      private var mTween:TweenLite;
      
      private var mData:Object;
      
      private var mBaseScaleX:Number;
      
      public function FsgTdTop3RewardBox()
      {
         super();
         this.mBaseScaleX = scaleX;
      }
      
      public function setData(animateOrder:int, rewardIndex:int, objData:Object) : void
      {
         this.mData = objData;
         gotoAndStop(this.ITEM_FRAME_INDEX_DEFAULT);
         this.myBoxIcon.gotoAndStop(objData.chestID);
         this.myBoxIcon.visible = true;
         this.myItem.visible = false;
         this.setItemImage(new ProductObj(objData.item));
         this.flipProgress = 0;
         if(this.mTween != null)
         {
            this.mTween.kill();
            this.mTween = null;
         }
         this.mTween = new TweenLite(this,this.OPEN_ANIM_DURATION,{
            "flipProgress":1,
            "delay":this.BASE_OPEN_DELAY + this.OPEN_DELAY_INC * animateOrder
         });
      }
      
      public function set flipProgress(progress:Number) : void
      {
         if(this.mFlipProgress < 0.5 && progress >= 0.5)
         {
            this.myBoxIcon.visible = false;
            this.myItem.visible = true;
            this.gotoAndStop(Boolean(this.mData.isSpecialItem) ? this.ITEM_FRAME_INDEX_SPECIAL : this.ITEM_FRAME_INDEX_DEFAULT);
         }
         this.mFlipProgress = progress;
         scaleX = Math.abs(Math.cos(progress * Math.PI)) * this.mBaseScaleX;
      }
      
      public function get flipProgress() : Number
      {
         return this.mFlipProgress;
      }
      
      public function setItemImage(productData:ProductObj) : void
      {
         var animatedBackgroundLoadData:Object = null;
         var animatedIconLoadData:Object = null;
         var isAnimatedBackground:Boolean = productData.isAnimatedBackground();
         var isAnimatedEmblem:Boolean = productData.isAnimatedEmblem();
         var isAnimatedFrame:Boolean = productData.isAnimatedFrame();
         this.myItem.imageHolder.visible = false;
         this.myItem.animatedBackgroundMount.visible = false;
         this.myItem.animatedEmblemMount.visible = false;
         if(isAnimatedBackground || isAnimatedFrame)
         {
            animatedBackgroundLoadData = {
               "name":productData.imageURL,
               "holder":this.myItem.animatedEmblemMount
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedBackgroundLoadData);
            this.myItem.animatedBackgroundMount.visible = true;
         }
         else if(isAnimatedEmblem)
         {
            animatedIconLoadData = {
               "name":productData.imageURL,
               "holder":this.myItem.animatedEmblemMount
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedIconLoadData);
            this.myItem.animatedEmblemMount.visible = true;
         }
         else
         {
            this.myItem.imageHolder.visible = true;
            this.myItem.imageHolder.setImage(productData.imageURL);
         }
      }
   }
}


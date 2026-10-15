package codo.base
{
   import codo.constants.GameInfo;
   import codo.interfaces.IBasePageLayer;
   import com.greensock.TweenLite;
   import components.DepthSprite;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class BasePageLayer extends DepthSprite implements IBasePageLayer
   {
      
      private static const MASK_SRC_ID:String = "$layerMask";
      
      private static const MASK_ALPHA:Number = 0.95;
      
      private var myLayerMask:Sprite;
      
      private var myWorldMask:Shape;
      
      private var _isShow:Boolean = false;
      
      private var _targetShow:Boolean = false;
      
      private var _fadedInWorld:Boolean = false;
      
      private var _shouldFade:Boolean = false;
      
      public function BasePageLayer()
      {
         super();
         var layerMaskCls:Class = getDefinitionByName(MASK_SRC_ID) as Class;
         this.myLayerMask = new layerMaskCls();
         this.myLayerMask.visible = false;
         this.myLayerMask.alpha = MASK_ALPHA;
         mouseEnabled = false;
         this.myWorldMask = new Shape();
         this.myWorldMask.graphics.beginFill(0,1);
         this.myWorldMask.graphics.drawRect(0,0,1,1);
         this.myWorldMask.graphics.endFill();
         this.myWorldMask.visible = false;
      }
      
      public function updateIsShowFlag() : void
      {
         if(this._targetShow != this._isShow)
         {
            this._isShow = this._targetShow;
            this.myLayerMask.visible = this._isShow;
         }
      }
      
      public function changeSize(cWidth:Number, cHeight:Number) : void
      {
         addChildAt(this.myLayerMask,0);
         var newWHRatio:Number = cWidth / cHeight;
         var oldWHRatio:Number = GameInfo.DEFAULT_WIDTH / GameInfo.DEFAULT_HEIGHT;
         if(newWHRatio == oldWHRatio)
         {
            GameInfo.widthExtra = GameInfo.heightExtra = 0;
         }
         else if(newWHRatio > oldWHRatio)
         {
            this.myLayerMask.width = cWidth / (cHeight / GameInfo.DEFAULT_HEIGHT);
            this.myLayerMask.x = (GameInfo.DEFAULT_WIDTH - this.myLayerMask.width) / 2;
            GameInfo.widthExtra = Math.abs((GameInfo.DEFAULT_WIDTH - stage.stageWidth) / 2);
            GameInfo.heightExtra = 0;
         }
         else
         {
            this.myLayerMask.height = cHeight / (cWidth / GameInfo.DEFAULT_WIDTH);
            this.myLayerMask.y = (GameInfo.DEFAULT_HEIGHT - this.myLayerMask.height) / 2;
            GameInfo.heightExtra = Math.abs((GameInfo.DEFAULT_HEIGHT - stage.stageHeight) / 2);
            GameInfo.widthExtra = 0;
         }
         this.myLayerMask.x -= 1;
         this.myLayerMask.y -= 1;
         this.myLayerMask.width += 2;
         this.myLayerMask.height += 2;
         this.myWorldMask.x = this.myLayerMask.x;
         this.myWorldMask.y = this.myLayerMask.y;
         this.myWorldMask.width = this.myLayerMask.width;
         this.myWorldMask.height = this.myLayerMask.height;
      }
      
      public function setFadeIn(shouldFade:Boolean) : void
      {
         this._shouldFade = shouldFade;
      }
      
      public function showATField() : void
      {
         this._targetShow = true;
         this.updateIsShowFlag();
         if(!this._fadedInWorld && this._shouldFade)
         {
            this._fadedInWorld = true;
            addChildAt(this.myWorldMask,0);
            this.myWorldMask.visible = true;
            this.myWorldMask.alpha = 1;
            TweenLite.to(this.myWorldMask,3.5,{
               "delay":1,
               "autoAlpha":0
            });
         }
      }
      
      public function hideATField() : void
      {
         this._targetShow = this.myWorldMask.visible = false;
         this.updateIsShowFlag();
      }
   }
}


package codo.component
{
   import codo.base.BaseView;
   import codo.cpp.UiCppView;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class ViewPanelBase extends MovieClip
   {
      
      protected static const FADE_DURATION:Number = 0.25;
      
      protected var _inited:Boolean;
      
      protected var _shown:Boolean;
      
      protected var _uiCpp:UiCppView;
      
      protected var _view:BaseView;
      
      public function ViewPanelBase()
      {
         super();
         this.visible = false;
         this._shown = false;
         if(ScaleformUtil.isScaleform)
         {
            this._uiCpp = this.makeUiCpp();
         }
         alpha = 0;
      }
      
      protected function makeUiCpp() : UiCppView
      {
         return null;
      }
      
      public function getUiCpp() : UiCppView
      {
         return this._uiCpp;
      }
      
      public function setView(view:BaseView) : void
      {
         this._view = view;
      }
      
      protected function enableData() : void
      {
      }
      
      protected function disableData() : void
      {
      }
      
      protected function onInit() : void
      {
      }
      
      final public function startDemo() : void
      {
         this._uiCpp.StartDemo();
      }
      
      final public function deleteDemo() : void
      {
         this._uiCpp.DeleteDemo();
      }
      
      protected function onActivated() : void
      {
      }
      
      protected function onDeactivated() : void
      {
      }
      
      final public function showPanel() : void
      {
         if(!this._shown)
         {
            this.visible = true;
            if(!this._inited)
            {
               this._inited = true;
               this.onInit();
               if(Boolean(this._uiCpp))
               {
                  this._uiCpp.OnInit();
               }
            }
            this.enableData();
            this._shown = true;
            if(Boolean(this._uiCpp))
            {
               this._uiCpp.ShowView();
            }
            TweenLite.killTweensOf(this);
            TweenLite.to(this,FADE_DURATION,{"alpha":1});
         }
         this.onActivated();
      }
      
      final public function hidePanel() : void
      {
         if(this._shown)
         {
            this.disableData();
            this._shown = false;
            if(Boolean(this._uiCpp))
            {
               this._uiCpp.HideView();
            }
            TweenLite.killTweensOf(this);
            TweenLite.to(this,FADE_DURATION,{
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
         this.onDeactivated();
      }
      
      private function onHideComplete() : void
      {
         this.visible = false;
      }
      
      public function isShown() : Boolean
      {
         return this._shown;
      }
   }
}


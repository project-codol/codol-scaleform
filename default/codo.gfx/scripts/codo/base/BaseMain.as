package codo.base
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.FPSMemCounter;
   import codo.interfaces.ICommManager;
   import codo.manager.AsyncTaskManager;
   import codo.manager.ControllerManager;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.BindDataHelper;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.SoundUtil;
   import codo.utils.TextUtil;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.BlurFilterPlugin;
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.FrameLabelPlugin;
   import com.greensock.plugins.FramePlugin;
   import com.greensock.plugins.TintPlugin;
   import com.greensock.plugins.TweenPlugin;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.ui.Keyboard;
   import scaleform.gfx.Extensions;
   import shaui.component.core.UIComponent;
   
   public class BaseMain extends Sprite
   {
      
      public var menuType:uint = 0;
      
      public var commManager:ICommManager;
      
      public var asyncTaskManager:AsyncTaskManager;
      
      public var controllerManager:ControllerManager;
      
      public var dataManager:DataManager;
      
      protected var _pageManager:PageManagerBase;
      
      protected var _container:MovieClip;
      
      protected var _consoleInfo:Sprite = null;
      
      private var _initialized:Boolean = false;
      
      public function BaseMain()
      {
         var context:LoaderContext = null;
         var loader:Loader = null;
         super();
         TweenPlugin.activate([AutoAlphaPlugin,BlurFilterPlugin,ColorTransformPlugin,TintPlugin,FramePlugin,FrameLabelPlugin,TintPlugin]);
         MovieClip.prototype.playSE = function(cID:String):void
         {
            SoundUtil.getInstance().playSound(cID);
         };
         MovieClip.prototype.stopSE = function():void
         {
            SoundUtil.getInstance().stopSound();
         };
         UIComponent.STAGE = this.stage;
         TextUtil.SOUND_UTIL = UIComponent.SOUND_UTIL = SoundUtil.getInstance();
         LocalizeUtil.CFUNCTION_COMMON = ScaleformUtil.CFUNCTION_COMMON = Logger.CFUNCTION_COMMON = CFunctionCommonContainer;
         if(ScaleformUtil.isScaleform)
         {
            this.onLoad();
         }
         else
         {
            context = new LoaderContext();
            context.applicationDomain = this.loaderInfo.applicationDomain;
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLocalTestFontLibLoaded);
            loader.load(new URLRequest("localSWFTest.swf"),context);
            this.addChildAt(loader,0);
         }
      }
      
      private function onLoad(evt:Event = null) : void
      {
         if(this._initialized)
         {
            return;
         }
         this._initialized = true;
         Extensions.enabled = true;
         Extensions.noInvisibleAdvance = true;
         if(CFunctionCommonContainer.Dvar_GetInt("r_aaSamples") != 0)
         {
            Extensions.setEdgeAAMode(this.stage,Extensions.EDGEAA_OFF);
         }
         this.preInit();
         this._container = new MovieClip();
         this._container.name = "myContainer";
         this._container.tabChildren = false;
         this.addChild(this._container);
         this._pageManager.init(this._container);
         this.init();
         this.addEventListener(Event.RESIZE,this.onStageResized);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyHandle);
         this.stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
      }
      
      protected function preInit() : void
      {
         BaseView.DataManager = BaseSubElement.DataManager = BindDataHelper.DataManager = DataManager.getInstance();
         BaseView.EventManager = BaseSubElement.EventManager = EventManager.getInstance();
      }
      
      protected function init() : void
      {
         this.resetStageScale();
         if(!ScaleformUtil.isScaleform)
         {
            this.commManager.cppActivate();
            this.toggleTip();
         }
      }
      
      public function toggleTip() : void
      {
         if(this._consoleInfo == null)
         {
            this._consoleInfo = new Sprite();
            this._consoleInfo.addChild(new FPSMemCounter(this.commManager));
            this._consoleInfo.mouseEnabled = false;
            this._consoleInfo.visible = false;
            this.addChild(this._consoleInfo);
         }
         this._consoleInfo.visible = !this._consoleInfo.visible;
      }
      
      protected function resetStageScale() : void
      {
         if(this.stage != null)
         {
            this.stage.scaleMode = StageScaleMode.EXACT_FIT;
            this.stage.align = StageAlign.TOP_LEFT;
         }
      }
      
      private function onLocalTestFontLibLoaded(event:Event) : void
      {
         this.onLoad();
      }
      
      private function onStageResized(cEvt:Event) : void
      {
         this.resetStageScale();
      }
      
      protected function onStageKeyHandle(cEvt:KeyboardEvent) : void
      {
         if(cEvt.type == KeyboardEvent.KEY_DOWN)
         {
            switch(cEvt.keyCode)
            {
               case Keyboard.F12:
                  if(this.isDev())
                  {
                     this.visible = !this.visible;
                  }
               case Keyboard.NUMPAD_SUBTRACT:
                  if(this.isDev())
                  {
                     CFunctionCommonContainer.ForceCollectGarbage();
                  }
                  break;
               case Keyboard.ESCAPE:
                  break;
               case Keyboard.TAB:
                  cEvt.currentTarget.tabChildren = false;
                  break;
               case Keyboard.F1:
                  if(this.isDev())
                  {
                     this.toggleTip();
                  }
            }
         }
      }
      
      protected function isDev() : Boolean
      {
         return ScaleformUtil.isScaleform ? Boolean(CFunctionCommonContainer.IsDevelopmentBuild()) : true;
      }
   }
}


package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.manager.EventManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class AnimatedProductController extends BaseController
   {
      
      private static const LOADER_TICKER_INTERVAL:Number = 200;
      
      private var mAnimatedResource:Vector.<AnimatedResource>;
      
      private var mResourceWaiterList:Vector.<ResourceWaiter>;
      
      private var mLoadingQueue:Vector.<AnimatedResource>;
      
      private var mLoaderTicker:Timer;
      
      private var mLoaderIsBusy:Boolean;
      
      public function AnimatedProductController()
      {
         super();
         this.mAnimatedResource = new Vector.<AnimatedResource>();
         this.mResourceWaiterList = new Vector.<ResourceWaiter>();
         this.mLoadingQueue = new Vector.<AnimatedResource>();
         this.mLoaderIsBusy = false;
      }
      
      override protected function onInitialized() : void
      {
         this.mLoaderTicker = new Timer(LOADER_TICKER_INTERVAL);
         this.mLoaderTicker.addEventListener(TimerEvent.TIMER,this.onLoaderTickerTick);
         this.mLoaderTicker.start();
         listen(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,this.loadAnimatedProductHandler);
      }
      
      private function loadAnimatedProductHandler(evt:ParaEvent) : void
      {
         var productHolder:DisplayObjectContainer = evt.myPara.holder;
         var productName:String = this.normalizeResourceName(evt.myPara.name);
         var productSize:Point = evt.myPara.size;
         this.cleanupHolder(productHolder);
         var resource:AnimatedResource = this.getResource(productName);
         if(Boolean(resource))
         {
            if(resource.state == AnimatedResource.LOAD_SUCCESS)
            {
               this.shipAnimatedProduct(resource,productHolder,productSize);
            }
            else if(resource.state == AnimatedResource.LOAD_PROGRESS)
            {
               this.updateWaiterList(productName,productHolder,productSize);
            }
         }
         else
         {
            this.addNewLoadRequest(productName);
            this.updateWaiterList(productName,productHolder,productSize);
         }
      }
      
      private function normalizeResourceName(srcName:String) : String
      {
         return srcName.toLowerCase();
      }
      
      private function getResource(productName:String) : AnimatedResource
      {
         var resource:AnimatedResource = null;
         var resourceLen:int = int(this.mAnimatedResource.length);
         for(var i:int = 0; i < resourceLen; i++)
         {
            resource = this.mAnimatedResource[i];
            if(resource.name == productName)
            {
               return resource;
            }
         }
         return null;
      }
      
      private function shipAnimatedProduct(resource:AnimatedResource, holder:DisplayObjectContainer, size:Point) : void
      {
         var instance:DisplayObject = null;
         this.cleanupHolder(holder);
         if(resource.state != AnimatedResource.LOAD_SUCCESS)
         {
            return;
         }
         var resourceDef:Class = getDefinitionByName(resource.name) as Class;
         if(Boolean(resourceDef))
         {
            instance = new resourceDef();
            if(Boolean(size))
            {
               instance.width = size.x;
               instance.height = size.y;
            }
            holder.addChild(instance);
         }
      }
      
      private function updateWaiterList(productName:String, productHolder:DisplayObjectContainer, size:Point) : void
      {
         var resourceWaiter:ResourceWaiter = null;
         var waiterIndex:int = this.findExistWaiterIndexByHolder(productHolder);
         if(-1 != waiterIndex)
         {
            this.mResourceWaiterList[waiterIndex].name = productName;
         }
         else
         {
            resourceWaiter = new ResourceWaiter();
            resourceWaiter.name = productName;
            resourceWaiter.holder = productHolder;
            resourceWaiter.size = size;
            this.mResourceWaiterList.push(resourceWaiter);
         }
      }
      
      private function addNewLoadRequest(productName:String) : void
      {
         var newResource:AnimatedResource = new AnimatedResource(productName,this.onOneResourceLoadComplete);
         this.mAnimatedResource.push(newResource);
         this.enqueueLoadQueue(newResource);
      }
      
      private function cleanupHolder(holder:DisplayObjectContainer) : void
      {
         while(Boolean(holder.numChildren))
         {
            holder.removeChildAt(0);
         }
      }
      
      private function enqueueLoadQueue(resource:AnimatedResource) : void
      {
         this.mLoadingQueue.push(resource);
      }
      
      private function dequeueLoadQueue() : void
      {
         if(this.mLoadingQueue.length > 0)
         {
            this.mLoadingQueue.splice(0,1);
         }
      }
      
      private function findExistWaiterIndexByHolder(holder:DisplayObjectContainer) : int
      {
         var resourceWaiter:ResourceWaiter = null;
         var waiterLen:int = int(this.mResourceWaiterList.length);
         for(var i:int = 0; i < waiterLen; i++)
         {
            resourceWaiter = this.mResourceWaiterList[i];
            if(resourceWaiter.holder == holder)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function onLoaderTickerTick(timerEvent:TimerEvent) : void
      {
         var resource:AnimatedResource = null;
         if(this.mLoaderIsBusy)
         {
            return;
         }
         if(this.mLoadingQueue.length > 0)
         {
            resource = this.mLoadingQueue[0];
            resource.load();
            this.mLoaderIsBusy = true;
         }
      }
      
      private function onOneResourceLoadComplete(oneResource:AnimatedResource) : void
      {
         var waiter:ResourceWaiter = null;
         this.dequeueLoadQueue();
         var waiterLen:int = int(this.mResourceWaiterList.length);
         for(var i:int = waiterLen - 1; i >= 0; i--)
         {
            waiter = this.mResourceWaiterList[i];
            if(waiter.name == oneResource.name)
            {
               this.shipAnimatedProduct(oneResource,waiter.holder,waiter.size);
               this.mResourceWaiterList.splice(i,1);
            }
         }
         this.mLoaderIsBusy = false;
         EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT_COMPLETE);
      }
   }
}

import codo.common.CFunctionCommonContainer;
import codo.utils.Logger;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.getDefinitionByName;

class AnimatedResource
{
   
   public static const MOVIE_LOAD_FROM_SWF_DVAR:String = "ui_scaleform_swf";
   
   public static const ANIMATED_RESOURCE_SWF_PATH:String = "scaleform/default/animatedicons/";
   
   public static const ANIMATED_RESOURCE_GFX_PATH:String = "animatedicons/";
   
   public static const ANIMATED_RESOURCE_SUFFIX:String = ".gfx";
   
   public static const LOAD_PENDING:int = 0;
   
   public static const LOAD_PROGRESS:int = 1;
   
   public static const LOAD_SUCCESS:int = 3;
   
   public static const LOAD_FAIL:int = 4;
   
   public var name:String;
   
   public var state:int;
   
   private var mLoader:Loader;
   
   private var mLoadCompleteHandler:Function;
   
   private var mResourcePath:String;
   
   public function AnimatedResource(productName:String, loadCompleteHandler:Function)
   {
      super();
      this.state = LOAD_PENDING;
      this.name = productName;
      this.mLoadCompleteHandler = loadCompleteHandler;
      this.mResourcePath = ANIMATED_RESOURCE_GFX_PATH;
      if(Boolean(CFunctionCommonContainer.Dvar_GetBool(MOVIE_LOAD_FROM_SWF_DVAR)))
      {
         this.mResourcePath = ANIMATED_RESOURCE_SWF_PATH;
      }
   }
   
   public function load() : void
   {
      this.mLoader = new Loader();
      var urlRequest:URLRequest = new URLRequest(this.getRawResourcePath());
      var loadContext:LoaderContext = new LoaderContext();
      loadContext.applicationDomain = ApplicationDomain.currentDomain;
      this.mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadSuccess);
      this.mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
      Logger.print("Start loading animated product: ",this.getRawResourcePath());
      this.mLoader.load(urlRequest,loadContext);
      this.state = LOAD_PROGRESS;
   }
   
   public function shipAnimatedProduct(name:String, holder:DisplayObjectContainer) : void
   {
      var mc:MovieClip = null;
      var cls:Class = getDefinitionByName(name.toLowerCase()) as Class;
      if(Boolean(cls))
      {
         mc = new cls();
      }
      if(Boolean(mc))
      {
         holder.addChild(mc);
      }
   }
   
   private function onLoadSuccess(e:Event) : void
   {
      Logger.print("Load animated product success",this.name);
      this.state = LOAD_SUCCESS;
      this.onLoadRealComplete(true);
   }
   
   private function onLoadFailed(e:Event) : void
   {
      Logger.print("Load animated product failed",this.name);
      this.state = LOAD_FAIL;
      this.onLoadRealComplete(false);
   }
   
   private function onLoadRealComplete(success:Boolean) : void
   {
      if(this.mLoadCompleteHandler is Function)
      {
         this.mLoadCompleteHandler(this);
      }
   }
   
   private function getRawResourcePath() : String
   {
      return this.mResourcePath + this.name + ANIMATED_RESOURCE_SUFFIX;
   }
}

class ResourceWaiter
{
   
   public var name:String;
   
   public var holder:DisplayObjectContainer;
   
   public var size:Point;
   
   public function ResourceWaiter()
   {
      super();
   }
}

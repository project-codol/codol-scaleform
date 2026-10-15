package codo.component
{
   import codo.event.ImageLoaderEvent;
   import codo.event.ParaEvent;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ImageHolder extends MovieClip
   {
      
      private var m_loader:ImageHolderLoader;
      
      protected var m_imageWidth:Number;
      
      protected var m_imageHeight:Number;
      
      protected var m_keepRatio:Boolean = true;
      
      protected var m_aspectMax:Boolean = false;
      
      protected var mLoadedAsset:DisplayObject;
      
      public function ImageHolder()
      {
         super();
         this.m_imageWidth = width;
         this.m_imageHeight = height;
         this.m_loader = new ImageHolderLoader(this.onImageLoaded);
      }
      
      public function setImage(strImage:String = null) : void
      {
         if(strImage == null || strImage == "")
         {
            while(Boolean(numChildren))
            {
               removeChildAt(0);
            }
         }
         else
         {
            this.m_loader.load(strImage);
         }
      }
      
      public function clearImage() : void
      {
         this.m_loader.unload();
         while(Boolean(numChildren))
         {
            removeChildAt(0);
         }
      }
      
      public function set keepWHRatio(cSwi:Boolean) : void
      {
         this.m_keepRatio = cSwi;
      }
      
      public function set aspectMax(cSwi:Boolean) : void
      {
         this.m_aspectMax = cSwi;
      }
      
      protected function onImageLoaded(e:ImageLoaderEvent) : void
      {
         var bmpImage:DisplayObject = null;
         var m_scale:Number = NaN;
         this.clearChildDisplayObjects();
         bmpImage = e.m_displayObject;
         bmpImage.width = this.m_imageWidth;
         bmpImage.height = this.m_imageHeight;
         if(this.m_keepRatio == true)
         {
            m_scale = this.m_aspectMax == false ? Math.min(bmpImage.scaleX,bmpImage.scaleY) : Math.max(bmpImage.scaleX,bmpImage.scaleY);
            bmpImage.scaleY = bmpImage.scaleX = m_scale;
            bmpImage.x = (this.m_imageWidth - bmpImage.width) * 0.5;
            bmpImage.y = (this.m_imageHeight - bmpImage.height) * 0.5;
         }
         else
         {
            bmpImage.x = bmpImage.y = 0;
         }
         this.mLoadedAsset = addChild(bmpImage);
         this.displatchLoadComplete(e.m_status);
      }
      
      public function get loadedAsset() : DisplayObject
      {
         return this.mLoadedAsset;
      }
      
      protected function clearChildDisplayObjects() : void
      {
         while(Boolean(numChildren))
         {
            removeChildAt(0);
         }
      }
      
      protected function displatchLoadComplete(statusCode:uint) : void
      {
         dispatchEvent(new ParaEvent(Event.COMPLETE,{"status":statusCode}));
      }
   }
}

import codo.event.ImageLoaderEvent;
import codo.utils.Logger;
import codo.utils.ScaleformUtil;
import flash.display.*;
import flash.events.*;
import flash.net.URLRequest;
import flash.utils.getDefinitionByName;

class ImageHolderLoaderQueue
{
   
   private static var _instance:ImageHolderLoaderQueue;
   
   private var mQueue:Vector.<ImageHolderLoader>;
   
   public function ImageHolderLoaderQueue()
   {
      super();
      this.mQueue = new Vector.<ImageHolderLoader>();
   }
   
   public static function getInstance() : ImageHolderLoaderQueue
   {
      if(_instance == null)
      {
         _instance = new ImageHolderLoaderQueue();
      }
      return _instance;
   }
   
   private function loadNext() : void
   {
      if(this.mQueue.length > 0)
      {
         this.mQueue[0].beginLoading();
      }
   }
   
   public function addLoader(value:ImageHolderLoader) : void
   {
      var l:ImageHolderLoader = null;
      for each(l in this.mQueue)
      {
         if(l == value)
         {
            return;
         }
      }
      this.mQueue.push(value);
      this.loadNext();
   }
   
   public function removeLoader(value:ImageHolderLoader) : void
   {
      var func:Function = function(l:ImageHolderLoader, index:Number, vec:Vector.<ImageHolderLoader>):Boolean
      {
         if(l == value)
         {
            vec = vec.splice(index,1);
            return false;
         }
         return true;
      };
      this.mQueue.every(func);
      this.loadNext();
   }
}

class ImageHolderLoader
{
   
   private static var CLS_NONE_IMG:Class;
   
   private static const STATUS_IDLE:uint = 0;
   
   private static const STATUS_QUEUED:uint = 1;
   
   private static const STATUS_LOADING:uint = 2;
   
   private static const STATUS_COMPLETE:uint = 3;
   
   private static const STATUS_FAILED:uint = 4;
   
   private static const SRC_NONE_IMG:String = "ui_imiNoneImg";
   
   private var m_eventDispatcher:EventDispatcher;
   
   private var m_loader:Loader;
   
   private var m_urlRequest:URLRequest;
   
   private var m_loadingStatus:uint;
   
   public function ImageHolderLoader(callback:Function)
   {
      super();
      this.m_loadingStatus = STATUS_IDLE;
      this.m_eventDispatcher = new EventDispatcher();
      this.m_eventDispatcher.addEventListener(ImageLoaderEvent.TYPE,callback,false,0,true);
   }
   
   private static function getMissingImage() : Bitmap
   {
      if(CLS_NONE_IMG == null)
      {
         CLS_NONE_IMG = getDefinitionByName(SRC_NONE_IMG) as Class;
      }
      Logger.fatalErrorPrint("*****************getMissingImage");
      var e:Error = new Error();
      Logger.fatalErrorPrint(e.getStackTrace());
      return new Bitmap(new CLS_NONE_IMG());
   }
   
   private function getURL() : String
   {
      return Boolean(this.m_urlRequest) ? this.m_urlRequest.url : "";
   }
   
   private function dispatchMissingImage(status:uint) : void
   {
      var noneImage:Bitmap = getMissingImage();
      var event:ImageLoaderEvent = new ImageLoaderEvent(noneImage,status);
      this.m_eventDispatcher.dispatchEvent(event);
   }
   
   private function dispatchCompletedImage() : void
   {
      var event:ImageLoaderEvent = new ImageLoaderEvent(this.m_loader,ImageLoaderEvent.COMPLETE);
      this.m_eventDispatcher.dispatchEvent(event);
   }
   
   private function onCanceled(e:Event) : void
   {
      this.unload();
      this.m_loadingStatus = STATUS_FAILED;
      Logger.fatalErrorPrint("FsgImageHolder::onCanceled");
      this.dispatchMissingImage(ImageLoaderEvent.CANCELED);
   }
   
   private function onInit(e:Event) : void
   {
      this.m_loadingStatus = STATUS_COMPLETE;
      ImageHolderLoaderQueue.getInstance().removeLoader(this);
      this.dispatchCompletedImage();
   }
   
   private function onIOError(e:IOErrorEvent) : void
   {
      var targetLoaderInfo:LoaderInfo = e.target as LoaderInfo;
      if(Boolean(targetLoaderInfo))
      {
         Logger.fatalErrorPrint("ImageHolderLoader::onIOError 1 url:[" + targetLoaderInfo.url + "]");
      }
      Logger.fatalErrorPrint("ImageHolderLoader::onIOError 2:[" + e.toString() + "]");
      Logger.fatalErrorPrint("ImageHolderLoader::onIOError 3:[" + this.getURL() + "]");
      this.unload();
      this.m_loadingStatus = STATUS_FAILED;
      this.dispatchMissingImage(ImageLoaderEvent.IO_ERROR);
   }
   
   public function beginLoading() : void
   {
      if(this.m_loadingStatus == STATUS_QUEUED)
      {
         this.m_loadingStatus = STATUS_LOADING;
         this.m_loader.load(this.m_urlRequest);
      }
   }
   
   public function load(url:String) : void
   {
      if(url == null || url.length < 1 || url == "NONE")
      {
         this.unload();
         return;
      }
      if(url == "test_url" || url == "_s")
      {
         Logger.fatalErrorPrint("FsgImageHolder::load url is: " + url);
         this.unload();
         this.dispatchMissingImage(ImageLoaderEvent.COMPLETE);
         return;
      }
      var cFullURL:String = (ScaleformUtil.isScaleform ? "img://" : "") + url;
      if(this.m_loadingStatus != STATUS_FAILED && this.m_loader != null && this.getURL() == cFullURL)
      {
         if(this.m_loadingStatus == STATUS_COMPLETE)
         {
            this.dispatchCompletedImage();
         }
         return;
      }
      this.unload();
      this.m_urlRequest = new URLRequest(cFullURL);
      this.m_loader = new Loader();
      this.m_loader.contentLoaderInfo.addEventListener(Event.CANCEL,this.onCanceled,false,0,true);
      this.m_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
      this.m_loader.contentLoaderInfo.addEventListener(Event.INIT,this.onInit,false,0,true);
      this.m_loadingStatus = STATUS_QUEUED;
      ImageHolderLoaderQueue.getInstance().addLoader(this);
   }
   
   public function unload() : void
   {
      ImageHolderLoaderQueue.getInstance().removeLoader(this);
      this.m_urlRequest = null;
      if(this.m_loader != null)
      {
         this.m_loader.close();
         this.m_loader.unload();
         this.m_loader = null;
      }
      this.m_loadingStatus = STATUS_IDLE;
   }
}

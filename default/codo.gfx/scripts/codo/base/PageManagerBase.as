package codo.base
{
   import codo.constants.BCCommonEvent;
   import codo.constants.GameInfo;
   import codo.constants.ViewState;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.CodoPageLayerObj;
   import codo.objects.CodoPageObj;
   import codo.objects.CodoViewObj;
   import components.DepthSprite;
   import flash.display.Sprite;
   
   public class PageManagerBase extends ViewState
   {
      
      public var _container:Sprite;
      
      protected var _subContainer_general:DepthSprite;
      
      protected var _pages:Array;
      
      protected var _pageLayers:Array = [];
      
      protected var m_initialisedViews:Boolean;
      
      public function PageManagerBase()
      {
         super();
      }
      
      public function init(cContainer:Sprite) : void
      {
         this._container = cContainer;
         this._subContainer_general = new DepthSprite();
         this._subContainer_general.name = "subContainer_general";
         this._container.addChild(this._subContainer_general);
         this.m_initialisedViews = false;
         this.initAllPageLayers();
      }
      
      public function startUI(cParams:Object) : void
      {
         if(Boolean(cParams.ready) && this.m_initialisedViews == false)
         {
            this.initAllViews();
            this.m_initialisedViews = true;
         }
         this.initAllPageLayerSize();
      }
      
      public function set pages(pages:Array) : void
      {
         this._pages = pages;
      }
      
      public function showPage(cPageObj:CodoPageObj, cMask:Boolean = false, cStatus:int = 10, routeData:* = null) : void
      {
         var viewObj:CodoViewObj = null;
         var viewCls:Class = null;
         if(cPageObj != cPageObj.owner.currentPageObj)
         {
            this.cleanPageLayer(cPageObj.owner);
         }
         cPageObj.owner.currentPageObj = cPageObj;
         for each(viewObj in cPageObj.views)
         {
            if(viewObj.instance == null)
            {
               viewCls = viewObj.src as Class;
               viewObj.instance = new viewCls();
               viewObj.instance.initState(cStatus);
            }
            else
            {
               switch(cStatus)
               {
                  case ViewState.NONE:
                  case ViewState.ACTIVATED:
                     viewObj.instance.state = ViewState.ACTIVATED;
                     break;
                  default:
                     viewObj.instance.state = cStatus;
               }
            }
            if(routeData != null)
            {
               viewObj.instance.routeData = routeData;
            }
            viewObj.instance.pageID = cPageObj.id;
            cPageObj.owner.instance.addChild(viewObj.instance);
         }
      }
      
      public function cleanPageLayer(cPageLayerObj:CodoPageLayerObj) : void
      {
         var view:CodoViewObj = null;
         if(cPageLayerObj.currentPageObj != null)
         {
            for each(view in cPageLayerObj.currentPageObj.views)
            {
               if(view.instance != null && !this.moveViewToOtherLayer(cPageLayerObj,view))
               {
                  view.instance.state = ViewState.DEACTIVATED;
               }
            }
            this.onCleanPageViews(cPageLayerObj);
            cPageLayerObj.currentPageObj = null;
            cPageLayerObj.instance.hideATField();
            this.broadcast(BCCommonEvent.MASK_STATE_CHANGED,false);
         }
      }
      
      private function moveViewToOtherLayer(srcLayer:CodoPageLayerObj, view:CodoViewObj) : Boolean
      {
         var destLayer:CodoPageLayerObj = null;
         var destPage:CodoPageObj = null;
         var j:int = 0;
         for(var i:int = 0; i < this._pageLayers.length; i++)
         {
            destLayer = this._pageLayers[i];
            destPage = destLayer.currentPageObj;
            if(destLayer != srcLayer && destPage != null)
            {
               j = 0;
               while(j < destPage.views.length)
               {
                  if(destPage.views[j] == view)
                  {
                     destLayer.instance.addChild(view.instance);
                     return true;
                     break;
                  }
                  j++;
               }
            }
         }
         return false;
      }
      
      protected function onCleanPageViews(cPageLayerObj:CodoPageLayerObj) : void
      {
      }
      
      private function initAllPageLayers() : void
      {
         var pageLayerObj:CodoPageLayerObj = null;
         for each(pageLayerObj in this._pageLayers)
         {
            pageLayerObj.instance.name = pageLayerObj.name;
            this._subContainer_general.addChild(pageLayerObj.instance);
            pageLayerObj.instance.depth = pageLayerObj.depth;
         }
      }
      
      public function initAllPageLayerSize() : void
      {
         var pageLayerObj:CodoPageLayerObj = null;
         for each(pageLayerObj in this._pageLayers)
         {
            pageLayerObj.instance.changeSize(GameInfo.gameWidth,GameInfo.gameHeight);
         }
      }
      
      protected function initAllViews() : void
      {
         var pageObj:CodoPageObj = null;
         var views:Array = null;
         var viewObj:CodoViewObj = null;
         var viewCls:Class = null;
         if(this._pages != null && this._pages.length > 0)
         {
            for each(pageObj in this._pages)
            {
               views = pageObj.views;
               if(views != null)
               {
                  for each(viewObj in views)
                  {
                     viewCls = viewObj.src as Class;
                     if(viewObj.instance == null)
                     {
                        viewObj.instance = new viewCls();
                     }
                  }
               }
            }
         }
      }
      
      protected function getDP(cDataID:String, cParams:Array = null) : *
      {
         return DataManager.getInstance().getDP(cDataID,cParams);
      }
      
      protected function broadcast(cType:String, cData:* = null) : void
      {
         EventManager.getInstance().broadcast(cType,cData);
      }
   }
}


package codo.component.home
{
   import codo.component.PaginationTabList;
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.FeaturedAdObj;
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.utils.getDefinitionByName;
   
   public class HomeAdSlideShow extends MovieClip
   {
      
      private static const TAB_LIST_Y_OFFSET:Number = 3;
      
      public var myPaginationList:PaginationTabList;
      
      public var myAdMount:MovieClip;
      
      public var myStroke:MovieClip;
      
      public var myBackground:Sprite;
      
      private var mData:Vector.<FeaturedAdObj>;
      
      public function HomeAdSlideShow()
      {
         super();
         this.myPaginationList.addEventListener(Event.CHANGE,this.onAdPageChanged);
         this.myPaginationList.visible = false;
      }
      
      public function getData() : Vector.<FeaturedAdObj>
      {
         return this.mData;
      }
      
      public function setData(data:Vector.<FeaturedAdObj>) : void
      {
         var adItem:UIInteractiveComponent = null;
         var adClass:Class = null;
         this.clearAds();
         this.mData = data;
         var curX:Number = 0;
         var len:int = int(this.mData.length);
         for(var i:int = 0; i < len; i++)
         {
            adClass = getDefinitionByName(this.mData[i].itemLinkage) as Class;
            adItem = new adClass() as UIInteractiveComponent;
            adItem.setData(this.mData[i].itemData);
            this.myAdMount.addChild(adItem);
            adItem.x = curX;
            curX += adItem.width;
         }
         if(this.mData.length > 0)
         {
            this.myPaginationList.setNumPages(this.mData.length);
         }
         if(this.mData.length > 1)
         {
            this.myPaginationList.x = this.myBackground.x + this.myBackground.width - this.myPaginationList.width - GlobalGuide.COMPONENT_PADDING;
            this.myPaginationList.y = this.myBackground.y + this.myBackground.height - this.myPaginationList.height - GlobalGuide.COMPONENT_PADDING + TAB_LIST_Y_OFFSET;
            this.myPaginationList.visible = true;
         }
         else
         {
            this.myPaginationList.visible = false;
         }
      }
      
      public function get currentPage() : int
      {
         return this.myPaginationList.currentPage;
      }
      
      public function setStrokeColor(col:uint) : void
      {
         var newColor:ColorTransform = new ColorTransform();
         newColor.color = col;
         this.myStroke.transform.colorTransform = newColor;
      }
      
      private function clearAds() : void
      {
         while(this.myAdMount.numChildren > 0)
         {
            this.myAdMount.removeChildAt(0);
         }
      }
      
      private function updateContent() : void
      {
         var targetX:Number = -(this.myBackground.width * this.myPaginationList.currentPage);
         if(this.myPaginationList.autoPaged && this.myPaginationList.currentPage != 0)
         {
            TweenLite.to(this.myAdMount,0.3,{
               "x":targetX,
               "ease":Linear.easeInOut
            });
         }
         else
         {
            this.myAdMount.x = targetX;
         }
      }
      
      private function onAdPageChanged(e:Event) : void
      {
         this.updateContent();
      }
      
      public function stopTimer() : void
      {
         this.myPaginationList.stopTimer();
      }
      
      public function startTimer() : void
      {
         this.myPaginationList.startTimer();
      }
   }
}


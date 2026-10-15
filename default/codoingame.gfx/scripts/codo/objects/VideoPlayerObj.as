package codo.objects
{
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class VideoPlayerObj
   {
      
      public var videoPath:String;
      
      public var videoSize:Point;
      
      public var drawScrim:Boolean;
      
      public var videoCover:Bitmap;
      
      public var useLetterBox:Boolean;
      
      public function VideoPlayerObj(videoPath:String, videoSize:Point, videoCover:Bitmap = null, useLetterBox:Boolean = false)
      {
         super();
         this.videoPath = videoPath;
         this.videoSize = videoSize;
         this.videoCover = videoCover;
         this.useLetterBox = useLetterBox;
      }
   }
}


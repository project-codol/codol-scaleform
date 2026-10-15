package codo.objects
{
   public class GamemodeTutorialContentObj
   {
      
      public var mode:String;
      
      public var contentTitle:String;
      
      public var contentSubTitle:String;
      
      public var imagePath:String;
      
      public var videoPath:String;
      
      public function GamemodeTutorialContentObj(mode:String = null, contentTitle:String = null, contentSubTitle:String = null, imagePath:String = null, videoPath:String = null)
      {
         super();
         this.mode = mode;
         this.contentTitle = contentTitle;
         this.contentSubTitle = contentSubTitle;
         this.imagePath = imagePath;
         this.videoPath = videoPath;
      }
   }
}


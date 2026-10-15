package codo.interfaces
{
   public interface ISoundUtil
   {
      
      function playMusic(param1:String, param2:String) : void;
      
      function stopMusic() : void;
      
      function playSound(param1:String) : void;
      
      function stopSound() : void;
      
      function playSoundByFullName(param1:String, param2:uint, param3:uint = 0) : void;
   }
}


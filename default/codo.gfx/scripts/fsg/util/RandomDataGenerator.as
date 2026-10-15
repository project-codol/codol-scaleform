package fsg.util
{
   public class RandomDataGenerator
   {
      
      public function RandomDataGenerator()
      {
         super();
      }
      
      public static function generateRandomEmail() : String
      {
         var surnames:Array = ["Cantwell","Nordin","Straw","Aarons","Cali","Keatts","Murch","Kofoed","Rickards","Goley","Brogden","Byrge","Oppenheimer","Eldreth","Mehan","Vose","Boyland","Sauve","Lavery","Imler"];
         var fistNames:Array = ["Mira","Gillian","Roderick","Romona","Vannessa","Malka","Conrad","Ronna","Dayna","Elayne","Elvis","Floy","Myles","Keesha","Theron","Sammie","Jannet","Theodora","Jeana","Norris"];
         var randomFistName:String = surnames[int(Math.random() * fistNames.length)];
         var randomSurname:String = surnames[int(Math.random() * surnames.length)];
         return randomFistName + "." + randomSurname + "@fsgCODO.com";
      }
      
      public static function generateRandomSubject() : String
      {
         var subjects:Array = ["Drop everything.","Auto shows in China","ransom negotiations","Just because I’m too cheap to text you while I’m roaming doesn’t mean I love you any less.","Hair gel, deodorant and your heart","UTMOST IMPORTANCE: Predict things right now","I just want to celebrate, so come make me dinner.","Prime Minister Batman","Tasering our way to the zombie apocalypse","Clapping playlist – essential for saving the world"];
         return subjects[int(Math.random() * subjects.length)];
      }
      
      public static function randomMessageGenerator() : String
      {
         var messages:Array = ["Received shutters expenses ye he pleasant. Drift as blind above at up. No up simple county stairs do should praise as.\n\n" + "Drawings sir gay together landlord had law smallest. Formerly welcomed attended declared met say unlocked. Jennings outlived no dwelling denoting in peculiar as he believed. Behaviour excellent middleton be as it curiosity departure ourselves.\n","Lose eyes get fat shew. Winter can indeed letter oppose way change tended now. So is improve my charmed picture exposed adapted demands. Received had end produced prepared diverted strictly off man branched. Known ye money so large decay voice there to. Preserved be mr cordially incommode as an. He doors quick child an point at. Had share vexed front least style off why him.","Sportsman delighted improving dashwoods gay instantly happiness six. Ham now amounted absolute not mistaken way pleasant whatever." + "At an these still no dried folly stood thing." + "Rapid it on hours hills it seven years. If polite he active county in spirit an. Mrs ham intention promotion engrossed assurance defective. Confined so graceful building opinions whatever trifling in." + "Insisted out differed ham man endeavor expenses. At on he total their he songs. Related compact effects is on settled do.\n\n " + "Use securing confined his shutters. Delightful as he it acceptance an solicitude discretion reasonably. Carriage we husbands advanced an perceive greatest." + "Totally dearest expense on demesne ye he. Curiosity excellent commanded in me. Unpleasing impression themselves to at assistance acceptance my or. On consider laughter civility offended oh."];
         return messages[int(Math.random() * messages.length)];
      }
      
      public static function getRandomTimeBetweenDates(date1:Date, date2:Date) : Number
      {
         return Math.round(Math.random() * Math.abs(date2.time - date1.time));
      }
      
      public static function getRandomDate() : Date
      {
         var dat1:Date = new Date();
         var dat2:Date = new Date(1989,4,16);
         dat2.setTime(dat2.time + getRandomTimeBetweenDates(dat2,dat1));
         return dat2;
      }
      
      public static function getRandomDateAsGUIString() : String
      {
         var dat1:Date = new Date();
         var dat2:Date = new Date(1989,4,16);
         dat2.setTime(dat2.time + getRandomTimeBetweenDates(dat2,dat1));
         return dat2.toDateString();
      }
      
      public static function randomFirstName() : String
      {
         var fistNames:Array = ["Mira","Gillian","Roderick","Romona","Vannessa","Malka","Conrad","Ronna","Dayna","Elayne","Elvis","Floy","Myles","Keesha","Theron","Sammie","Jannet","Theodora","Jeana","Norris"];
         return fistNames[int(Math.random() * fistNames.length)];
      }
      
      public static function randomLastName() : String
      {
         var surnames:Array = ["Cantwell","Nordin","Straw","Aarons","Cali","Keatts","Murch","Kofoed","Rickards","Goley","Brogden","Byrge","Oppenheimer","Eldreth","Mehan","Vose","Boyland","Sauve","Lavery","Imler"];
         return surnames[int(Math.random() * surnames.length)];
      }
      
      public static function randomFullName() : String
      {
         return randomFirstName() + " " + randomLastName();
      }
      
      public static function randomRange(minNum:Number, maxNum:Number) : Number
      {
         return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum;
      }
      
      public static function trim(theNumber:Number, decPlaces:Number) : Number
      {
         var temp:Number = NaN;
         if(decPlaces >= 0)
         {
            temp = Math.pow(10,decPlaces);
            return Math.round(theNumber * temp) / temp;
         }
         return theNumber;
      }
   }
}


package fsg.util
{
   import codo.utils.Logger;
   import codo.utils.TableUtil;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class FsgUtil
   {
      
      public function FsgUtil()
      {
         super();
      }
      
      public static function clamp(val:Number, min:Number, max:Number) : Number
      {
         return Math.max(min,Math.min(max,val));
      }
      
      public static function commaFormatNumber(input:Number) : String
      {
         var split:Array = input.toString().split(".");
         var front:String = split[0];
         var back:String = split.length > 1 ? "." + split[1] : null;
         var n:int = input < 0 ? 2 : 1;
         var commas:int = Math.floor((front.length - n) / 3);
         for(var i:int = 1; i <= commas; )
         {
            n = front.length - (3 * i + i - 1);
            front = front.slice(0,n) + "," + front.slice(n);
            i++;
         }
         if(Boolean(back))
         {
            return front + back;
         }
         return front;
      }
      
      public static function truncate(val:Number, decimalPlaces:uint) : Number
      {
         var multiplier:uint = Math.pow(10,decimalPlaces);
         var truncatedVal:Number = val * multiplier;
         if(val > int.MAX_VALUE)
         {
            return Number(truncatedVal.toFixed(decimalPlaces));
         }
         return int(truncatedVal) / multiplier;
      }
      
      public static function getClass(obj:Object) : Class
      {
         return Class(getDefinitionByName(getQualifiedClassName(obj)));
      }
      
      public static function printStackTrace() : void
      {
         var e:Error = new Error();
         Logger.print(e.getStackTrace());
      }
      
      public static function getPrestigeIcon(iLevel:int) : String
      {
         var prestigeIconNames:Array = ["","prestige_01","prestige_02","prestige_03","prestige_04","prestige_05","prestige_06","prestige_07","prestige_08","prestige_09","prestige_10"];
         if(iLevel < 0)
         {
            return "";
         }
         if(iLevel >= prestigeIconNames.length)
         {
            return prestigeIconNames[prestigeIconNames.length - 1];
         }
         return prestigeIconNames[iLevel];
      }
      
      public static function getRankIcon(rank:int, prestige:int = 0) : String
      {
         var RANK_TABLE:String = null;
         var RANK_ID_COL:int = 0;
         var RANK_ICON_COL:int = 0;
         var rankIcon:String = "";
         if(prestige > 0)
         {
            rankIcon = getPrestigeIcon(prestige);
         }
         else
         {
            RANK_TABLE = "mp/rankIconTable.csv";
            RANK_ID_COL = 0;
            RANK_ICON_COL = 1;
            rankIcon = TableUtil.lookup(RANK_TABLE,RANK_ID_COL,rank.toString(),RANK_ICON_COL);
         }
         return rankIcon;
      }
      
      public static function getClanLevelIcon(level:int) : String
      {
         var clanIcons:Array = ["bronze_clan","silver_clan","gold_clan","platinum_clan","diamond_clan"];
         var index:int = level - 1;
         if(index >= 0 && index < clanIcons.length)
         {
            return clanIcons[index];
         }
         return clanIcons[0];
      }
      
      public static function sample(pointArray:Array, width:int, height:int, numCandidates:int = 10) : Point
      {
         var bestCandidate:Point = null;
         var c:Point = null;
         var closestSample:Point = null;
         var d:Number = NaN;
         var bestDistance:Number = 0;
         for(var i:int = 0; i < numCandidates; i++)
         {
            c = new Point((Math.random() - 0.5) * width,(Math.random() - 0.5) * height);
            closestSample = findClosest(c,pointArray);
            if(closestSample == null)
            {
               bestCandidate = c;
               break;
            }
            d = Point.distance(closestSample,c);
            if(d > bestDistance)
            {
               bestDistance = d;
               bestCandidate = c;
            }
         }
         return bestCandidate;
      }
      
      public static function findClosest(p:Point, arr:Array) : Point
      {
         var arrayPoint:Point = null;
         var distance:Number = NaN;
         var nearestPoint:Point = null;
         var nearestDistance:Number = Number.MAX_VALUE;
         for each(arrayPoint in arr)
         {
            distance = Point.distance(p,arrayPoint);
            if(distance < nearestDistance)
            {
               nearestDistance = distance;
               nearestPoint = arrayPoint;
            }
         }
         return nearestPoint;
      }
   }
}


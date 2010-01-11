/**
   West University of Timisoara
   Master; 2nd Year; Software Engineering
   10 January 2009

   Andrei Tolnai

   http://hmilab.wordpress.com/2009/11/18/hmi-proiect-1-music-player/
 */

package model
{

	public class Constants
	{
		public static var DASH_STRING:String="-";
		public static var EMPTY_STRING:String="";

		public static var ICON_PATH:String="/view/img/";
		public static var PLAY_ICON:String=ICON_PATH + "play-normal.png";
		public static var PAUSE_ICON:String=ICON_PATH + "pause-normal.png";
		public static var STOP_ICON:String=ICON_PATH + "stop-normal.png";

		public static var PLAY_MODE_:String="";
		public static var PLAY_MODE_REPEAT:String="repeat"
		public static var PLAY_MODE_SHUFLE:String="shuffle"

		public function Constants()
		{
		}
	}
}
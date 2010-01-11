/**
   West University of Timisoara
   Master; 2nd Year; Software Engineering
   10 January 2009

   Andrei Tolnai

   http://hmilab.wordpress.com/2009/11/18/hmi-proiect-1-music-player/
 */

package controller
{

	import mx.collections.ArrayCollection;
	import model.PlaylistEntry;

	public class PlaylistManager
	{
		[Bindable]
		public var playlist:ArrayCollection=new ArrayCollection();

		public var currentIndex:int=0;

		public function PlaylistManager()
		{
		}

		public function addFile(filePath:String):void
		{
			playlist.addItem(new PlaylistEntry(filePath));
		}

		public function clearPlaylist():void
		{
			playlist.removeAll();
		}

		public function removeEntry(elementIndex:int):void
		{
			playlist.removeItemAt(elementIndex);
		}

		public function getCurrentSong():PlaylistEntry
		{
			return playlist.getItemAt(currentIndex) as PlaylistEntry;
		}

		public function getNextSong(playMode:String):PlaylistEntry
		{
			function randomInRange(min:Number, max:Number):Number
			{
				var scale:Number=max - min;
				return Math.random() * scale + min;
			}

			if (playMode == "repeat")
			{
				if (currentIndex == playlist.length - 1)
				{
					currentIndex=0;
				}
				else
				{
					currentIndex++;
				}
			}
			else if (playMode == "shuffle")
			{
				currentIndex=randomInRange(0, playlist.length);
			}
			else
			{
				if (currentIndex < playlist.length - 1)
				{
					currentIndex++;
				}
			}
			return playlist.getItemAt(currentIndex) as PlaylistEntry;
		}

	}
}
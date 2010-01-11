/**
   West University of Timisoara
   Master; 2nd Year; Software Engineering
   10 January 2009

   Andrei Tolnai

   http://hmilab.wordpress.com/2009/11/18/hmi-proiect-1-music-player/
 */

package model
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.ID3Info
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	public class PlaylistEntry
	{
		[Bindable]
		public var artistName:String;

		[Bindable]
		public var songName:String;

		[Bindable]
		public var albumName:String;

		[Bindable]
		public var filePath:String;

		public function PlaylistEntry(filePath:String)
		{
			if (filePath != null && filePath.length > 0)
			{
				this.filePath=filePath;
				var sound:Sound=new Sound();
				var soundLoaderContext:SoundLoaderContext;
				sound=new Sound();
				sound.addEventListener(Event.ID3, sound_id3);
				//sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				sound.load(new URLRequest(filePath));
			}
		}

		private function sound_id3(evt:Event):void
		{
			var id3Info:ID3Info=Sound(evt.currentTarget).id3 as ID3Info;
			this.artistName=id3Info.artist;
			this.songName=id3Info.songName;
			this.albumName=id3Info.album;
		}
	}
}
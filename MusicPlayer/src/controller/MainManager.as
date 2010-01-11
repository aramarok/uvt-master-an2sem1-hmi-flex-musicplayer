/**
   West University of Timisoara
   Master; 2nd Year; Software Engineering
   10 January 2009

   Andrei Tolnai

   http://hmilab.wordpress.com/2009/11/18/hmi-proiect-1-music-player/
 */

package controller
{
	import flash.events.*;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	import model.Constants;
	import model.PlaylistEntry;

	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.core.UIComponent;

	public class MainManager extends UIComponent
	{

		[Bindable]
		public var playPauseButtonIcon:String=Constants.PLAY_ICON;
		[Bindable]
		public var stopButtonIcon:String=Constants.STOP_ICON;

		private var sound:Sound;
		private var soundChannel:SoundChannel;

		public var soundLengthInMiliseconds:int;
		public var soundCurrentTimeInMiliseconds:int;
		public var soundChannelPositionInMiliseconds_forPause:int;

		public var isPlaying:Boolean=false;
		public var isStoped:Boolean=true;


		public var id3Info:ID3Info;

		[Bindable]
		public var artistString:String=Constants.DASH_STRING;

		[Bindable]
		public var songString:String=Constants.DASH_STRING;

		[Bindable]
		public var albumString:String=Constants.DASH_STRING;


		[Bindable]
		public var showTimeElapsed:Boolean=true;


		[Bindable]
		public var playingTime:String="-";

		[Bindable]
		public var timeElapsed:String="-";

		[Bindable]
		public var timeRemaining:String="-";


		public var updateSliderCurrentValue:Boolean=true;

		[Bindable]
		public var sliderMaximumValue:Number;

		[Bindable]
		public var sliderCurrentValue:Number;

		public var playMode:String;

		private var playlistManager:PlaylistManager;
		private var dataGrid:DataGrid;

		public function MainManager(playlistManager:PlaylistManager, dataGrid:DataGrid)
		{
			this.playlistManager=playlistManager;
			this.dataGrid=dataGrid;
			soundChannelPositionInMiliseconds_forPause=0;
		}

		private function ioErrorHandler(event:Event):void
		{
			Alert.show(event.toString(), "Error");
		}

		private function onEnterFrame(event:Event):void
		{
			soundLengthInMiliseconds=Math.ceil(sound.length / (sound.bytesLoaded / sound.bytesTotal));
			soundCurrentTimeInMiliseconds=soundChannel.position;

			var date:Date=new Date(soundCurrentTimeInMiliseconds);
			timeElapsed=Constants.EMPTY_STRING;
			/*if (date.getHours() > 0)
			   {
			   timeElapsed+=date.getHours() + ":";
			 }*/
			timeElapsed+=date.getMinutes() + ":" + date.getSeconds();

			if (updateSliderCurrentValue)
			{
				sliderCurrentValue=date.getMinutes() + date.getSeconds() / 100;
			}

			date=new Date(soundLengthInMiliseconds);
			playingTime=Constants.EMPTY_STRING;
			/*if (date.getHours() > 0)
			   {
			   playingTime+=date.getHours() + ":";
			 }*/
			playingTime+=date.getMinutes() + ":" + date.getSeconds();

			sliderMaximumValue=date.getMinutes() + date.getSeconds() / 100;

			date=new Date(soundLengthInMiliseconds - soundChannel.position);
			timeRemaining=Constants.EMPTY_STRING;
			/*if (date.getHours() > 0)
			   {
			   timeRemaining+=date.getHours() + ":";
			 }*/
			timeRemaining+=date.getMinutes() + ":" + date.getSeconds();


			initInfo();
		}

		private function onPlaybackComplete(event:Event):void
		{
			this.play(playlistManager.getNextSong(this.playMode));
			this.dataGrid.selectedIndex=playlistManager.currentIndex;
		}


		private function initInfo():void
		{
			this.id3Info=sound.id3;
			artistString=sound.id3.artist;
			songString=sound.id3.songName;
			albumString=sound.id3.album;
		}

		public function play(playlistEntry:PlaylistEntry):void
		{
			if (soundChannel != null)
			{
				soundChannel.stop();
			}
			sound=new Sound();
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			sound.load(new URLRequest(playlistEntry.filePath));
			soundChannel=sound.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			isPlaying=true;
			isStoped=false;
			playPauseButtonIcon=Constants.PAUSE_ICON;
		}

		public function continuePlaying():void
		{
			if (!isPlaying && sound != null)
			{
				soundChannel=sound.play(soundChannelPositionInMiliseconds_forPause);
				soundChannel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				isPlaying=true;
				isStoped=false;
				playPauseButtonIcon=Constants.PAUSE_ICON;
			}
		}

		public function pause():void
		{
			if (soundChannel != null)
			{
				soundChannelPositionInMiliseconds_forPause=soundChannel.position;
				soundChannel.stop();

				isPlaying=false;
				isStoped=false;
				playPauseButtonIcon=Constants.PLAY_ICON;
			}

		}

		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);

			soundChannelPositionInMiliseconds_forPause=0;

			if (soundChannel != null)
				soundChannel.stop();

			soundLengthInMiliseconds=0;
			soundCurrentTimeInMiliseconds=0;
			sliderMaximumValue=0;
			sliderCurrentValue=0;
			timeElapsed="-";
			timeRemaining="-";

			isPlaying=false;
			isStoped=true;
			playPauseButtonIcon=Constants.PLAY_ICON;
		}
	}


}
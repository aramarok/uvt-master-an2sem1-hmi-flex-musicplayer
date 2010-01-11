// ActionScript file

/**
   West University of Timisoara
   Master; 2nd Year; Software Engineering
   10 January 2009

   Andrei Tolnai

   http://hmilab.wordpress.com/2009/11/18/hmi-proiect-1-music-player/
 */

import mx.containers.TitleWindow;
import mx.controls.*;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.utils.ObjectUtil;
import controller.*;
import model.*;
import spark.events.TrackBaseEvent;
import spark.events.IndexChangeEvent;



[Bindable]
public var playlistManager:PlaylistManager;

[Bindable]
public var mainManager:MainManager;



protected function initializea():void
{
	playlistManager=new PlaylistManager;
	mainManager=new MainManager(playlistManager, datagrid);

	//playlistManager.addFile("C:/Documents and Settings/Administrator/Desktop/Flex4_workspace/MusicPlayer/src/music/Clint Mansell - Requiem for a Dream.mp3");
	//playlistManager.addFile("C:/Documents and Settings/Administrator/Desktop/Flex4_workspace/MusicPlayer/src/music/Shakira - Underneath Your Clothes.mp3");
	//playlistManager.addFile("C:/Documents and Settings/Administrator/Desktop/Flex4_workspace/MusicPlayer/src/music/Haddaway - What Is Love.mp3");
	//playlistManager.addFile("C:/Documents and Settings/Administrator/Desktop/Flex4_workspace/MusicPlayer/src/music/ATB - Marrakech.mp3");
	//playlistManager.addFile("C:/Documents and Settings/Administrator/Desktop/Flex4_workspace/MusicPlayer/src/music/ATB - Humanity.mp3");

	addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
}

private function nextSong():void
{
	if (playlistManager.playlist.length > 0)
	{
		mainManager.play(playlistManager.getNextSong(playmode.selectedItem));
		datagrid.selectedIndex=playlistManager.currentIndex;
	}
}

protected function onKeyPressed(event:KeyboardEvent):void
{
	if (event.keyCode == Keyboard.DELETE)
	{
		deleteSelection();
	}
}

protected function onDataGridDoubleClick(event:ListEvent):void
{
	playlistManager.currentIndex=event.rowIndex;
	mainManager.play(event.currentTarget.selectedItem);
}

protected function onTimeClick(event:MouseEvent):void
{
	mainManager.showTimeElapsed=!mainManager.showTimeElapsed;
}

private function onPlayPauseButtonPress():void
{
	if (playlistManager.playlist.length > 0)
	{
		if (mainManager.isPlaying == true)
		{
			mainManager.pause();
		}
		else
		{
			if (mainManager.soundChannelPositionInMiliseconds_forPause == 0)
			{
				mainManager.play(playlistManager.getCurrentSong());
			}
			else
			{
				mainManager.continuePlaying();
			}
		}
	}
}

private function onStopButtonPress():void
{
	mainManager.stop();
}

protected function playmodeDropDownChange(event:IndexChangeEvent):void
{
	if (mainManager != null && event != null && event.currentTarget)
	{
		mainManager.playMode=event.currentTarget.selectedItem;
	}
}

protected function hSliderThumbPress(event:TrackBaseEvent):void
{
	mainManager.updateSliderCurrentValue=false;
}

protected function hSliderThumbRelease(event:TrackBaseEvent):void
{
	var minutes:int=hSlider.value;
	var seconds:int=(hSlider.value - minutes) * 100;
	mainManager.pause();
	var date:Date=new Date(mainManager.soundChannelPositionInMiliseconds_forPause);
	date.setMinutes(minutes);
	date.setSeconds(seconds);
	mainManager.soundChannelPositionInMiliseconds_forPause=date.time;
	mainManager.continuePlaying();
	mainManager.updateSliderCurrentValue=true;
}

protected function hSliderChange(event:Event):void
{
	if (mainManager.isStoped == false)
	{
		mainManager.updateSliderCurrentValue=false;
		var minutes:int=hSlider.value;
		var seconds:int=(hSlider.value - minutes) * 100;
		mainManager.pause();
		var date:Date=new Date(mainManager.soundChannelPositionInMiliseconds_forPause);
		date.setMinutes(minutes);
		date.setSeconds(seconds);
		mainManager.soundChannelPositionInMiliseconds_forPause=date.time;
		mainManager.continuePlaying();
		mainManager.updateSliderCurrentValue=true;
	}
}

private function id3Info():void
{
	var id3infopopup:TitleWindow;
	var textArea:TextArea=new TextArea();
	textArea.text=ObjectUtil.toString(mainManager.id3Info);
	textArea.width=300;
	textArea.height=350;
	textArea.editable=false;


	id3infopopup=new TitleWindow();
	id3infopopup.title="ID3 Info";
	id3infopopup.showCloseButton=true;
	id3infopopup.width=350;
	id3infopopup.height=400;
	id3infopopup.addEventListener(CloseEvent.CLOSE, id3InfoClose);
	id3infopopup.addChild(textArea);

	PopUpManager.addPopUp(id3infopopup, this, true);
	PopUpManager.centerPopUp(id3infopopup);

	function id3InfoClose(evt:CloseEvent):void
	{
		PopUpManager.removePopUp(id3infopopup);
	}
}


private function addFile():void
{
	var filesToOpen:File=File.applicationDirectory;

	var txtFilter:FileFilter=new FileFilter("Music files", "*.mp3;*.wma");
	filesToOpen.browseForOpenMultiple("Select file(s)", [txtFilter]);
	filesToOpen.addEventListener(FileListEvent.SELECT_MULTIPLE, fileSelected);

	function fileSelected(event:FileListEvent):void
	{
		for (var i:uint=0; i < event.files.length; i++)
		{
			playlistManager.addFile(event.files[i].nativePath);
		}
	}

}

public function addFolder():void
{
	var src:File=File.applicationDirectory;
	src.browseForDirectory("Select a directory");
	src.addEventListener(Event.SELECT, directorySelected);

	function directorySelected(event:Event):void
	{
		var directory:File=event.target as File;
		var files:Array=directory.getDirectoryListing();
		for (var i:uint=0; i < files.length; i++)
		{
			if (files[i].extension.toLowerCase() == "mp3" || files[i].extension.toLowerCase() == "wma")
			{
				playlistManager.addFile(files[i].nativePath);
			}
		}
	}
}

public function clearPlaylist():void
{
	playlistManager.clearPlaylist();
}

public function deleteSelection():void
{
	var array:Array;
	array=datagrid.selectedIndices;
	for (var i:int=0; i < array.length; i++)
	{
		playlistManager.removeEntry(array[i]);
	}
}
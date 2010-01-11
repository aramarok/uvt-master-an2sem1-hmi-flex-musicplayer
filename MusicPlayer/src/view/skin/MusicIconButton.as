package view.skin {
	import spark.components.Button;

	[Style(name="icon", type="String", inherit="no")]
	public class MusicIconButton extends Button {
		public function MusicIconButton() {
			super();
			
			buttonMode = true;
			setStyle("skinClass", PlayPauseStopButtonSkin);
		}
	}
}
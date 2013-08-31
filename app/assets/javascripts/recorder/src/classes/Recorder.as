package classes
{
	[Bindable] public class Recorder
	{
		public var maxLength:int=90;
		public var fileName:String="video";
		public var width:int=800;
		public var height:int=600;
		public var server:String="rtmp://localhost/oflaDemo/";
		public var fps:int=30;
		public var microRate:int=100;
		public var showVolume:Boolean=true;
		public var recordingText:String="Recording...";
		public var timeLeftText:String="Time Left:";
		public var timeLeft:int;
		public var mode:String="record";
		public var hasRecorded:Boolean=false;
		public var backToRecorder:Boolean=true;
		public var backText:String="Back";
		public var cameraDetected:Boolean=false;
		
		public function Recorder()
		{	timeLeft = maxLength;
			mode="record";
			/*this.maxLength = maxLength;
			this.fileName = fileName;
			this.width = width;
			this.height = height;
			this.server = server;*/
		}

	}
}

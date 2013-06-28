		package { //1
			import flash.display.Sprite;
			import flash.display.StageAlign;
			import flash.display.StageScaleMode;
			import flash.events.*;
			import flash.media.Camera;
			import flash.media.Video;
			import flash.media.Microphone;
			import flash.system.Security;
			import flash.net.NetConnection;
			import flash.net.NetStream;
			import flash.events.NetStatusEvent;
			import flash.text.TextField;
			import flash.display.Loader;
			import flash.display.LoaderInfo;
			import flash.utils.Timer;
			import lib.buttons.CustomButton;


		//System.security.allowDomain("*");				


		public class CameraDemo extends Sprite
	 	{ //2
	 		private var video:Video;
	 		private var camera:Camera = Camera.getCamera();
	 		private var mic:Microphone = Microphone.getMicrophone();
	 		private var button1:Sprite = new Sprite();
	 		private var button2:Sprite = new Sprite();
	 		private var nc:NetConnection; 
	 		private var ns:NetStream;
	 		private var stream_name:String;
				//private var method:Function = getStreamName;
				private var paramObj:Object = root.loaderInfo.parameters.myVariable;
				private var streamName:String;
				private var paramObj1:Object = root.loaderInfo.parameters.railsEnv;
				private var rails_env:String;
				private var myTimer:Timer = new Timer(1000, 10);
				
			public function CameraDemo()
		  	{ //3
		  		streamName = paramObj.toString();
		  		rails_env = paramObj1.toString();
		  		trace(rails_env);						
			//ExternalInterface.addCallback("getStreamName", getStreamName);						
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;  
			Security.showSettings("2");

	        if (camera != null) { //4
	        	camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
	        	video = new Video(camera.width * 2, camera.height * 2);
	        	video.attachCamera(camera);
	        	addChild(video);
	        } 
	        else
	         { // 5
	         	trace("You need a camera.");
	         } 

			if (mic != null) {//6
				mic.setUseEchoSuppression(true);
				mic.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
				mic.addEventListener(StatusEvent.STATUS, statusHandler);
			}													
			else
			{ //7
				trace("No microphone");	
			}

			drawButton1();
			button1.addEventListener(MouseEvent.MOUSE_DOWN, startRecord);
			addChild(button1);
			drawButton2();
			button2.addEventListener(MouseEvent.MOUSE_DOWN, stopRecord);
			addChild(button2);
			myTimer.addEventListener(TimerEvent.TIMER, recordVideo);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishRecording);
		}

		    private function activityHandler(event:ActivityEvent):void { //8
	        	trace("activityHandler: " + event);
	        }

			private function statusHandler(event:StatusEvent):void { //9
				trace("statusHandler: " + event);
			}

			private function drawButton1():void {
				var textLabel1:TextField = new TextField()
				button1.graphics.clear();
	        button1.graphics.beginFill(0xD4D4D4); // grey color
	        button1.graphics.drawRoundRect(0, 0, 80, 25, 10, 10); // x, y, width, height, ellipseW, ellipseH
	        button1.graphics.endFill();
	        textLabel1.text = "Record";
	        textLabel1.x = 10;
	        textLabel1.y = 5;
	        textLabel1.selectable = false;
	        button1.addChild(textLabel1)
	    }
	    private function drawButton2():void
	    {
	    	var textLabel2:TextField = new TextField()
	    	button2.graphics.clear();
              button2.graphics.beginFill(0xD4D4D4); // grey color
              button2.graphics.drawRoundRect(100, 0, 80, 25, 10, 10); // x, y, width, height, ellipseW, ellipseH
              button2.graphics.endFill();
              textLabel2.text = "Stop";
              textLabel2.x = 105;
              textLabel2.y = 5;
              textLabel2.selectable = false;
              button2.addChild(textLabel2)
          }
          // Sart Record Starts	
          private function startRecord(event:MouseEvent):void
          {
          	myTimer.start();
          	nc = new NetConnection();
          	if( rails_env == "development")
          	{
          		nc.connect("rtmp://localhost/oflaDemo");						
          	}
          	else
          	{
          		nc.connect("rtmp://red5.qwinixtech.com/oflaDemo");						
          	}					

          	nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            } // ENDS

          private function stopRecord(event:MouseEvent):void
          {
          	trace("Now we're disconnecting");
          	nc.close();
          }

          private function publishLiveStream():void {
          	ns = new NetStream(nc);							
          	if (camera != null && mic != null) {						
          		ns.attachAudio(mic);								
          		ns.attachCamera(camera);	
          		ns.publish(streamName, "record");
          	}
          	else 
          	{
          		trace("not active");
          	}		
          	
          }

          private function netStatusHandler(event:NetStatusEvent):void
          {
          	trace("connected is: " + nc.connected );
          	trace("event.info.level: " + event.info.level);
          	trace("event.info.code: " + event.info.code);

          	switch (event.info.code)
          	{
          		case "NetConnection.Connect.Success":
          		trace("Congratulations! you're connected");
          		publishLiveStream();
          		break;
          		case "NetConnection.Connect.Rejected":
          		trace ("Oops! the connection was rejected");
          		break;
          		case "NetStream.Play.Stop":
          		trace("The stream has finished playing");
          		break;
          		case "NetStream.Play.StreamNotFound":
          		trace("The server could not find the stream you specified"); 
          		break;
          		case "NetStream.Publish.Start":
          		case "NetStream.Publish.BadName":
          		trace("The stream name is already used");
          		break;
          	}
          }

          private function recordVideo(event:TimerEvent):void
          {
          	
          	
          }

          private function finishRecording(event:TimerEvent):void 
          {
          	trace("Now we're disconnecting");
          	nc.close();
          	myTimer.stop();
          }

      }
  }
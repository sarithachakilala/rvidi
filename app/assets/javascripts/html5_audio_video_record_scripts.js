// Script to record Audio Starts
$(document).ready(function(){

  $('.cameo-form').on("click", "#voice_record",function(){
    $('.audio-record').removeClass('hide');
  });

});

window.URL = window.URL || window.webkitURL;
navigator.getUserMedia  = navigator.getUserMedia || 
                          navigator.webkitGetUserMedia || 
                          navigator.mozGetUserMedia || 
                          navigator.msGetUserMedia;

var recorder;
var audio = document.querySelector('audio');
var audioBlob = null;

var onFail = function(e) {
  console.log('Rejected!', e);
};

var onSuccess = function(s) {
  var context = new webkitAudioContext();
  var mediaStreamSource = context.createMediaStreamSource(s);
  recorder = new Recorder(mediaStreamSource);
  recorder.record();

  // audio loopback
  // mediaStreamSource.connect(context.destination);
}

function startRecording() {
  if (navigator.getUserMedia) {
    navigator.getUserMedia({audio: true, video: true}, onSuccess, onFail);
  } else {
    console.log('navigator.getUserMedia not present');
  }
}

function stopRecording() {
  recorder.stop();
  recorder.exportWAV(function(s) {
    audio.src = window.URL.createObjectURL(s);
    audioBlob = s;
  });
}
// Script to record Audio Ends

// Script to record Video Starts
// Content to show Recorder Starts, using HTML5
// REF: http://ericbidelman.tumblr.com/post/31486670538/creating-webm-video-from-getusermedia
(function(exports) {

exports.URL = exports.URL || exports.webkitURL;

exports.requestAnimationFrame = exports.requestAnimationFrame ||
    exports.webkitRequestAnimationFrame || exports.mozRequestAnimationFrame ||
    exports.msRequestAnimationFrame || exports.oRequestAnimationFrame;

exports.cancelAnimationFrame = exports.cancelAnimationFrame ||
    exports.webkitCancelAnimationFrame || exports.mozCancelAnimationFrame ||
    exports.msCancelAnimationFrame || exports.oCancelAnimationFrame;

// navigator.getUserMedia = navigator.getUserMedia ||
//     navigator.webkitGetUserMedia || navigator.mozGetUserMedia ||
//     navigator.msGetUserMedia;

var ORIGINAL_DOC_TITLE = document.title;
var video = $$$('video');
var canvas = document.createElement('canvas'); // offscreen canvas.
var rafId = null;
var startTime = null;
var endTime = null;
var frames = [];
var videoBlob = null;

$(document).on('click', 'button.publish-cameo-btn',function(e){
  e.preventDefault();
  var current_form = $(this).parents('.cameo-form').first();
  submitFormWithBlob(current_form);
});

$(document).on('click', 'input.publish-show-btn',function(e){
  e.preventDefault();
  var current_form = $('.show-cameo-form').first();
  submitShowFormWithBlob(current_form);
});

function $$$(selector){
  return document.querySelector(selector) || null;
}

function toggleActivateRecordButton() {
  var b = $$$('#record-me');
  b.textContent = b.disabled ? 'Record' : 'Recording...';
  b.classList.toggle('recording');
  b.disabled = !b.disabled;
}

function turnOnCamera(e) {
  e.target.disabled = true;
  $$$('#record-me').disabled = false;
  $('.video-record').removeClass('hide');

  video.controls = false;

  var finishVideoSetup_ = function() {
    // Note: video.onloadedmetadata doesn't fire in Chrome when using getUserMedia so
    // we have to use setTimeout. See crbug.com/110938.
    setTimeout(function() {
      video.width = 320;//video.clientWidth;
      video.height = 240;// video.clientHeight;
      // Canvas is 1/2 for performance. Otherwise, getImageData() readback is
      // awful 100ms+ as 640x480.
      canvas.width = video.width;
      canvas.height = video.height;
    }, 1000);
  };

  // navigator.getUserMedia('audio,video', function(stream) {
  navigator.getUserMedia({video: true, audio: true, toString : function() {return "video,audio";}}, function(stream) {

    video.src = window.URL.createObjectURL(stream);
    finishVideoSetup_();
  }, function(e) {
    alert('Fine, you get a movie instead of your beautiful face ;)');

    // video.src = 'Chrome_ImF.mp4';
    // finishVideoSetup_();
  });
};

function record() {
  var elapsedTime = $$$('#elasped-time');
  var ctx = canvas.getContext('2d');

  var CANVAS_HEIGHT = canvas.height;
  var CANVAS_WIDTH = canvas.width;

  frames = []; // clear existing frames;
  startTime = Date.now();

  toggleActivateRecordButton();
  $$$('#stop-me').disabled = false;

  function drawVideoFrame_(time) {
    rafId = requestAnimationFrame(drawVideoFrame_);

    ctx.drawImage(video, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);

    document.title = 'Recording...' + Math.round((Date.now() - startTime) / 1000) + 's';

    // Read back canvas as webp.
    //console.time('canvas.dataURL() took');
    var url = canvas.toDataURL('image/webp', 1); // image/jpeg is way faster :(
    //console.timeEnd('canvas.dataURL() took');
    frames.push(url);
 
    // UInt8ClampedArray (for Worker).
    //frames.push(ctx.getImageData(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT).data);

    // ImageData
    //frames.push(ctx.getImageData(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT));
  };
  rafId = requestAnimationFrame(drawVideoFrame_);
};

function stop() {
  cancelAnimationFrame(rafId);
  endTime = Date.now();
  $$$('#stop-me').disabled = true;
  document.title = ORIGINAL_DOC_TITLE;

  toggleActivateRecordButton();

  console.log('frames captured: ' + frames.length + ' => ' +
              ((endTime - startTime) / 1000) + 's video');

};

// Functions for saving form with blob objects STARTS
function submitFormWithBlob(form_elem){
  var target_url = form_elem.prop('action');
  // Script to save blob object to Server APPROACH03 STARTS. ======================

  var fd = new FormData();
  fd.append('cameo[user_id]', $$$(".cameo-user-id").value);
  fd.append('cameo[show_id]', $$$(".cameo-show-id").value);
  fd.append('cameo[director_id]', $$$(".cameo-director-id").value);

  if(frames.length > 0){
    var videoBlob = Whammy.fromImageArray(frames, 1000 / 60);    
  }
  // fd.append('from', $$$(".cameo-from").value);
  // $$$('.recorded-video-input').valueideoBlob);
  console.log('blob obj is  -------> '+videoBlob);
  fd.append('cameo[recorded_file]', (videoBlob || ''));
  fd.append('cameo[audio_file]', audioBlob);
  fd.append('cameo[video_file]', ($$$(".cameo-video-file").value));

  if(videoBlob){
    $.ajax({
      type: 'POST',
      url: target_url,
      data: fd,
      dataType: 'script',
      processData: false,
      contentType: false
    }).done(function(data){
      // console.log(data);
    });
  }else{
    form_elem.submit();
  }
}

function submitShowFormWithBlob(form_elem){

  var target_url = form_elem.prop('action');
  // Script to save blob object to Server APPROACH03 STARTS. ======================

  var fd = new FormData();
  fd.append('show[user_id]', $$$(".show-user-id").value);
  fd.append('show[title]', $$$(".show-title").value);
  fd.append('show[description]', $$$(".show-description").value);
  fd.append('show[display_preferences]', $$$(".show-display-preferences").value);
  fd.append('show[display_preferences_password]', $$$(".show-display-preferences-password").value);
  fd.append('show[contributor_preferences]', $$$(".show-display-preferences").value);
  fd.append('show[contributor_preferences_password]', $$$(".show-display-preferences").value);
  fd.append('show[show_tag]', $$$(".show-display-preferences").value);
  fd.append('show[need_review]', $$$(".show-display-preferences").value);

  fd.append('show[cameos_attributes][0][user_id]', $$$(".show-cameo-user-id").value);
  fd.append('show[cameos_attributes][0][director_id]', $$$(".show-cameo-director-id").value);
  fd.append('show[cameos_attributes][0][status]', $$$(".show-cameo-status").value);

  if(frames.length > 0){
    var videoBlob = Whammy.fromImageArray(frames, 1000 / 60);    
  }
  // fd.append('from', $$$(".show-from").value);
  // $$$('.recorded-video-input').valueideoBlob);
  console.log('blob obj is  -------> '+videoBlob);
  fd.append('show[cameos_attributes][0][recorded_file]', (videoBlob || ''));
  fd.append('show[cameos_attributes][0][audio_file]', audioBlob);
  fd.append('show[cameos_attributes][0][video_file]', ($$$(".show-cameo-video-file").value));

  if(videoBlob){
    $.ajax({
      type: 'POST',
      url: target_url,
      data: fd,
      dataType: 'script',
      processData: false,
      contentType: false
    }).done(function(data){
      // console.log(data);
    });
  }else{
    form_elem.submit();
  }
}
// Functions for saving form with blob objects ENDS


function embedVideoPreview(opt_url) {
  var url = opt_url || null;
  var video = $$$('#video-preview video') || null;
  var downloadLink = $$$('#video-preview a[download]') || null;

  if (!video) {
    video = document.createElement('video');
    video.autoplay = true;
    video.controls = true;
    video.loop = true;
    //video.style.position = 'absolute';
    //video.style.top = '70px';
    //video.style.left = '10px';
    video.style.width = canvas.width + 'px';
    video.style.height = canvas.height + 'px';
    $$$('#video-preview').appendChild(video);
    
    downloadLink = document.createElement('a');
    downloadLink.download = 'capture.webm';
    downloadLink.textContent = '[ download video ]';
    downloadLink.title = 'Download your .webm video';
    var p = document.createElement('p');
    p.appendChild(downloadLink);

    $$$('#video-preview').appendChild(p);

  } else {
    window.URL.revokeObjectURL(video.src);
  }

  // https://github.com/antimatter15/whammy
  // var encoder = new Whammy.Video(1000/60);
  // frames.forEach(function(dataURL, i) {
  //   encoder.add(dataURL);
  // });
  // var webmBlob = encoder.compile();

  if (!url) {
    var webmBlob = Whammy.fromImageArray(frames, 1000 / 60);
    // url = window.URL.createObjectURL(webmBlob);
  }

  video.src = url;
  downloadLink.href = url;
}

// function initEvents() {
//   $$$('#camera-me').addEventListener('click', turnOnCamera);
//   $$$('#record-me').addEventListener('click', record);
//   $$$('#stop-me').addEventListener('click', stop);
// }

//initEvents();

exports.$$$ = $$$;

})(window);
// Script to record Video Starts

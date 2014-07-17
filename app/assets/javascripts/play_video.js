$(function() {
    var video_tag = $('#video');
    var play_video_btn = $('#play_video_btn');

    function play_video() {
        var video = video_tag.get(0);
        if (video.paused) {
            video.play();
        } else {
            video.pause();
        }
    }

    play_video_btn.click(function(event) {
        event.preventDefault();
        play_video();
    });

    video_tag.click(function(){
        play_video();
    });

    video_tag.bind('pause', function() {
        if (!$(this).get(0).seeking) {
            play_video_btn.html('Watch Now');
        }
     });

    video_tag.bind('play', function() {
        play_video_btn.html('Pause');
        video_tag.unbind('click');
        video_tag.attr('controls', 'controls');
    });
});
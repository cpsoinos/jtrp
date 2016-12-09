$(document).on('turbolinks:load', function() {

  {
    jQuery('#slideshow0 > div').camera({
    alignment:"center",
    autoAdvance:true,
    mobileAutoAdvance:true,
    barDirection:"leftToRight",
    barPosition:"bottom",
    cols:6,
    easing:"easeInOutExpo",
    mobileEasing:"easeInOutExpo",
    fx:"random",
    mobileFx:"random",
    gridDifference:250,
    height:"auto",
    hover:true,
    loader:"pie",
    loaderColor:"#eeeeee",
    loaderBgColor:"#222222",
    loaderOpacity:0.3,
    loaderPadding:2,
    loaderStroke:7,
    minHeight:"200px",
    navigation:true,
    navigationHover:true,
    mobileNavHover:true,
    opacityOnGrid:false,
    overlayer:true,
    pagination:true,
    pauseOnClick:true,
    playPause:true,
    pieDiameter:38,
    piePosition:"rightTop",
    portrait:false,
    rows:4,
    slicedCols:12,
    slicedRows:8,
    slideOn:"random",
    thumbnails:false,
    time:7000,
    transPeriod:1500,
    imagePath: '../image/'
  });
  }

});

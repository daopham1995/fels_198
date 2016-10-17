$("document").ready(function(){
  $("#button-checkbox").click(function(){
    $value = $(this).attr("value");
    if($value == "0"){
      $(this).next().next().prop('checked', true);
      $(this).attr("value","1");
      $(this).attr("class","btn btn-info");
      $("#button-checkbox i").attr("class",
        "state-icon glyphicon glyphicon-check");
    }
    else if($value == "1"){
      $(this).next().next().prop('checked', false);
      $(this).attr("value","0");
      $(this).attr("class","btn btn-default");
      $("#button-checkbox i").attr("class",
        "state-icon glyphicon glyphicon-unchecked");
    }
  });
});

$(document).on("ready", function(){
  $counter = setInterval(timer, 1000);
});

$(document).on("turbolinks:load", function() {
  notification();
  prepareClock();
  selectAnswer();
  showProcess();
  $("#button-checkbox").click(function(){
    $value = $(this).attr("value");
    if($value == "0"){
      $(this).next().next().prop("checked", true);
      $(this).attr("value","1");
      $(this).attr("class","btn btn-info");
      $("#button-checkbox i").attr("class",
        "state-icon glyphicon glyphicon-check");
    }
    else if($value == "1"){
      $(this).next().next().prop("checked", false);
      $(this).attr("value","0");
      $(this).attr("class","btn btn-default");
      $("#button-checkbox i").attr("class",
        "state-icon glyphicon glyphicon-unchecked");
    }
  });

  $("#answer_field").on("click", ".remove_fields", function(event){
    var temp=$(this);
    if(remove_true_answer(temp)){
      if(check_default_answer()){
        $(this).prev("input[type=hidden]").val("1");
        $(this).parent().parent().hide();
        change_number_answer(0);
      }else{
        alert("Word must have more 2 answer!");
      }
    }else{
      alert("Can't remove true answer!");
    }
    event.preventDefault();
  });

  $(".add_fields").click(function(event){
    time = new Date().getTime();
    regexp = new RegExp($(this).data("id"), "g")
    $(this).before($(this).data("fields").replace(regexp,time))
    change_number_answer(1);
    event.preventDefault();
  });

  function change_number_answer(operation){
    var temp=$(".number_answer").val();
    temp = parseInt(temp, 10);
    if(operation==0){
      $(".number_answer").val(temp - 1) ;
    }else{
      $(".number_answer").val(temp + 1) ;
    }
  };

  function check_default_answer(){
    if($(".number_answer").val() < 3){
      return false;
    }else{
      return true;
    }
  };

  function remove_true_answer(temp) {
    if($(temp).parent().prev().find(".check_box").is(":checked")){
      return false;
    }else{
      return true;
    }
  }
});

function timer()
{
  $secondes--;
  if ($secondes < 0)
    {
      if ($minutes == 0){
        clearInterval($counter);
        $("form").submit();
      }
      $secondes = 59;
      $minutes--;
    }
 $("#timer").html($minutes + ":" + $secondes);
}

function prepareClock(){
  $duration = parseInt($("#lesson_duration").attr("value"));
  $minutes = Math.floor($duration/60);
  $secondes = $duration - ($minutes * 60);
}


function createNotification(data){
  activity =
    "<li>"+
      "<span class='label label-default'>"+ data.user +"</span>"+
      "<span class='label label-info'>"+ data.action +"</span>"+
      "<span class='label label-default'>"+ data.target +"</span>"+
    "</li>";
  return activity;
}

function notification(){
  $("#notification").click(function(){
    $url = $(this).attr("url");
    $.ajax($url,"json").success(function(data){
      list = "";
      for(i=0; i<data.length; i++){
        list += createNotification(data[i]);
      }
      $("#notify").html(list);
    });
  });
}

function selectAnswer(){
  $("form .list-word input[type=radio]").click(function(){
    showProcess();
    result = $(this).parent().parent().next().attr("value");
    answer = $(this).attr("value");
    $.ajax({
      method: "patch",
      url: $("form").attr("action"),
      data: { "select_answer": {"result": result, "answer": answer}}
    }).done(function( json ) {
      if (json.status == "saved" ) {
        alert = "<div class='label label-success select_alert' >auto saved</div>";
        $("body").append(alert);
        $(".select_alert").fadeOut(3000);
      }
    });
  });
}

function showProcess(){
  all = $("input[type=radio]").size() / 4;
  select = $("input[type=radio]:checked").size();
  $("#process").html(select +"/"+ all);
}

$(document).on("turbolinks:load", function() {
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

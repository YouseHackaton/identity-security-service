$('#calendar').datepicker({
		});

$("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
    });

$(function(){
  $('body').on('click', '.alert .close', function(e){
    e.preventDefault();
    var $this = $(this);
    $this.parents('.alert').first().remove();
  });
});

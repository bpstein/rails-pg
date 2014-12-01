// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require bootstrap
//= require turbolinks
//= require_tree .


$(window).ready(function(){
      var nowTemp = new Date();
      var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
      var checkin = $('#checkin').datepicker({
        format: 'yyyy/mm/dd',
        onRender: function(date) {
          return date.valueOf() < now.valueOf() ? 'disabled' : '';
        }
      }).on('changeDate', function(ev) {
         var check_out = $("#checkout").val();
         if(check_out.length>0 && ev.date.valueOf() > checkout.date.valueOf()){
          alert("Please make sure the start date comes before the end date");
         }
        
          var newDate = new Date(ev.date)
          newDate.setDate(newDate.getDate() + 1);
          checkout.setValue(newDate);
          $("#checkout").val('');
        
           checkin.hide();
        
      }).data('datepicker');
      var checkout = $('#checkout').datepicker({
        format: 'yyyy/mm/dd',
        onRender: function(date) {
           return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
           
        }
      }).on('changeDate', function(ev) {
        checkout.hide();
        if (ev.date.valueOf() < checkin.date.valueOf()){
           alert("Please make sure the start date comes before the end date");
        }
      }).data('datepicker');
});       